//
//  MultiLayerBezierCurveReducer.swift
//  tca-bezier-animation
//
//  Created by MEI YIN LO on 2022/12/19.
//

import Foundation
import ComposableArchitecture
import IdentifiedCollections

struct MultiLayerBezierCurveReducer : ReducerProtocol{
    @Dependency(\.environmentVariables) var environmentVariables
    @Dependency(\.uuid) var uuid
    struct State: Equatable {
        var controlPoints: MultipleTimeSeriesPointsReducer.State = .initFromOrigin(points: [])
        
        var bezier1st: BezierTimeSeriesPointsReducer.State = .init(trace: .initFromOrigin(points: []))
        var bezier2st: BezierTimeSeriesPointsReducer.State = .init(trace: .initFromOrigin(points: []))
        var bezier3st: BezierTimeSeriesPointsReducer.State = .init(trace: .initFromOrigin(points: []))
        
        static func clearTrace(state: inout State){
            state.bezier1st.trace =  .initFromOrigin(points: [])
            state.bezier2st.trace =  .initFromOrigin(points: [])
            state.bezier3st.trace =  .initFromOrigin(points: []) 
        }
    }
//    func initBezier1stDefaultParameter()->BezierTimeSeriesPointsReducer.State{
//        return .init(trace: .initFromOrigin(points: []))
//    }
    
    enum Action : Equatable{
        case recalculateTrace(tick: Double, totalTicks: Double)
        case calculateNewPoint(t:Double)
        case notificationPosizitionChanged
        case jointControlPointsReducer(MultipleTimeSeriesPointsReducer.Action)
        case jointBezier1stReducer(BezierTimeSeriesPointsReducer.Action)
        case jointBezier2stReducer(BezierTimeSeriesPointsReducer.Action)
        case jointBezier3stReducer(BezierTimeSeriesPointsReducer.Action)
    }
    var body: some ReducerProtocol<State, Action> {
        Scope(state: \.controlPoints, action: /Action.jointControlPointsReducer) {
            MultipleTimeSeriesPointsReducer()
            
        }
        Scope(state: \.bezier1st, action: /Action.jointBezier1stReducer) {
            BezierTimeSeriesPointsReducer()
        }
        Scope(state: \.bezier2st, action: /Action.jointBezier2stReducer) {
            BezierTimeSeriesPointsReducer()
        }
        Scope(state: \.bezier3st, action: /Action.jointBezier3stReducer) {
            BezierTimeSeriesPointsReducer()
        }
        Reduce{state, action  in
            switch action{
            case .jointControlPointsReducer(let subAction):
                switch subAction{
                case .notificationPosizitionChanged:
                    return EffectTask(value: .notificationPosizitionChanged)
                default:
                    return .none
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
        calculateNewPoint(referencePoints: state.bezier1st.trace, t: t, state: &state.bezier2st.trace)
        calculateNewPoint(referencePoints: state.bezier2st.trace, t: t, state: &state.bezier3st.trace)
    }
        func calculateNewPoint(referencePoints: MultipleTimeSeriesPointsReducer.State, t: Double, state: inout MultipleTimeSeriesPointsReducer.State){
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
                    SingleTimeSeriesPointsReducer.State(id: $0.0.id, timeSeries: $0.0.timeSeries +
                                                        SingleTimeSeriesPointsReducer.State.initFromOrigin(point: $0.1,
                                                                                                           stateId: uuid(), pointID: uuid()                                          ).timeSeries
                    )
                })
                                                       )

            }else{
                state.multipleSeries = IdentifiedArray(uniqueElements: result.map({ //IdentifiedCGPointArray(id: uuid(), ptArray:  [$0] )
                    SingleTimeSeriesPointsReducer.State.initFromOrigin(point: $0,
                    stateId: uuid(), pointID: uuid()
                    )
                    
                }) )
            }
        }
}
