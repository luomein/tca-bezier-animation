//
//  ParameterSectionView.swift
//  labPlayground
//
//  Created by MEI YIN LO on 2022/12/2.
//

import SwiftUI
import ComposableArchitecture

struct TimerParameterSectionView: View {
    let store: StoreOf<TimerReducer>
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            Section(header:
                        HStack{
                Text("Timer")
                Spacer()
                
            }
                    , content: {
                List{
                    HStack{
                        Text("Total Steps")
                        Spacer()
                        Slider(value: viewStore.binding(get: \.parameter.totalStep, send: {.parameterTotalStep($0)} ),
                               in: 1.0...100.0, step: 1.0
                        )
                    }
                    HStack{
                        Text("Speed")
                        Spacer()
                        Slider(value: viewStore.binding(get: \.parameter.timerSpeed, send: {.parameterTimerSpeed($0)} ),
                               in: 0.0...viewStore.parameter.timerSpeedMax, step: 1.0
                        )
                    }
                }
                    
                    
            })
            
        }
    }
}

struct ParameterSectionView_Previews: PreviewProvider {
    static var previews: some View {
        Form{
            TimerParameterSectionView(store: Store(initialState: TimerReducer.State(),
                                              reducer: TimerReducer()))
        }
    }
}
