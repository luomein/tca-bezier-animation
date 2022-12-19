//
//  SettingView.swift
//  tca-bezier-animation
//
//  Created by MEI YIN LO on 2022/12/17.
//

import SwiftUI
import ComposableArchitecture
import SwiftUINavigation

struct SettingView: View {
    let store: StoreOf<ContainerReducer>
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            Form{
                Section( "Control Points")
                {
                    MultipleTimeSeriesTextView(store: store.scope(state: \.bezierCurve.controlPoints, action: {.jointBezierCurveReducer(.jointControlPointsReducer($0))}))
                }
                Section("Timer") {
                    TimerConfigSectionView(store: store.scope(state: \.timer,action: {.jointTimerReducer($0)}))
                }
                Section("Bezier Curve") {
                    List{
                        BezierTimeSeriesConfigListItemView(store: store.scope(state: \.bezierCurve.bezier1st, action: {.jointBezierCurveReducer(.jointBezier1stReducer($0))}), title: "1st Order")
                        BezierTimeSeriesConfigListItemView(store: store.scope(state: \.bezierCurve.bezier2st, action: {.jointBezierCurveReducer(.jointBezier2stReducer($0))}), title: "2st Order")
                        BezierTimeSeriesConfigListItemView(store: store.scope(state: \.bezierCurve.bezier3st, action: {.jointBezierCurveReducer(.jointBezier3stReducer($0))}), title: "3st Order")
                    }
                }
            }
        }
    }
}

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        GeometryReader { proxy in
//            let center = CGPoint(x: proxy.size.width/2, y: proxy.size.height/2)
//            let xrange =  Int(proxy.size.width/2)
//            let yrange = Int(proxy.size.height/2)
//            let pt1 = CGPoint(x: center.x - Double(Int.random(in: 10...xrange)), y: center.y - Double(Int.random(in: 10...yrange)))
//            let pt2 = CGPoint(x: center.x - Double(Int.random(in: 10...xrange)), y: center.y + Double(Int.random(in: 10...yrange)))
//            let pt3 = CGPoint(x: center.x + Double(Int.random(in: 10...xrange)), y: center.y + Double(Int.random(in: 10...yrange)))
//            let pt4 = CGPoint(x: center.x + Double(Int.random(in: 10...xrange)), y: center.y - Double(Int.random(in: 10...yrange)))
            
            SettingView(store: Store(initialState: .init(), reducer: ContainerReducer()))
                
        }
        
    }
}
