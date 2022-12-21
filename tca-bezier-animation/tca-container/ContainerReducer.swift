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
    func initDefaultControlPoints()->MultipleTimeSeriesPointsReducer.State{
        var richPoints: [RichPoint]!
        if let data = UserDefaults.standard.object(forKey: SnapShotJsonFileName.controlPoints.rawValue) as? Data {
            richPoints = loadJsonFromData(data: data)

        }
        else{
            richPoints = loadJsonFromBundle(filename: "DefaultControlPoints")
            print("file not exists")
        }
        let controlPoints = MultipleTimeSeriesPointsReducer.State.initFromOrigin(richPoints: richPoints)
        return controlPoints
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
                //print("cachedEnvironmentVariables", value)
                //on iPhone 8 Plus, this value is incorrect after rotate device
                environmentVariablesWrapper.cachedEnvironmentVariables = value
                return .none
            case .checkCanvasBoundary(let size):
                let check = state.bezierCurve.controlPoints.multipleSeries.map({
                    ($0.timeSeries.last!.point.x < size.width) &&
                    ($0.timeSeries.last!.point.y < size.height)
                })
                if check.contains(false){
                    let richPoints = state.bezierCurve.controlPoints.multipleSeries.map({
                        RichPoint(point:
                        CGPoint(x: min(size.width, $0.timeSeries.last!.point.x),
                                y: min(size.height, $0.timeSeries.last!.point.y))
                                  , size: $0.timeSeries.last!.size,
                                  color: $0.timeSeries.last!.color)
                    })
                    let controlPoints = MultipleTimeSeriesPointsReducer.State.initFromOrigin(richPoints:  richPoints )
                    return EffectTask(value: .redraw(controlPoints))
                }
                return .none
            case .appearOnCanvas(let value):
                if state.bezierCurve.controlPoints.multipleSeries.isEmpty{
                    let controlPoints = initDefaultControlPoints()
                    return EffectTask(value: .redraw(controlPoints))
                }
                return .none
            case .jointTimerReducer(let timerAction):
                switch timerAction{
                case .startFromTick(let tick):
                    return EffectTask(value: .jointBezierCurveReducer(.recalculateTrace(tick: tick, totalTicks: state.timer.totalTicks)))

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
//
                    
                default:
                    return .none
//
                }
            
            
            }
        }

    }
}
