//
//  labPlaygroundApp.swift
//  labPlayground
//
//  Created by MEI YIN LO on 2022/12/2.
//

import SwiftUI
import ComposableArchitecture

@main
struct TCABezierAnimationApp: App {
    
    var body: some Scene {
        WindowGroup {

            ZStack{
                ContainerView(store: Store(initialState: .init( ) , reducer: ContainerReducer()))
            }
            
        }
    }
}
