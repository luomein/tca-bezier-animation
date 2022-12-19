//
//  DrawView.swift
//  labPlayground
//
//  Created by MEI YIN LO on 2022/12/3.
//

import SwiftUI
import ComposableArchitecture

struct SegmentLineShape: Shape{
    let ptList : [CGPoint]
    func path(in rect: CGRect) -> Path {
        Path { path in
            path.addLines(ptList)
        }
    }
}


struct DrawView : View {
    let store: StoreOf<Feature>
    
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in

            ZStack{
                TimerProgressView(store: store.scope(state: \.timer, action: {.jointTimerReducer($0)}))
                if viewStore.controlPoints.drawingOptions.draw{
                    ForEachStore(store.scope(state: \.controlPoints.allPtArray, action: {childAction in
                        Feature.Action.movePoint(id: childAction.0, action: childAction.1)
                    })) { singlePointStore in
                        SinglePointView(store: singlePointStore, ptSize: viewStore.controlPoints.drawingOptions.pointSize, color: viewStore.controlPoints.drawingOptions.pointColor)
                    }
                }
                BezierOrderLayerView(store: store.scope(state: \.bezierOrderLayer1, action: {.jointBezierOrderLayer1Reducer($0)}))
                BezierOrderLayerView(store: store.scope(state: \.bezierOrderLayer2, action: {.jointBezierOrderLayer2Reducer($0)}))
                BezierOrderLayerView(store: store.scope(state: \.bezierOrderLayer3, action: {.jointBezierOrderLayer3Reducer($0)}))

            }.padding(30)
                
        }
    }
}
struct DrawView_Previews: PreviewProvider {
    static var previews: some View {
        DrawView(store: Store(initialState: Feature.State(),
                              reducer: Feature()))
    }
}
