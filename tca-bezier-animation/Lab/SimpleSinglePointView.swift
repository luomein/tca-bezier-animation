//
//  SimpleSinglePointView.swift
//  tca-bezier-animation
//
//  Created by MEI YIN LO on 2022/12/8.
//

import SwiftUI
import ComposableArchitecture

struct TCAPointViewReducer: ReducerProtocol {
    
    
    struct State: Equatable{
        //var id : UUID
        var pt : CGPoint
    }
    enum Action : Equatable{
        case movePoint(CGPoint)
    }
    func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
        switch action{
        case .movePoint(let pt):
            state.pt = pt
            return .none
        }
    }
}
struct SwiftUIPointView: View{
    @State var pt: CGPoint
    var body: some View {
        
        Circle()
            .fill(.blue)
            .frame(width: 50,height: 50 )
            .position(pt)
            .gesture(DragGesture().onChanged({gesture in
                //viewStore.send(.movePoint(gesture.location))
                pt = gesture.location
            }))
        
    }
}
struct TCAPointView: View {
    let store: StoreOf<TCAPointViewReducer>
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            Circle()
                .fill(.yellow)
                .frame(width: 50,height: 50 )
                .position(viewStore.state.pt)
                .gesture(DragGesture().onChanged({gesture in
                    viewStore.send(.movePoint(gesture.location))
                }))
        }
    }
}
struct TCASliderView: View {
    let store: StoreOf<TCAPointViewReducer>
    var body: some View {
        GeometryReader { proxy in
            WithViewStore(self.store, observe: { $0 }) { viewStore in
                VStack{
                    Slider( value: viewStore.binding(get: \.pt.x,
                                                     send: {TCAPointViewReducer.Action.movePoint(CGPoint(x: $0, y: viewStore.pt.y))}),
                            in: 0...proxy.size.width,
                            label: {Text("label")},
                            minimumValueLabel: {Text("x: \(Int(viewStore.pt.x))")} ,
                            maximumValueLabel: {Text("\(Int(proxy.size.width))")}
                    ).padding(10)
                    Slider( value: viewStore.binding(get: \.pt.y,
                                                     send: {TCAPointViewReducer.Action.movePoint(CGPoint(x: viewStore.pt.x, y: $0))}),
                            in: 0...proxy.size.height,
                            label: {Text("label")},
                            minimumValueLabel: {Text("y: \(Int(viewStore.pt.y))")} ,
                            maximumValueLabel: {Text("\(Int(proxy.size.height))")}
                    ).padding(10)
                }
            }

        }
    }
}
struct TestView: View{
    var body: some View {
        let pt = CGPoint(x: 0, y: 0)
        let store = Store(initialState:TCAPointViewReducer.State(pt: pt),
                          reducer: TCAPointViewReducer() )
        ZStack{
            TCAPointView(store: store)
            TCASliderView(store: store)
        }
    }
}
struct MyPreviews: PreviewProvider {
    static var previews: some View {
        TestView()
    }
}
