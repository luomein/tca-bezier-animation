//
//  MultiLayerBezierCurveView.swift
//  tca-bezier-animation
//
//  Created by MEI YIN LO on 2022/12/19.
//

import SwiftUI
import ComposableArchitecture
import MultipleTimeSeriesReducer
import BezierTimeSeriesReducer
import LuomeinSwiftBasicTools



struct MultiLayerBezierReferenceLineView: View {
    let store: StoreOf<MultiLayerBezierCurveReducer>
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            ZStack{
                MultiLayerBezierCurveAllReferenceLineView(bezierTimeSeries: viewStore.bezier1st, referenceTimeSeries: viewStore.controlPoints)
                MultiLayerBezierCurveAllReferenceLineView(bezierTimeSeries: viewStore.bezier2nd, referenceTimeSeries: viewStore.bezier1st.trace)
                MultiLayerBezierCurveAllReferenceLineView(bezierTimeSeries: viewStore.bezier3rd, referenceTimeSeries: viewStore.bezier2nd.trace)
                
                MultiLayerBezierCurveLastReferenceLineView(bezierTimeSeries: viewStore.bezier1st, referenceTimeSeries: viewStore.controlPoints)
                MultiLayerBezierCurveLastReferenceLineView(bezierTimeSeries: viewStore.bezier2nd, referenceTimeSeries: viewStore.bezier1st.trace)
                MultiLayerBezierCurveLastReferenceLineView(bezierTimeSeries: viewStore.bezier3rd, referenceTimeSeries: viewStore.bezier2nd.trace)
            }
        }
    }
}
struct MultiLayerBezierCurveView: View {
    let store: StoreOf<MultiLayerBezierCurveReducer>
    
   
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            ZStack{
                
                MultiLayerBezierReferenceLineView(store: store)

                
                

                
                


                //trace
                SingleBezierTimerSeriesTraceView(store: store.scope(state: \.bezier1st, action: { .jointBezier1stReducer($0)}))
                SingleBezierTimerSeriesTraceView(store: store.scope(state: \.bezier2nd, action: { .jointBezier2ndReducer($0)}))
                SingleBezierTimerSeriesTraceView(store: store.scope(state: \.bezier3rd, action: { .jointBezier3rdReducer($0)}))
                
                SingleBezierTimerSeriesLastPointsView(store: store.scope(state: \.bezier1st, action: { .jointBezier1stReducer($0)}))
                SingleBezierTimerSeriesLastPointsView(store: store.scope(state: \.bezier2nd, action: { .jointBezier2ndReducer($0)}))
                SingleBezierTimerSeriesLastPointsView(store: store.scope(state: \.bezier3rd, action: { .jointBezier3rdReducer($0)}))
                
                
            }
        }
    }
}

//struct MultiLayerBezierCurveView_Previews: PreviewProvider {
//    static var previews: some View {
//        MultiLayerBezierCurveView()
//    }
//}
