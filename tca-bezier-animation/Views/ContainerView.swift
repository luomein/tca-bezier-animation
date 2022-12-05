//
//  ContainerView.swift
//  labPlayground
//
//  Created by MEI YIN LO on 2022/12/3.
//

import SwiftUI
import ComposableArchitecture

struct ContainerView: View {
    let store: StoreOf<Feature>
        
        var body: some View {
            NavigationView(content: {
                ControlView(store: store)
                DrawView(store: store)
            })
            
        }
}

struct ContainerView_Previews: PreviewProvider {
    static var previews: some View {
        ContainerView(store: Store(initialState: Feature.State(),
                                   reducer: Feature()))
    }
}
