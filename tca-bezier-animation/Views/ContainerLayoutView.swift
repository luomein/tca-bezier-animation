//
//  ContainerView.swift
//  tca-bezier-animation
//
//  Created by MEI YIN LO on 2022/12/17.
//

import SwiftUI
import ComposableArchitecture

struct ContainerLayoutView<PlottingView: View, SettingView: View>: View {
    @Environment(\.horizontalSizeClass) var hClass
    let store: StoreOf<ContainerReducer>
    typealias PlottingViewBuilder = (StoreOf<ContainerReducer>) -> PlottingView
    typealias SettingViewBuilder = (StoreOf<ContainerReducer>) -> SettingView
    var plottingViewBuilder : PlottingViewBuilder
    var settingViewBuilder : SettingViewBuilder
    init(store: StoreOf<ContainerReducer>, plottingViewBuilder: @escaping PlottingViewBuilder, settingViewBuilder: @escaping SettingViewBuilder) {
        self.store = store
        self.plottingViewBuilder = plottingViewBuilder
        self.settingViewBuilder = settingViewBuilder
    }
    var compactLayout : some View{
        
                    TabView {
                        plottingViewBuilder(store)
                            .tabItem {
                                 Image(systemName: "scribble.variable")
                            }
                        settingViewBuilder(store)
                            .tabItem {
                                 Image(systemName: "slider.horizontal.3")
                            }
                        
                    }
    }
    var regularLayout : some View{
        NavigationSplitView {
            settingViewBuilder(store)
        } detail: {
            plottingViewBuilder(store)
        }
    }
    var body: some View {
        if hClass == .compact{
            compactLayout
        }
        else{
            regularLayout
        }
    }
}

//struct ContainerView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContainerView()
//    }
//}
