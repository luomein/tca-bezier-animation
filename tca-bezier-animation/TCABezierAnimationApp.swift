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
//    @StateObject var environmentVariables : EnvironmentVariables = EnvironmentVariables()

    var body: some Scene {
        WindowGroup {

            ZStack{
                //LabView(store: Store(initialState: .init(), reducer: LabReducer()))
                ContainerView(store: Store(initialState: .init( ) , reducer: ContainerReducer()))
                //PlottingView(store: Store(initialState: .init(controlPoints: MultipleTimeSeriesPointsReducer.State() ) , reducer: ContainerReducer()))
                    //.environmentObject(environmentVariables)
            }
        }
    }
}
