//
//  labPlaygroundApp.swift
//  labPlayground
//
//  Created by MEI YIN LO on 2022/12/2.
//

import SwiftUI
import ComposableArchitecture

@main
struct labPlaygroundApp: App {
    

    var body: some Scene {
        WindowGroup {
            ContainerView(store: Store(initialState: Feature.State(),
                                     reducer: Feature()))
            
        }
    }
}
