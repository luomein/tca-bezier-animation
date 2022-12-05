//
//  TimerReducer.swift
//  labPlayground
//
//  Created by MEI YIN LO on 2022/12/5.
//

import Foundation
import ComposableArchitecture


struct TimerReducer: ReducerProtocol {
    var idProvider : ()->UUID
    init(idProvider: @escaping () -> UUID = {UUID()}) {
        self.idProvider = idProvider
    }
    struct State: Equatable {
        struct StateParameter: Equatable{
            
            var totalStep: Double = 10.0
            var timerSpeed: Double = 50.0
            var timerSpeedMax : Double{
                100.0
            }
        }
        var parameter = StateParameter()
        var timerID = UUID()
        var timerOn : Bool = true
        var timerCarry = 0
        var timerProgress : Double = 0.0
        var timerProgressUnit : Double {1.0}
        
        var t : Double { timerProgress / Double(parameter.totalStep )}
        
        
    }
    
    enum Action: Equatable {
        case parameterTotalStep(Double)
        case parameterTimerSpeed(Double)
        
        case startTimer(Bool)
        case toggleTimer(Bool)
        case progressTimer(Double)
        case slideTimer(Double)
        
        case resetState
        
        case timerProgressUpdated
        case timerInitStateUpdated
    }
    func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
        switch action{
        case .parameterTotalStep(let value):
            state.parameter.totalStep = value
            return EffectTask(value: .resetState)
        case .parameterTimerSpeed(let value):
            state.parameter.timerSpeed = value
            state.timerOn = false
            return .cancel(id: state.timerID)
            
        case .toggleTimer(let timerOn):
            state.timerOn = timerOn
            if timerOn{
                return EffectTask(value: .startTimer(false))
            }
            else{
                return .cancel(id: state.timerID)
            }
        case .progressTimer(let delta):
            if state.timerCarry == 1{
                return EffectTask(value: .resetState)
            }
            else{
                if state.timerProgress + delta >= state.parameter.totalStep{
                    state.timerCarry = 1
                    state.timerProgress = state.parameter.totalStep
                }
                else{
                    state.timerProgress += delta
                }
                
                //return EffectTask(value: .calculateNewPoint)
                return EffectTask(value: .timerProgressUpdated)
            }
            
        case .slideTimer(let progress):
            if state.timerOn{
                return EffectTask(value: .toggleTimer(false))
            }
            else{
                state.timerProgress = progress
                return EffectTask(value: .timerInitStateUpdated)
            }
        case .startTimer(let resetState):
            let clock = ContinuousClock()
            return .run(operation: {[timerProgressUnit = state.timerProgressUnit, timerSpeed = state.parameter.timerSpeed, timerSpeedMax = state.parameter.timerSpeedMax] sender in
                if resetState{
                    await sender.send(.resetState)
                }
                           while !Task.isCancelled{
                                do{
                                    let milliseconds = (timerSpeedMax + 2 - timerSpeed) * 10
                                    try await clock.sleep(for: .milliseconds( milliseconds ) )
                                    await sender.send(.progressTimer(timerProgressUnit))
                                }
                                catch{
                                    if !Task.isCancelled{fatalError()}
                                }
                            }
                            
                        }).cancellable(id: state.timerID)
        
        case .resetState:
            state.timerProgress = 0.0
            state.timerCarry = 0
            //return .none
            return EffectTask(value: .timerInitStateUpdated)
        case .timerProgressUpdated:
            return .none
        case .timerInitStateUpdated:
            return .none
        }
    }
}
