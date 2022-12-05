//
//  TimerProgressView.swift
//  tca-bezier-animation
//
//  Created by MEI YIN LO on 2022/12/5.
//

import SwiftUI
import ComposableArchitecture

struct TimerProgressView: View{
    let store: StoreOf<TimerReducer>
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            HStack{
                Spacer()
                VStack{
                    HStack{
                        Button {
                            viewStore.send(.toggleTimer(!viewStore.state.timerOn))
                        } label: {
                            
                            Text(Image(systemName: (viewStore.state.timerOn) ? "pause.rectangle.fill" : "play.rectangle.fill"))
                                .font(.title)
                                .padding()
                        }

                        Slider(value: viewStore.binding(get: \.timerProgress, send: {.slideTimer($0)} ),
                               in: 0.0...viewStore.parameter.totalStep, step: 1.0
                        )
                        .frame(width:150)
                    }
                    Spacer()
                }
            }
            .onAppear{
                viewStore.send(.startTimer(true))
            }
            .onDisappear{
                viewStore.send(.toggleTimer(false))
            }
        }
    }
}
