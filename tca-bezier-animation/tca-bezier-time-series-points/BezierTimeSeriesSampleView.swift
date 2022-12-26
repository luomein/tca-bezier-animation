//
//  BezierTimeSeriesSampleView.swift
//  tca-bezier-animation
//
//  Created by MEI YIN LO on 2022/12/18.
//

import SwiftUI
import ComposableArchitecture
import SwiftUINavigation


struct BezierTimeSeriesConfigListItemView: View {
    let store: StoreOf<BezierTimeSeriesPointsReducer>
    let title: String
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            HStack{
                Toggle(title, isOn: viewStore.binding(get: \.plot, send: {BezierTimeSeriesPointsReducer.Action.plot($0)})).padding(.trailing)
                Button {
                    viewStore.send(.startPopoverEdit)
                } label: {
                    Text(Image(systemName: "square.on.square"))
                }
            }
            .popover(unwrapping: viewStore.binding(get: \.popoverEditingState, send: BezierTimeSeriesPointsReducer.Action.popoverEditing) ) { $value in
                BezierTimeSeriesPopoverView(editingState: $value, title: title)
                    .modifier(FitPopoverViewModifier(width: 300, height: 800))
                        }
        }
    }
}

struct BezierTimeSeriesSampleView_Previews: PreviewProvider {
    static var previews: some View {
        let editingState = BezierTimeSeriesPointsReducer.State.PopoverEditingState()
        WithState(initialValue: editingState) { $value in
            BezierTimeSeriesPopoverView(editingState: $value, title: "test")
        }
        
    }
}
