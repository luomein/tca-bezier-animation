//
//  ContainerView.swift
//  labPlayground
//
//  Created by MEI YIN LO on 2022/12/3.
//

import SwiftUI
import ComposableArchitecture

struct ContainerView1: View {
    let store: StoreOf<Feature>
        
        var body: some View {
            NavigationView(content: {
                ControlView(store: store)
                DrawView(store: store)
            })
            
        }
}

struct ContainerView: View{
    let store: StoreOf<ContainerReducer>
    var body: some View {
        ContainerLayoutView(store: store, plottingViewBuilder: PlottingView.init, settingViewBuilder: SettingView.init)
            
    }
}

struct ContainerView1_Previews: PreviewProvider {
    static var previews: some View {
//        ContainerView1(store: Store(initialState: Feature.State(),
//                                   reducer: Feature()))
        GeometryReader { proxy in
//            let center = CGPoint(x: proxy.size.width/2, y: proxy.size.height/2)
//            let xrange =  Int(proxy.size.width/2)
//            let yrange = Int(proxy.size.height/2)
//            let pt1 = CGPoint(x: center.x - Double(Int.random(in: 10...xrange)), y: center.y - Double(Int.random(in: 10...yrange)))
//            let pt2 = CGPoint(x: center.x - Double(Int.random(in: 10...xrange)), y: center.y + Double(Int.random(in: 10...yrange)))
//            let pt3 = CGPoint(x: center.x + Double(Int.random(in: 10...xrange)), y: center.y + Double(Int.random(in: 10...yrange)))
//            let pt4 = CGPoint(x: center.x + Double(Int.random(in: 10...xrange)), y: center.y - Double(Int.random(in: 10...yrange)))
            
            ContainerView(store: Store(initialState: .init(), reducer: ContainerReducer()))
                
        }
        
    }
}

