//
//  PointSampleView.swift
//  tca-bezier-animation
//
//  Created by MEI YIN LO on 2022/12/17.
//

import SwiftUI
import ComposableArchitecture
import SwiftUINavigation

struct SingleTimeSeriesPointsView: View{
    let store: StoreOf<SingleTimeSeriesPointsReducer>
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            ZStack{
                ForEachStore(store.scope(state: \.timeSeries, action: {SingleTimeSeriesPointsReducer.Action.jointReducerAction($0.0,$0.1) })) { singleStore in
                    PointSampleView(store: singleStore)
                                    }
                                }
        }
    }
}

struct SingleTimeSeriesTextView: View{
    let store: StoreOf<SingleTimeSeriesPointsReducer>
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            List{
                ForEachStore(store.scope(state: \.timeSeries, action: {SingleTimeSeriesPointsReducer.Action.jointReducerAction($0.0,$0.1) })) { singleStore in
                    PointTextView(store: singleStore)
                    
                }
            }
        }
    }
}
struct MultipleTimeSeriesTextView: View{
    let store: StoreOf<MultipleTimeSeriesPointsReducer>
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            List{
                ForEachStore(store.scope(state: \.multipleSeries, action: {MultipleTimeSeriesPointsReducer.Action.jointReducerAction($0.0,$0.1) })) { singleStore in
                    SingleTimeSeriesTextView(store: singleStore)
                }
            }
        }
    }
}
struct MultipleTimeSeriesPointsView: View{
    let store: StoreOf<MultipleTimeSeriesPointsReducer>
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            
            ZStack{
                ForEachStore(store.scope(state: \.multipleSeries, action: {MultipleTimeSeriesPointsReducer.Action.jointReducerAction($0.0,$0.1) })) { singleStore in
                    SingleTimeSeriesPointsView(store: singleStore)
                }
            }
        }
    }
}
struct PointSampleView: View {
    @Environment(\.horizontalSizeClass) var hClass
    let store: StoreOf<PointReducer>
        var body: some View {
            WithViewStore(self.store, observe: { $0 }) { viewStore in
                
                let dragGesture = DragGesture().onChanged({gesture in
                    viewStore.send(.point(gesture.location))
                })
                let tapGesture = TapGesture().onEnded({ _ in
                    viewStore.send(.tap(hClass))
                })
                
                  
                let combinedGesture = tapGesture.simultaneously(with: dragGesture)
                //let combinedGesture = tapGesture.sequenced(before: dragGesture)
                //let combinedGesture = tapGesture.exclusively(before: dragGesture)
                //let combinedGesture = pressGesture.sequenced(before: dragGesture)
                
                Circle()
                    .fill(viewStore.state.color)
                    .frame(width: viewStore.state.size,height: viewStore.state.size )
                    .position(viewStore.state.point)
//                    .gesture(DragGesture().onChanged({gesture in
//                        viewStore.send(.point(gesture.location))
//                    }))
                    .gesture(
                        combinedGesture
                      )
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
                    PointSampleView(store: Store(initialState: .init(point: CGPoint(x: 100, y: 100), size: 20, color: .yellow, id: UUID()), reducer: PointReducer()))
                    PointTextView(store: Store(initialState: .init(point: CGPoint(x: 100, y: 100), size: 30, color: .yellow, id: UUID()), reducer: PointReducer()))
                        
        }

    }
}
