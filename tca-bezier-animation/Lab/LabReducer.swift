//
//  LabReducer.swift
//  tca-bezier-animation
//
//  Created by MEI YIN LO on 2022/12/18.
//

import Foundation
import ComposableArchitecture
import SwiftUI

struct LabView: View{
    let store: StoreOf<LabReducer>
    
    var body: some View {
//        WithViewStore(self.store, observe: { $0 }) { viewStore in
//            Text("\(viewStore.flag.description)")
//                .onAppear{
//                    viewStore.send(.redraw(true))
//                }
//        }
        SubView(store: store)
            
    }
}
struct SubView: View{
    let store: StoreOf<LabReducer>
    //@EnvironmentObject var environmentVariables : EnvironmentVariables
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            GeometryReader { proxy in
                if proxy.size != .zero{
                    Text("SubView: \(viewStore.flag.description)")
//                        .onAppear{
//                            viewStore.send(.redraw(true))
//                        }
//                        .task(id: proxy.size) {
//                            environmentVariables.CanvasSize = proxy.size
//                            viewStore.send(.redraw(true))
//                        }
                }
            }
            
        }
            
    }
}
struct LabView_Previews: PreviewProvider {
    static var previews: some View {
        LabView(store: Store(initialState: .init(), reducer: LabReducer()))
            //.environmentObject(EnvironmentVariables())
    }
}
struct LabReducer: ReducerProtocol {
    struct State: Equatable {
        var flag = false
    }
    enum Action : Equatable{
        case redraw(Bool)
        
    }
    func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
        switch action{
        case .redraw(let value):
            print("redraw before: ", value)
            state.flag = value
            print("redraw after: ", value)
            return .none
        }
    }
}
