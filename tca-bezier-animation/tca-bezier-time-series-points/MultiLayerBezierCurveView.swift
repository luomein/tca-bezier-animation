//
//  MultiLayerBezierCurveView.swift
//  tca-bezier-animation
//
//  Created by MEI YIN LO on 2022/12/19.
//

import SwiftUI
import ComposableArchitecture

struct MultiLayerBezierCurveAllReferenceLineView: View {
    let bezierTimeSeries : BezierTimeSeriesPointsReducer.State
    let referenceTimeSeries : MultipleTimeSeriesPointsReducer.State
    var body: some View {
        
        ZStack{
            if bezierTimeSeries.plot && bezierTimeSeries.showReferenceLine{
                if !referenceTimeSeries.multipleSeries.isEmpty{
                    let zipped : [[CGPoint]] = MultiLayerBezierCurveReducer.zipT(
                        referenceTimeSeries.multipleSeries.map({
                            $0.timeSeries.map({
                                $0.point
                            })
                        })
                    )
                    ForEach(zipped, id: \.self){series in
                        Path{path in
                            path.addLines(series)
                        }
                        .stroke(bezierTimeSeries.referenceColor,lineWidth: bezierTimeSeries.referenceLineWidth)
                    }
                }
            }
        }
    }
}
struct MultiLayerBezierCurveReferenceLineView: View {
    let bezierTimeSeries : BezierTimeSeriesPointsReducer.State
    let referenceTimeSeries : MultipleTimeSeriesPointsReducer.State
    var body: some View {
        
        ZStack{
            if bezierTimeSeries.plot && bezierTimeSeries.showReferenceLine{
                Path{path in
                    path.addLines(referenceTimeSeries.multipleSeries.map({
                        $0.timeSeries.last!.point
                    }))
                }.stroke(bezierTimeSeries.referenceColor,lineWidth: bezierTimeSeries.referenceLineWidth)
            }
        }
    }
}
struct MultiLayerBezierCurveView: View {
    let store: StoreOf<MultiLayerBezierCurveReducer>
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            ZStack{
                
                //reference line
                //                MultiLayerBezierCurveReferenceLineView(bezierTimeSeries: viewStore.bezier1st, referenceTimeSeries: viewStore.controlPoints)
                //                MultiLayerBezierCurveReferenceLineView(bezierTimeSeries: viewStore.bezier2st, referenceTimeSeries: viewStore.bezier1st.trace)
                //                MultiLayerBezierCurveReferenceLineView(bezierTimeSeries: viewStore.bezier3st, referenceTimeSeries: viewStore.bezier2st.trace)
                
                //special effect
                MultiLayerBezierCurveAllReferenceLineView(bezierTimeSeries: viewStore.bezier3st, referenceTimeSeries: viewStore.bezier2st.trace)
                
                BezierTimerSeriesTraceView(store: store.scope(state: \.bezier1st, action: { .jointBezier1stReducer($0)}))
                BezierTimerSeriesTraceView(store: store.scope(state: \.bezier2st, action: { .jointBezier2stReducer($0)}))
                BezierTimerSeriesTraceView(store: store.scope(state: \.bezier3st, action: { .jointBezier3stReducer($0)}))
                
                BezierTimerSeriesLastPointsView(store: store.scope(state: \.bezier1st, action: { .jointBezier1stReducer($0)}))
                BezierTimerSeriesLastPointsView(store: store.scope(state: \.bezier2st, action: { .jointBezier2stReducer($0)}))
                BezierTimerSeriesLastPointsView(store: store.scope(state: \.bezier3st, action: { .jointBezier3stReducer($0)}))
                
                
            }
        }
    }
}

//struct MultiLayerBezierCurveView_Previews: PreviewProvider {
//    static var previews: some View {
//        MultiLayerBezierCurveView()
//    }
//}
