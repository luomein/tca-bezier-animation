//
//  PointSectionView.swift
//  labPlayground
//
//  Created by MEI YIN LO on 2022/12/3.
//

import SwiftUI
import ComposableArchitecture

struct PointSectionView: View {
    let store: StoreOf<Feature>
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            Section(header:
                        HStack{
                Text("Control Points")
                Spacer()
                
            }
                    , content: {
                ForEach(viewStore.controlPoints.allPtArray){pt in
                    Text("( \(pt.ptArray.last!.x.description) , \(pt.ptArray.last!.y.description) )")
                }
            })
            
        }
    }
}


struct PointSectionView_Previews: PreviewProvider {
    static var previews: some View {
        PointSectionView(store: Store(initialState: Feature.State(),
                                      reducer: Feature()))
    }
}
