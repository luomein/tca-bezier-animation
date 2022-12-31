//
//  MultiLayerBezierCurveView.swift
//  tca-bezier-animation
//
//  Created by MEI YIN LO on 2022/12/19.
//

import SwiftUI
import ComposableArchitecture
import MultipleTimeSeriesReducer

struct MultiLayerBezierCurveAllReferenceLineView: View {
    let bezierTimeSeries : SingleBezierTimeSeriesReducer.State
    let referenceTimeSeries : MultipleTimeSeriesReducer.State
    var body: some View {
        
        ZStack{
            if bezierTimeSeries.plot && bezierTimeSeries.showReferenceLine && bezierTimeSeries.referenceLineOption == .all{
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
    let bezierTimeSeries : SingleBezierTimeSeriesReducer.State
    let referenceTimeSeries : MultipleTimeSeriesReducer.State
    var body: some View {
        
        ZStack{
            if bezierTimeSeries.plot && bezierTimeSeries.showReferenceLine && bezierTimeSeries.referenceLineOption == .lastOne{
                Path{path in
                    path.addLines(referenceTimeSeries.multipleSeries.map({
                        $0.timeSeries.last!.point
                    }))
                }.stroke(bezierTimeSeries.referenceColor,lineWidth: bezierTimeSeries.referenceLineWidth)
            }
        }
    }
}
struct MultiLayerBezierReferenceLineView: View {
    let store: StoreOf<MultiLayerBezierCurveReducer>
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            ZStack{
                MultiLayerBezierCurveAllReferenceLineView(bezierTimeSeries: viewStore.bezier1st, referenceTimeSeries: viewStore.controlPoints)
                MultiLayerBezierCurveAllReferenceLineView(bezierTimeSeries: viewStore.bezier2nd, referenceTimeSeries: viewStore.bezier1st.trace)
                MultiLayerBezierCurveAllReferenceLineView(bezierTimeSeries: viewStore.bezier3rd, referenceTimeSeries: viewStore.bezier2nd.trace)
                
                MultiLayerBezierCurveReferenceLineView(bezierTimeSeries: viewStore.bezier1st, referenceTimeSeries: viewStore.controlPoints)
                MultiLayerBezierCurveReferenceLineView(bezierTimeSeries: viewStore.bezier2nd, referenceTimeSeries: viewStore.bezier1st.trace)
                MultiLayerBezierCurveReferenceLineView(bezierTimeSeries: viewStore.bezier3rd, referenceTimeSeries: viewStore.bezier2nd.trace)
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
                BezierTimerSeriesTraceView(store: store.scope(state: \.bezier1st, action: { .jointBezier1stReducer($0)}))
                BezierTimerSeriesTraceView(store: store.scope(state: \.bezier2nd, action: { .jointBezier2ndReducer($0)}))
                BezierTimerSeriesTraceView(store: store.scope(state: \.bezier3rd, action: { .jointBezier3rdReducer($0)}))
                
                BezierTimerSeriesLastPointsView(store: store.scope(state: \.bezier1st, action: { .jointBezier1stReducer($0)}))
                BezierTimerSeriesLastPointsView(store: store.scope(state: \.bezier2nd, action: { .jointBezier2ndReducer($0)}))
                BezierTimerSeriesLastPointsView(store: store.scope(state: \.bezier3rd, action: { .jointBezier3rdReducer($0)}))
                
                
            }
        }
    }
}

//struct MultiLayerBezierCurveView_Previews: PreviewProvider {
//    static var previews: some View {
//        MultiLayerBezierCurveView()
//    }
//}
