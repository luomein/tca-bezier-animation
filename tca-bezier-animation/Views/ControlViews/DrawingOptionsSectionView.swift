//
//  DrawingOptionsSectionView.swift
//  labPlayground
//
//  Created by MEI YIN LO on 2022/12/4.
//

import SwiftUI
import ComposableArchitecture



struct DrawingOptionsSectionView: View {
    let store: StoreOf<Feature>
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            Section(header:
                        HStack{
                Text("Drawing Options")
                Spacer()
                
            }
                    , content: {
                List{
                    BezierOrderLayerDrawingOptionsView(store: store.scope(state: \.controlPoints, action: {.jointControlPointsReducer($0)}), title: "Control Points", displayOptions: [.pointSize])
                    BezierOrderLayerDrawingOptionsView(store: store.scope(state: \.bezierOrderLayer1, action: {.jointBezierOrderLayer1Reducer($0)}), title: "Bezier 1st Order", displayOptions: .all)
                    BezierOrderLayerDrawingOptionsView(store: store.scope(state: \.bezierOrderLayer2, action: {.jointBezierOrderLayer2Reducer($0)}), title: "Bezier 2st Order", displayOptions: .all)
                    BezierOrderLayerDrawingOptionsView(store: store.scope(state: \.bezierOrderLayer3, action: {.jointBezierOrderLayer3Reducer($0)}), title: "Bezier 3st Order", displayOptions: .all)
                    Spacer()
                }
                
            }
            )
        }
    }
}
struct DrawingOptionsSectionView_Previews: PreviewProvider {
    static var previews: some View {
        Form{
            DrawingOptionsSectionView(store: Store(initialState: Feature.State(),
                                                   reducer: Feature()))
        }
    }
}
