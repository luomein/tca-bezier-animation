//
//  MultiLayerBezierCurveReducer.swift
//  tca-bezier-animation
//
//  Created by MEI YIN LO on 2022/12/19.
//

import Foundation
import ComposableArchitecture
import IdentifiedCollections
import MultipleTimeSeriesReducer

struct MultiLayerBezierCurveReducer : ReducerProtocol{
    @Dependency(\.environmentVariables) var environmentVariables
    @Dependency(\.uuid) var uuid
    struct State: Equatable {
        var controlPoints: MultipleTimeSeriesReducer.State = .initFromOrigin(points: [])
        
        var bezier1st: BezierTimeSeriesPointsReducer.State = .init(drawingOption: loadData(bundleFileName: "DefaultBezier1stDrawingOption", userDefaultsKeyName: SnapShotJsonFileName.bezier1st.rawValue) )
                                                                    //loadJsonFromBundle(filename: "DefaultBezier1stDrawingOption"))
            //.init(trace: .initFromOrigin(points: []))
        var bezier2nd: BezierTimeSeriesPointsReducer.State = .init(drawingOption: loadData(bundleFileName: "DefaultBezier2ndDrawingOption", userDefaultsKeyName: SnapShotJsonFileName.bezier2nd.rawValue) )
            //.init(drawingOption: loadJsonFromBundle(filename: "DefaultBezier2ndDrawingOption"))
        var bezier3rd: BezierTimeSeriesPointsReducer.State = .init(drawingOption: loadData(bundleFileName: "DefaultBezier3rdDrawingOption", userDefaultsKeyName: SnapShotJsonFileName.bezier3rd.rawValue) )
            //.init(drawingOption: loadJsonFromBundle(filename: "DefaultBezier3rdDrawingOption"))
        
        static func loadData(bundleFileName: String, userDefaultsKeyName: String)->BezierTimeSeriesDrawingOption{
            var drawingOption : BezierTimeSeriesDrawingOption!
            if let data = UserDefaults.standard.object(forKey: userDefaultsKeyName) as? Data{
                drawingOption = loadJsonFromData(data: data)
            }
            else{
                drawingOption = loadJsonFromBundle(filename: bundleFileName)
            }
            return drawingOption
        }
        static func clearTrace(state: inout State){
            state.bezier1st.trace =  .initFromOrigin(points: [])
            state.bezier2nd.trace =  .initFromOrigin(points: [])
            state.bezier3rd.trace =  .initFromOrigin(points: []) 
        }
    }
//    func initBezier1stDefaultParameter()->BezierTimeSeriesPointsReducer.State{
//        return .init(trace: .initFromOrigin(points: []))
//    }
    
