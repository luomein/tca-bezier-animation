//
//  MultiLayerBezierCurveView.swift
//  tca-bezier-animation
//
//  Created by MEI YIN LO on 2022/12/19.
//

import SwiftUI
import ComposableArchitecture

struct MultiLayerBezierCurveReferenceLineView: View {
    //let store: StoreOf<MultiLayerBezierCurveReducer>
    let bezierTimeSeries : BezierTimeSeriesPointsReducer.State
    let referenceTimeSeries : MultipleTimeSeriesPointsReducer.State
    var body: some View {
        //WithViewStore(self.store, observe: { $0 }) { viewStore in
            ZStack{
                if bezierTimeSeries.plot && bezierTimeSeries.showReferenceLine{
                    Path{path in
                        path.addLines(referenceTimeSeries.multipleSeries.map({
                            $0.timeSeries.last!.point
                        }))
                    }.stroke(bezierTimeSeries.referenceColor,lineWidth: bezierTimeSeries.referenceLineWidth)
                }
            }
        //}
    }
}
struct MultiLayerBezierCurveView: View {
    let store: StoreOf<MultiLayerBezierCurveReducer>
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            ZStack{
                BezierTimerSeriesTraceView(store: store.scope(state: \.bezier1st, action: { .jointBezier1stReducer($0)}))
                BezierTimerSeriesTraceView(store: store.scope(state: \.bezier2st, action: { .jointBezier2stReducer($0)}))
                BezierTimerSeriesTraceView(store: store.scope(state: \.bezier3st, action: { .jointBezier3stReducer($0)}))
                
                BezierTimerSeriesLastPointsView(store: store.scope(state: \.bezier1st, action: { .jointBezier1stReducer($0)}))
                BezierTimerSeriesLastPointsView(store: store.scope(state: \.bezier2st, action: { .jointBezier2stReducer($0)}))
                BezierTimerSeriesLastPointsView(store: store.scope(state: \.bezier3st, action: { .jointBezier3stReducer($0)}))
                
                MultiLayerBezierCurveReferenceLineView(bezierTimeSeries: viewStore.bezier1st, referenceTimeSeries: viewStore.controlPoints)
                MultiLayerBezierCurveReferenceLineView(bezierTimeSeries: viewStore.bezier2st, referenceTimeSeries: viewStore.bezier1st.trace)
                MultiLayerBezierCurveReferenceLineView(bezierTimeSeries: viewStore.bezier3st, referenceTimeSeries: viewStore.bezier2st.trace)
            }
        }
    }
}

//struct MultiLayerBezierCurveView_Previews: PreviewProvider {
//    static var previews: some View {
//        MultiLayerBezierCurveView()
//    }
//}
