//
//  PlottingView.swift
//  tca-bezier-animation
//
//  Created by MEI YIN LO on 2022/12/17.
//

import SwiftUI
import ComposableArchitecture

struct PlottingView: View {
    let store: StoreOf<ContainerReducer>
    init(store: StoreOf<ContainerReducer>) {
        self.store = store
        
    }
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            GeometryReader { proxy in
                if proxy.size != .zero{
                    
                    ZStack{
                        TimerTickerView(store: store.scope(state: \.timer,action: {.jointTimerReducer($0)}))
                            //.contentShape(Rectangle())
                        
                         
                        MultiLayerBezierCurveView(store: store.scope(state: \.bezierCurve, action: {.jointBezierCurveReducer($0)}))
                        
                        MultipleTimeSeriesPointsView(store: store.scope(state: \.bezierCurve.controlPoints, action: {.jointBezierCurveReducer(.jointControlPointsReducer($0))}))
      

                    }
                    .onAppear{
                        viewStore.send(.appearOnCanvas(proxy.size))
                    }
                    .task(id: proxy.size) {
                        
                        viewStore.send(.setEnvironmentVariables(EnvironmentVariables(canvasSize: proxy.size)))
                        viewStore.send(.checkCanvasBoundary(proxy.size))
                    }

                }
            }.padding(5)
            
        }
    }
}

struct PlottingView_Previews: PreviewProvider {
    static var previews: some View {
        PlottingView(store: Store(initialState: .init() , reducer: ContainerReducer()))
            
    }
}
