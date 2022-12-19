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
    
    private class EnvironmentVariablesWrapper{
        var cachedEnvironmentVariables = EnvironmentVariables()
    }
    
    private var environmentVariablesWrapper = EnvironmentVariablesWrapper()
    
    struct State: Equatable {
        var timer = VariableSpeedTimerReducer.State()

        var bezierCurve : MultiLayerBezierCurveReducer.State = .init()
    }
    enum Action : Equatable{
        case appearOnCanvas(CGSize)
        case redraw(MultipleTimeSeriesPointsReducer.State)
        case checkCanvasBoundary(CGSize)
        case setEnvironmentVariables(EnvironmentVariables)
        
        case jointTimerReducer(VariableSpeedTimerReducer.Action)
        case jointBezierCurveReducer(MultiLayerBezierCurveReducer.Action)
    
    }

    struct DebounceID : Hashable{}
    var body: some ReducerProtocol<State, Action> {
        Scope(state: \.timer, action: /Action.jointTimerReducer) {
            VariableSpeedTimerReducer()
                
        }
        Scope(state: \.bezierCurve, action: /Action.jointBezierCurveReducer) {
            MultiLayerBezierCurveReducer()
                .dependency(\.environmentVariables, environmentVariablesWrapper.cachedEnvironmentVariables)
        }

        Reduce{state, action  in
            switch action{
            case .redraw(let controlPoints):
                state.bezierCurve.controlPoints = controlPoints
                return EffectTask(value: .jointTimerReducer(.startFromTick(0)))
            case .setEnvironmentVariables(let value):
                environmentVariablesWrapper.cachedEnvironmentVariables = value
                return .none
            case .checkCanvasBoundary(let size):
                let check = state.bezierCurve.controlPoints.multipleSeries.map({
                    ($0.timeSeries.last!.point.x < size.width) &&
                    ($0.timeSeries.last!.point.y < size.height)
                })
                if check.contains(false){
                    let cgPoints = state.bezierCurve.controlPoints.multipleSeries.map({
                        CGPoint(x: min(size.width, $0.timeSeries.last!.point.x),
                                y: min(size.height, $0.timeSeries.last!.point.y))
                    })
                    let controlPoints = MultipleTimeSeriesPointsReducer.State.initFromOrigin(points: cgPoints)
                    return EffectTask(value: .redraw(controlPoints))
                }
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

            default:
                return .none
            }
        }

    }
}
