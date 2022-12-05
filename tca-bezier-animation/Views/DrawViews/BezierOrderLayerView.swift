//
//  BezierOrderLayerView.swift
//  labPlayground
//
//  Created by MEI YIN LO on 2022/12/4.
//

import SwiftUI
import ComposableArchitecture

struct BezierOrderLayerView: View {
    let store: StoreOf<BezierOrderLayerReducer>
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            if viewStore.drawingOptions.draw{
                if viewStore.drawingOptions.drawReferenceLine{
                    SegmentLineShape(ptList: viewStore.referencePoints)
                        .stroke()
                        .foregroundColor(viewStore.drawingOptions.colorReferenceLine)
                }
                ForEach(viewStore.allPtArray) { li in
                    if viewStore.drawingOptions.drawTrace{
                        SegmentLineShape(ptList: li.ptArray)
                            .stroke()
                            .foregroundColor(viewStore.drawingOptions.colorTrace)
                    }
                    
                    
                    Circle().fill(viewStore.drawingOptions.pointColor)
                        .frame(width: viewStore.drawingOptions.pointSize, height: viewStore.drawingOptions.pointSize)
                        .position(li.lastPoint)
                    
                }
            }
        }
    }
}

