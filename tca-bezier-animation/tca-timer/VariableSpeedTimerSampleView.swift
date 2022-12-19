//
//  AutoStartStopVariableSpeedTimerView.swift
//  tca-bezier-animation
//
//  Created by MEI YIN LO on 2022/12/17.
//

import SwiftUI
import ComposableArchitecture

struct TimerTickerView: View {
    let store: StoreOf<VariableSpeedTimerReducer>
        var body: some View {
            WithViewStore(self.store, observe: { $0 }) { viewStore in
                
                VStack{

                    HStack{
                        Spacer()
                        Button {
                            viewStore.send(.toggleTimer(!viewStore.isTimerOn))
                        } label: {
                            Text(Image(systemName: (viewStore.state.isTimerOn) ? "pause.rectangle.fill" : "play.rectangle.fill"))
                                .font(.title)
                                
                        }
                        
                        Slider(value: viewStore.binding(get: \.currentTick, send: VariableSpeedTimerReducer.Action.startFromTick), in: 0...viewStore.totalTicks)
                            .frame(width:150)
                            .padding()
                    }
                    
                    Spacer()
                }
                .onAppear(perform: {
                    viewStore.send(.startFromTick(0))
                    viewStore.send(.toggleTimer(true))
                })
                .onDisappear(perform: {
                    viewStore.send(.toggleTimer(false))
                })
            }
        }
}
struct TimerConfigSectionView: View {
    let store: StoreOf<VariableSpeedTimerReducer>
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            List{
                HStack{
                    Text("Timer Speed")
                    Slider(value: viewStore.binding(get: \.timerSpeed, send: VariableSpeedTimerReducer.Action.setTimerSpeed),
                           in: 0...VariableSpeedTimerReducer.TimerSpeedParameter.timerSpeedMax, label: {Text("Timer Speed")},
                           minimumValueLabel: {Text(Image(systemName: "tortoise"))},
                           maximumValueLabel: {Text(Image(systemName: "hare"))}
                    )
                    
                }
                HStack{
                    Text("Total Ticks")
                    
                    Slider(value: viewStore.binding(get: \.totalTicks, send: VariableSpeedTimerReducer.Action.setTotalTicks),
                           in: VariableSpeedTimerReducer.TimerSpeedParameter.timerTotalTicksMin...VariableSpeedTimerReducer.TimerSpeedParameter.timerTotalTicksMax, label: {Text("Total Ticks")},
                           minimumValueLabel: {Text(Int(VariableSpeedTimerReducer.TimerSpeedParameter.timerTotalTicksMin).description)},
                           maximumValueLabel: {Text(Int(VariableSpeedTimerReducer.TimerSpeedParameter.timerTotalTicksMax).description)}
                    )
                    
                }
            }
            
        }
    }
}
struct VariableSpeedTimerSampleView: View {
    let store: StoreOf<VariableSpeedTimerReducer>
        var body: some View {
            WithViewStore(self.store, observe: { $0 }) { viewStore in
                Form{
                    HStack{
                        Toggle(isOn: viewStore.binding(get: \.isTimerOn, send: VariableSpeedTimerReducer.Action.toggleTimer), label: {Text("isTimerOn")})
                        Text("\(Int(viewStore.currentTick))")
                        Slider(value: viewStore.binding(get: \.currentTick, send: VariableSpeedTimerReducer.Action.startFromTick), in: 0...viewStore.totalTicks)
                    }
                    HStack{
                        Text("Timer Speed")
                        Slider(value: viewStore.binding(get: \.timerSpeed, send: VariableSpeedTimerReducer.Action.setTimerSpeed),
                               in: 0...VariableSpeedTimerReducer.TimerSpeedParameter.timerSpeedMax, label: {Text("Timer Speed")},
                               minimumValueLabel: {Text(Image(systemName: "tortoise"))},
                               maximumValueLabel: {Text(Image(systemName: "hare"))}
                        )
                        
                    }
                }
                .onAppear(perform: {
                    viewStore.send(.startFromTick(0))
                    viewStore.send(.toggleTimer(true))
                })
                .onDisappear(perform: {
                    viewStore.send(.toggleTimer(false))
                })
            }
        }
}

struct VariableSpeedTimerSampleView_Previews: PreviewProvider {
    static var previews: some View {
        VariableSpeedTimerSampleView(store: Store(initialState: .init(), reducer: VariableSpeedTimerReducer()) )
//        TimerTickerView(store: Store(initialState: .init(), reducer: VariableSpeedTimerReducer()) )
    }
}
