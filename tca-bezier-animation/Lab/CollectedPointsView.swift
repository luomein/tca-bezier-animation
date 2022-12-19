//
//  CollectedPointsView.swift
//  tca-bezier-animation
//
//  Created by MEI YIN LO on 2022/12/8.
//

import SwiftUI
import ComposableArchitecture
import IdentifiedCollections

struct ParentView: View{
    let store: StoreOf<ParentReducer>
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            ZStack{
                ForEachStore(store.scope(state: \.children, action: ParentReducer.Action.joinReducerAction)){childStore in
                    ChildView(store: childStore)
                }
                BezierShapeView(ptArray: viewStore.children.map({$0.pt}))
                
//                VStack{
//                    Spacer()
//                    ForEach(viewStore.children) { child in
//                        Text("(\(Int(child.pt.x)),\(Int(child.pt.y)))")
//                    }
//                }
            }
        }
    }
}
struct ChildView: View {
    let store: StoreOf<ChildReducer>
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
struct ChildReducer: ReducerProtocol {
    struct State: Equatable, Identifiable{
        var id : UUID
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
struct ParentReducer: ReducerProtocol {
    struct State: Equatable{
        var children : IdentifiedArray<ChildReducer.State.ID, ChildReducer.State>
    }
    enum Action : Equatable{
        case joinReducerAction(ChildReducer.State.ID, ChildReducer.Action)
    }
    var body: some ReducerProtocol<State, Action> {
        Reduce{state, action  in
            return .none
        }
        .forEach(\.children, action: /Action.joinReducerAction) {
            ChildReducer()
        }
    }
}

//struct CollectedPointsViewReducer: ReducerProtocol {
//    @Dependency(\.uuid) var uuid
//    
//    struct State: Equatable{
//        var ptCollection = IdentifiedArray(uniqueElements: [SimpleSinglePointViewReducer.State]())
//    }
//    enum Action : Equatable{
//        case addPoint(CGPoint)
//        case joinSimpleSinglePointViewReducerAction(SimpleSinglePointViewReducer.State.ID,SimpleSinglePointViewReducer.Action)
//    }
//    var body: some ReducerProtocol<State, Action> {
//    //func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
//        Reduce{state, action  in
//            switch action{
//            case .addPoint(let pt):
//                state.ptCollection.append(.init(id: self.uuid(), pt: pt))
//                return .none
//            case .joinSimpleSinglePointViewReducerAction:
//                return .none
//            }
//        }.forEach(\.ptCollection, action: /CollectedPointsViewReducer.Action.joinSimpleSinglePointViewReducerAction){
//            SimpleSinglePointViewReducer()
//        }
//    }
//}

struct CollectedPointsView: View {
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct ParentView_Previews: PreviewProvider {
    static var previews: some View {
        ParentView(store: Store(initialState: .init(children: IdentifiedArray(uniqueElements: [ChildReducer.State(id: UUID(), pt: CGPoint(x: 30, y: 60)),
                                                                                               ChildReducer.State(id: UUID(), pt: CGPoint(x: 90, y: 250)),
                                                                                               ChildReducer.State(id: UUID(), pt: CGPoint(x: 250, y: 250)),
                                                                                               ChildReducer.State(id: UUID(), pt: CGPoint(x: 300, y: 150))])),
                                reducer: ParentReducer()))
    }
}