    enum Action : Equatable{
        case recalculateTrace(tick: Double, totalTicks: Double)
        case calculateNewPoint(t:Double)
        case notificationPosizitionChanged
        case jointControlPointsReducer(MultipleTimeSeriesReducer.Action)
        case jointBezier1stReducer(BezierTimeSeriesPointsReducer.Action)
        case jointBezier2ndReducer(BezierTimeSeriesPointsReducer.Action)
        case jointBezier3rdReducer(BezierTimeSeriesPointsReducer.Action)
        case saveState(Data, String)
    }
    struct DebounceID : Hashable{}
    var body: some ReducerProtocol<State, Action> {
        Scope(state: \.controlPoints, action: /Action.jointControlPointsReducer) {
            MultipleTimeSeriesReducer()
            
        }
        Scope(state: \.bezier1st, action: /Action.jointBezier1stReducer) {
            BezierTimeSeriesPointsReducer()
        }
        Scope(state: \.bezier2nd, action: /Action.jointBezier2ndReducer) {
            BezierTimeSeriesPointsReducer()
        }
        Scope(state: \.bezier3rd, action: /Action.jointBezier3rdReducer) {
            BezierTimeSeriesPointsReducer()
        }
        Reduce{state, action  in
            switch action{
            case .jointControlPointsReducer(let subAction):
                switch subAction{
                case .notificationPosizitionChanged:
                    return EffectTask(value: .notificationPosizitionChanged)
                default:
                    let data = RichPoint.encodedFromState(state: state.controlPoints.multipleSeries.map({$0.timeSeries.last!}))
                    let keyName = SnapShotJsonFileName.controlPoints.rawValue
                    return EffectTask(value: .saveState(data, keyName))
                        .debounce(id: DebounceID(), for: 1, scheduler: DispatchQueue.main)
                }
            case .calculateNewPoint(let t):
                calculateNewPoint(t: t, state: &state)
                return .none
            case .recalculateTrace(let tick, let totalTicks):
                State.clearTrace(state:   &state)
                for i in 0...Int(tick){
                    let t = Double(i) / Double(totalTicks)
                    calculateNewPoint(t: t, state: &state)
                }
                return .none
            case .saveState(let data, let keyName):
                saveDataToUserDefaults(data, keyName: keyName)
                return .none
            case .jointBezier1stReducer:
                let data = BezierTimeSeriesDrawingOption.encodedFromState(state:state.bezier1st)
                let keyName = SnapShotJsonFileName.bezier1st.rawValue
                return EffectTask(value: .saveState(data, keyName))
                    .debounce(id: DebounceID(), for: 1, scheduler: DispatchQueue.main)
            case .jointBezier2ndReducer:
                let data = BezierTimeSeriesDrawingOption.encodedFromState(state:state.bezier2nd)
                let keyName = SnapShotJsonFileName.bezier2nd.rawValue
                return EffectTask(value: .saveState(data, keyName))
                    .debounce(id: DebounceID(), for: 1, scheduler: DispatchQueue.main)
            case .jointBezier3rdReducer:
                let data = BezierTimeSeriesDrawingOption.encodedFromState(state:state.bezier3rd)
                let keyName = SnapShotJsonFileName.bezier3rd.rawValue
                return EffectTask(value: .saveState(data, keyName))
                    .debounce(id: DebounceID(), for: 1, scheduler: DispatchQueue.main)
            default:
                return .none
            }
        }
    }
    static func zipT<T>(_ data: [[T]])->[[T]]{
            let count = data.first!.count
        let initArray : [[T]] = Array(repeating: [], count: count)
            let reduced : [[T]] = data.reduce(initArray, {
                Array(zip($0,$1)).map({
                    var arrayCopied : [T] = $0.0
                    arrayCopied.append( $0.1 )
                    return arrayCopied
                })
            })
            return reduced
        }
    static func zipAny(_ data: [[Any]])->[[Any]]{
        let count = data.first!.count
        let initArray = Array(repeating: [], count: count)
        let reduced : [[Any]] = data.reduce(initArray, {
            Array(zip($0,$1)).map({
                var arrayCopied : [Any] = $0.0
                arrayCopied.append( $0.1 )
                return arrayCopied
            })
        })
        return reduced
    }

    func calculateLocation(start:CGPoint, end:CGPoint, t: Double)->CGPoint{
            return CGPoint(x: (1.0-t) * start.x + t * end.x , y:  (1.0-t) * start.y + t * end.y )
        }
    func calculateNewPoint(t: Double, state: inout State){
        calculateNewPoint(referencePoints: state.controlPoints, t: t, state: &state.bezier1st.trace)
        calculateNewPoint(referencePoints: state.bezier1st.trace, t: t, state: &state.bezier2nd.trace)
        calculateNewPoint(referencePoints: state.bezier2nd.trace, t: t, state: &state.bezier3rd.trace)
    }
        func calculateNewPoint(referencePoints: MultipleTimeSeriesReducer.State, t: Double, state: inout MultipleTimeSeriesReducer.State){
            //assert(referencePoints.multipleSeries.count>=2)
            guard referencePoints.multipleSeries.count >= 2 else{return}
            var referencePointsCopy = referencePoints
            var tempPt = referencePointsCopy.multipleSeries.removeFirst().timeSeries.last!
            let result = referencePointsCopy.multipleSeries.reduce([CGPoint]()) { partialResult, element in
                
                let combined = partialResult + [calculateLocation(start: tempPt.point, end: element.timeSeries.last!.point, t: t)]
                tempPt = element.timeSeries.last!
                return combined
            }
            if state.multipleSeries.count > 0 {
                let combined = Array(zip(state.multipleSeries, result))
                state.multipleSeries = IdentifiedArray(uniqueElements:
                                                        combined.map({
                    SingleTimeSeriesReducer.State(id: $0.0.id, timeSeries: $0.0.timeSeries +
                                                        SingleTimeSeriesReducer.State.initFromOrigin(point: $0.1,
                                                                                                           stateId: uuid(), pointID: uuid()                                          ).timeSeries
                    )
                })
                                                       )

            }else{
                state.multipleSeries = IdentifiedArray(uniqueElements: result.map({ //IdentifiedCGPointArray(id: uuid(), ptArray:  [$0] )
                    SingleTimeSeriesReducer.State.initFromOrigin(point: $0,
                    stateId: uuid(), pointID: uuid()
                    )
                    
                }) )
            }
        }
}
