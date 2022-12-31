//
//  PointSampleView.swift
//  tca-bezier-animation
//
//  Created by MEI YIN LO on 2022/12/17.
//

import SwiftUI
import ComposableArchitecture
import SwiftUINavigation
import MultipleTimeSeriesReducer
import LuomeinSwiftBasicTools


struct SingleTimeSeriesTextView: View{
    let store: StoreOf<SingleTimeSeriesReducer>
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            List{
                ForEachStore(store.scope(state: \.timeSeries, action: {SingleTimeSeriesReducer.Action.jointReducerAction($0.0,$0.1) })) { singleStore in
                    PointTextView(store: singleStore)
                    
                }
            }
        }
    }
}
struct MultipleTimeSeriesTextView: View{
    let store: StoreOf<MultipleTimeSeriesReducer>
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            List{
                ForEachStore(store.scope(state: \.multipleSeries, action: {MultipleTimeSeriesReducer.Action.jointReducerAction($0.0,$0.1) })) { singleStore in
                    SingleTimeSeriesTextView(store: singleStore)
                }
            }
        }
    }
}
struct MultipleTimeSeriesPointsView: View{
    let store: StoreOf<MultipleTimeSeriesReducer>
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            
            ZStack{
                ForEachStore(store.scope(state: \.multipleSeries, action: {MultipleTimeSeriesReducer.Action.jointReducerAction($0.0,$0.1) })) { singleStore in
                    SingleTimeSeriesPointsView(store: singleStore)
                }
            }
        }
    }
}

