//
//  TimerReducer.swift
//  tca-bezier-animation
//
//  Created by MEI YIN LO on 2022/12/17.
//

import Foundation
import ComposableArchitecture


struct VariableSpeedTimerReducer: ReducerProtocol {
    
    class TimerSpeedParameter{
        static let timerSpeedMax : Double = 100.0
#if SNAPSHOT
        static let timerSpeedInitValue : Double = 70.0
#else
        static let timerSpeedInitValue : Double = 15.0
#endif
        static let timerTotalTicksMin = 1.0
        static let timerTotalTicksMax = 100.0

        static func getTimerInterval(timerSpeed: Double)->Double{
            return (TimerSpeedParameter.timerSpeedMax + 5 - timerSpeed) * 10
        }
    }
    //private var timerSpeedParameter = TimerSpeedParameter()
    private enum TimerID {}
    
    struct State: Equatable{
        var currentTick : Double = 0.0
        var totalTicks : Double = 50.0
        var isTimerOn = false
        var timerSpeed: Double = TimerSpeedParameter.timerSpeedInitValue
        
        var t : Double { currentTick / totalTicks  }
        
    }
    enum Action : Equatable{
        case stepForward
        case startTask
        case toggleTimer(Bool)
        case startFromTick(Double)
        case setTimerSpeed(Double)
        case setTotalTicks(Double)
        case restartTimer
        
    }
    struct DebounceID : Hashable{}
    func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
        switch action{
        case .stepForward:
            if !state.isTimerOn{
                return EffectTask(value: .toggleTimer(false))
            }
            state.currentTick += 1
            if state.currentTick > state.totalTicks{
                return EffectTask(value: .startFromTick(0))
            }
            
            return .none
        case .restartTimer:
            return .concatenate(EffectTask(value: .toggleTimer(false)),
                                EffectTask(value: .toggleTimer(true))
            )
        case .toggleTimer(let value):
            state.isTimerOn = value
            if state.isTimerOn
            {
                return EffectTask(value: .startTask)
            }
            else{
                return .cancel(id: TimerID.self)
            }
            
        case .startTask:
            let clock = SuspendingClock()
            return .run {[timerSpeed = state.timerSpeed] sender in
                while !Task.isCancelled{
                    do{
                        try await clock.sleep(for: .milliseconds(TimerSpeedParameter.getTimerInterval(timerSpeed: timerSpeed)))
                        //print(timerSpeed)
                        await Task.yield()
                        await sender.send(.stepForward)
                    }
                    catch{
                        if !Task.isCancelled{fatalError()}
                    }
                }
            }
            .cancellable(id: TimerID.self,cancelInFlight: true)
        case .startFromTick(let value):
            state.currentTick = value
            return .none
        case .setTimerSpeed(let value):
            state.timerSpeed = value
            return EffectTask(value: .restartTimer)
                //.debounce(id: DebounceID(), for: 0.1, scheduler: DispatchQueue.main)
        case .setTotalTicks(let value):
            state.totalTicks = value
            
            return EffectTask(value: .startFromTick(0))
        }
    }
}
