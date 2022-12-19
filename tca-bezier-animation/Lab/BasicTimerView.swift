//
//  BasicTimerView.swift
//  tca-bezier-animation
//
//  Created by MEI YIN LO on 2022/12/11.
//

import SwiftUI
import ComposableArchitecture



//extension DependencyValues {
//
//    var timerSpeedParameter: TimerSpeedParameter {
//        get { self[TimerSpeedParameter.self] }
//        set { self[TimerSpeedParameter.self] = newValue }
//      }
//}
//class TimerSpeedParameter: @unchecked Sendable{
class TimerSpeedParameter{
    var timerSpeed: Double = TimerSpeedParameter.timerSpeedInitValue
    static let timerSpeedMax : Double = 100.0
    static let timerSpeedInitValue : Double = 50.0
    var timerInterval : Double {
        return (TimerSpeedParameter.timerSpeedMax + 1 - timerSpeed) * 10
    }
}
//extension TimerSpeedParameter : DependencyKey{
//    static let liveValue: TimerSpeedParameter = TimerSpeedParameter()
//
//}

struct BasicTimerReducer: ReducerProtocol {
    
    //@Dependency(\.timerSpeedParameter) var timerSpeedParameter
    var timerSpeedParameter = TimerSpeedParameter()
    private enum TimerID {}
    
    struct State: Equatable{
        //var id : UUID
        var currentStep : Double = 0.0
        var totalSteps : Double = 10.0
        var timerSpeed: Double = TimerSpeedParameter.timerSpeedInitValue
        var isTimerOn = false
    }
    enum Action : Equatable{
        case setTimerSpeed(Double)
        case stepForward
        case jumpToTick(Double)
        case startTimer
        case toggleTimer(Bool)
    }
    func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
        switch action{
        case .setTimerSpeed(let value):
            //timerSpeed.timerSpeed = value
            //self.dependency(\.timerSpeed.timerSpeed, value)
            timerSpeedParameter.timerSpeed = value
            //clock.timerSpeed = value
            state.timerSpeed = value
            return .none
        case .stepForward:
            state.currentStep += 1
            if state.currentStep > state.totalSteps{
                state.currentStep = 0
            }
            return .none
        case .toggleTimer(let value):
            state.isTimerOn = value
            if state.isTimerOn
            {    return EffectTask(value: .startTimer) }
            else{
                return .cancel(id: TimerID.self)
            }
        case .startTimer:
            let localClock = ContinuousClock()
            return .run { sender in
//                for await _ in self.clock.timer(interval: .milliseconds(clock.timerInterval)){
//                    await sender.send(.stepForward)
//                }
                while !Task.isCancelled{
                    do{
                        //try await localClock.sleep(for: .seconds(clock.timerInterval))
                        try await localClock.sleep(for: .milliseconds(timerSpeedParameter.timerInterval))
                        await sender.send(.stepForward)
                    }
                    catch{
                        if !Task.isCancelled{fatalError()}
                    }
                }
            }
            .cancellable(id: TimerID.self,cancelInFlight: true)
        case .jumpToTick(let value):
            state.currentStep = value
            return .none
        }
    }
}

struct BasicTimerView: View {
    let store: StoreOf<BasicTimerReducer>
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            Form{
                HStack{
                    Toggle(isOn: viewStore.binding(get: \.isTimerOn, send: BasicTimerReducer.Action.toggleTimer), label: {Text("isTimerOn")})
                    Text("\(Int(viewStore.currentStep))")
                    Slider(value: viewStore.binding(get: \.currentStep, send: BasicTimerReducer.Action.jumpToTick), in: 0...viewStore.totalSteps)
                }
                HStack{
Text("Timer Speed")
                    Slider(value: viewStore.binding(get: \.timerSpeed, send: BasicTimerReducer.Action.setTimerSpeed), in: 0...TimerSpeedParameter.timerSpeedMax, label: {Text("Timer Speed")},
                           minimumValueLabel: {Text(Image(systemName: "tortoise"))},
                           maximumValueLabel: {Text(Image(systemName: "hare"))}
                    )
                
                }
            }
            .onAppear{
                viewStore.send(.toggleTimer(true))
            }
        }
    }
}

struct BasicTimerView_Previews: PreviewProvider {
    static var previews: some View {
        BasicTimerView(store: Store(initialState: .init(), reducer: BasicTimerReducer()))
    }
}
