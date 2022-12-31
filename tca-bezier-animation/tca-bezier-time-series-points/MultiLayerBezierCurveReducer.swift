//
//  MultiLayerBezierCurveReducer.swift
//  tca-bezier-animation
//
//  Created by MEI YIN LO on 2022/12/31.
//

import Foundation
import BezierTimeSeriesReducer
import MultipleTimeSeriesReducer
import LuomeinSwiftBasicTools
import ComposableArchitecture

extension MultiLayerBezierCurveReducer:ReducerProtocol{
    
    public struct State: Equatable {
        var controlPoints: MultipleTimeSeriesReducer.State = .initFromOrigin(points: [])
        
        var bezier1st: SingleBezierTimeSeriesReducer.State = .init(drawingOption: loadData(bundleFileName: "DefaultBezier1stDrawingOption", userDefaultsKeyName: SnapShotJsonFileName.bezier1st.rawValue) )
                                                                    //loadJsonFromBundle(filename: "DefaultBezier1stDrawingOption"))
            //.init(trace: .initFromOrigin(points: []))
        var bezier2nd: SingleBezierTimeSeriesReducer.State = .init(drawingOption: loadData(bundleFileName: "DefaultBezier2ndDrawingOption", userDefaultsKeyName: SnapShotJsonFileName.bezier2nd.rawValue) )
            //.init(drawingOption: loadJsonFromBundle(filename: "DefaultBezier2ndDrawingOption"))
        var bezier3rd: SingleBezierTimeSeriesReducer.State = .init(drawingOption: loadData(bundleFileName: "DefaultBezier3rdDrawingOption", userDefaultsKeyName: SnapShotJsonFileName.bezier3rd.rawValue) )
            //.init(drawingOption: loadJsonFromBundle(filename: "DefaultBezier3rdDrawingOption"))
        
        static func loadData(bundleFileName: String, userDefaultsKeyName: String)->BezierTimeSeriesDrawingOption{
            var drawingOption : BezierTimeSeriesDrawingOption!
            if let data = UserDefaults.standard.object(forKey: userDefaultsKeyName) as? Data{
                drawingOption = loadJsonFromData(data: data)
            }
            else{
                drawingOption = loadJsonFromBundle(filename: bundleFileName, bundle: Bundle.main)
            }
            return drawingOption
        }
        static func clearTrace(state: inout State){
            state.bezier1st.trace =  .initFromOrigin(points: [])
            state.bezier2nd.trace =  .initFromOrigin(points: [])
            state.bezier3rd.trace =  .initFromOrigin(points: [])
        }
    }
    public var body: some ReducerProtocol<State, Action> {
        Scope(state: \.controlPoints, action: /Action.jointControlPointsReducer) {
            MultipleTimeSeriesReducer()
            
        }
        Scope(state: \.bezier1st, action: /Action.jointBezier1stReducer) {
            SingleBezierTimeSeriesReducer()
        }
        Scope(state: \.bezier2nd, action: /Action.jointBezier2ndReducer) {
            SingleBezierTimeSeriesReducer()
        }
        Scope(state: \.bezier3rd, action: /Action.jointBezier3rdReducer) {
            SingleBezierTimeSeriesReducer()
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
    public func calculateNewPoint(t: Double, state: inout State){
        calculateNewPoint(referencePoints: state.controlPoints, t: t, state: &state.bezier1st.trace)
        calculateNewPoint(referencePoints: state.bezier1st.trace, t: t, state: &state.bezier2nd.trace)
        calculateNewPoint(referencePoints: state.bezier2nd.trace, t: t, state: &state.bezier3rd.trace)
    }
}
