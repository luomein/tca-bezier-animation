//
//  PointSampleView.swift
//  tca-bezier-animation
//
//  Created by MEI YIN LO on 2022/12/17.
//

import SwiftUI
import ComposableArchitecture




public struct MultipleTimeSeriesPointsView: View{
    public let store: StoreOf<MultipleTimeSeriesReducer>
    public init(store: StoreOf<MultipleTimeSeriesReducer>) {
        self.store = store
    }
    public var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            
            ZStack{
                ForEachStore(store.scope(state: \.multipleSeries, action: {MultipleTimeSeriesReducer.Action.jointReducerAction($0.0,$0.1) })) { singleStore in
                    SingleTimeSeriesPointsView(store: singleStore)
                }
            }
        }
    }
}

