//
//  ContainerReducer.swift
//  tca-bezier-animation
//
//  Created by MEI YIN LO on 2022/12/17.
//

import Foundation
import ComposableArchitecture
import SwiftUI
import IdentifiedCollections

struct ContainerReducer: ReducerProtocol {
    //@Dependency(\.environmentVariables) var environmentVariables
    
    private class EnvironmentVariablesWrapper{
        var cachedEnvironmentVariables = EnvironmentVariables()
    }
    
    private var environmentVariablesWrapper = EnvironmentVariablesWrapper()
    
    struct State: Equatable {
        //var controlPoints: MultipleTimeSeriesPointsReducer.State
        var timer = VariableSpeedTimerReducer.State()

//        var bezier1st: BezierTimeSeriesPointsReducer.State = .init(trace: .initFromOrigin(points: []))
//        var bezier2st: BezierTimeSeriesPointsReducer.State = .init(trace: .initFromOrigin(points: []))
//        var bezier3st: BezierTimeSeriesPointsReducer.State = .init(trace: .initFromOrigin(points: []))
        var bezierCurve : MultiLayerBezierCurveReducer.State = .init()
    }
    enum Action : Equatable{
        case appearOnCanvas(CGSize)
        case redraw(MultipleTimeSeriesPointsReducer.State)
        case setEnvironmentVariables(EnvironmentVariables)
        
        case jointTimerReducer(VariableSpeedTimerReducer.Action)
        case jointBezierCurveReducer(MultiLayerBezierCurveReducer.Action)
//        case jointControlPointsReducer(MultipleTimeSeriesPointsReducer.Action)
//        case jointBezier1stReducer(BezierTimeSeriesPointsReducer.Action)
//        case jointBezier2stReducer(BezierTimeSeriesPointsReducer.Action)
//        case jointBezier3stReducer(BezierTimeSeriesPointsReducer.Action)
        
    }
//    func reduce(into state: inout State, action: Action) -> EffectTask<Action> {

//    }
//    func clearTrace(state: inout State){
//        BezierTimeSeriesPointsReducer.State.clearTrace(trace: &state.bezier1st.trace)
//    }
    struct DebounceID : Hashable{}
    var body: some ReducerProtocol<State, Action> {
        Scope(state: \.timer, action: /Action.jointTimerReducer) {
            VariableSpeedTimerReducer()
                
        }
        Scope(state: \.bezierCurve, action: /Action.jointBezierCurveReducer) {
            MultiLayerBezierCurveReducer()
                .dependency(\.environmentVariables, environmentVariablesWrapper.cachedEnvironmentVariables)
        }
//        Scope(state: \.controlPoints, action: /Action.jointControlPointsReducer) {
//            MultipleTimeSeriesPointsReducer()
//                .dependency(\.environmentVariables, environmentVariablesWrapper.cachedEnvironmentVariables)
//        }
//        Scope(state: \.bezier1st, action: /Action.jointBezier1stReducer) {
//            BezierTimeSeriesPointsReducer()
//        }
//        Scope(state: \.bezier2st, action: /Action.jointBezier2stReducer) {
//            BezierTimeSeriesPointsReducer()
//        }
//        Scope(state: \.bezier3st, action: /Action.jointBezier3stReducer) {
//            BezierTimeSeriesPointsReducer()
//        }
        Reduce{state, action  in
            switch action{
            case .redraw(let controlPoints):
                state.bezierCurve.controlPoints = controlPoints
                return EffectTask(value: .jointTimerReducer(.startFromTick(0)))
            case .setEnvironmentVariables(let value):
                environmentVariablesWrapper.cachedEnvironmentVariables = value
                return .none

            case .appearOnCanvas(let value):
                if state.bezierCurve.controlPoints.multipleSeries.isEmpty{
                    let controlPoints = MultipleTimeSeriesPointsReducer.State.initFromGeometry(size: value)
                    return EffectTask(value: .redraw(controlPoints))
                }
                return .none
            case .jointTimerReducer(let timerAction):
                switch timerAction{
                case .startFromTick(let tick):
                    return
                    EffectTask(value: .jointBezierCurveReducer(.recalculateTrace(tick: tick, totalTicks: state.timer.totalTicks)))
//                        .debounce(id: DebounceID(), for: 0.1, scheduler: DispatchQueue.main)
                case .stepForward:
                    return
                        EffectTask(value: .jointBezierCurveReducer(.calculateNewPoint(t:state.timer.t)))
                default:
                    return .none
                }
            case .jointBezierCurveReducer(let subAction):
                switch subAction{
                case .notificationPosizitionChanged:
                    return EffectTask(value: .jointTimerReducer(.startFromTick(0)))
                default:
                    return .none
                }
//            case .jointBezier1stReducer(let subAction):
//                switch subAction{
//                case .calculateNewPoint(_, let t):
//                    return EffectTask(value: .jointBezier2stReducer(.calculateNewPoint(referencePoints:state.bezier1st.trace,t:t)))
//                case .recalculateTrace(_, tick: let tick, let totalTicks):
//                    return EffectTask(value: .jointBezier2stReducer(.recalculateTrace(referencePoints:state.bezier1st.trace,tick:tick, totalTicks: totalTicks)))
//                default:
//                    return .none
//                }
//            case .jointBezier2stReducer(let subAction):
//                switch subAction{
//                case .calculateNewPoint(_, let t):
//                    return EffectTask(value: .jointBezier3stReducer(.calculateNewPoint(referencePoints:state.bezier2st.trace,t:t)))
//                case .recalculateTrace(_, tick: let tick, let totalTicks):
//                    return EffectTask(value: .jointBezier3stReducer(.recalculateTrace(referencePoints:state.bezier2st.trace,tick:tick, totalTicks: totalTicks)))
//                default:
//                    return .none
//                }
            default:
                return .none
            }
        }
//        forEach(\.controlPoints., action: /Action.jointControlPointsReducer(id:action:)) {
//            MultipleTimeSeriesPointsReducer()
//        }
        
    }
}
