//
//  ControlView.swift
//  labPlayground
//
//  Created by MEI YIN LO on 2022/12/3.
//

import SwiftUI
import ComposableArchitecture

struct ControlView : View {
    let store: StoreOf<Feature>
    
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            Form{
                 
                PointSectionView(store: store)
                TimerParameterSectionView(store: store.scope(state: \.timer, action: {.jointTimerReducer($0)}))
                DrawingOptionsSectionView(store: store)
                
            }
        }
    }
}

struct ControlView_Previews: PreviewProvider {
    static var previews: some View {
        ControlView(store: Store(initialState: Feature.State(),
                                 reducer: Feature()))
    }
}
