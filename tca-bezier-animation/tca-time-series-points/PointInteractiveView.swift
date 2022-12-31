//
//  PointSampleView.swift
//  tca-bezier-animation
//
//  Created by MEI YIN LO on 2022/12/17.
//

import SwiftUI
import ComposableArchitecture
import SwiftUINavigation
import MultipleTimeSeriesReducer

struct SingleTimeSeriesPointsView: View{
    let store: StoreOf<SingleTimeSeriesReducer>
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            ZStack{
                ForEachStore(store.scope(state: \.timeSeries, action: {SingleTimeSeriesReducer.Action.jointReducerAction($0.0,$0.1) })) { singleStore in
                    PointInteractiveView(store: singleStore)
                                    }
                                }
        }
    }
}

struct SingleTimeSeriesTextView: View{
    let store: StoreOf<SingleTimeSeriesReducer>
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            List{
                ForEachStore(store.scope(state: \.timeSeries, action: {SingleTimeSeriesReducer.Action.jointReducerAction($0.0,$0.1) })) { singleStore in
                    PointTextView(store: singleStore)
                    
                }
            }
        }
    }
}
struct MultipleTimeSeriesTextView: View{
    let store: StoreOf<MultipleTimeSeriesReducer>
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            List{
                ForEachStore(store.scope(state: \.multipleSeries, action: {MultipleTimeSeriesReducer.Action.jointReducerAction($0.0,$0.1) })) { singleStore in
                    SingleTimeSeriesTextView(store: singleStore)
                }
            }
        }
    }
}
struct MultipleTimeSeriesPointsView: View{
    let store: StoreOf<MultipleTimeSeriesReducer>
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            
            ZStack{
                ForEachStore(store.scope(state: \.multipleSeries, action: {MultipleTimeSeriesReducer.Action.jointReducerAction($0.0,$0.1) })) { singleStore in
                    SingleTimeSeriesPointsView(store: singleStore)
                }
            }
        }
    }
}

struct PointTextView: View {
    let store: StoreOf<PointReducer>
    
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            HStack{
                Circle()
                    .fill(viewStore.state.color)
                    .frame(width: viewStore.size,height: viewStore.state.size )
                Text("(\(Int(viewStore.point.x)),\(Int(viewStore.point.y)))")
                Spacer()
                Button {
                    viewStore.send(.startPopoverEdit)
                } label: {
                    Text(Image(systemName: "square.on.square"))
                }
                
            }
            
            //Publishing changes from within view updates is not allowed, this will cause undefined behavior.
            
            .popover(unwrapping: viewStore.binding(get: \.popoverEditingState, send: PointReducer.Action.popoverEditing) ) { $value in
                PointEditingStatePopoverView(environmentVariables: viewStore.environmentVariables, editingState: $value)
                    .modifier(FitPopoverViewModifier(width: 300, height: 400))
                    .onAppear{
                        viewStore.send(.requestEnvironmentVariables)
                    }
            }
        }
    }
}
struct PointSampleView_Previews: PreviewProvider {
    static var previews: some View {
        GeometryReader{proxy in
                    PointTextView(store: Store(initialState: .init(point: CGPoint(x: 100, y: 100), size: 30, color: .yellow, id: UUID()), reducer: PointReducer()))
                        
        }

    }
}
