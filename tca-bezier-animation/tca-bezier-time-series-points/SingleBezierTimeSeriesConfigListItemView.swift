//
//  BezierTimeSeriesSampleView.swift
//  tca-bezier-animation
//
//  Created by MEI YIN LO on 2022/12/18.
//

import SwiftUI
import ComposableArchitecture
import SwiftUINavigation
import LuomeinSwiftBasicTools
import BezierTimeSeriesReducer

struct SingleBezierTimeSeriesConfigListItemView: View {
    let store: StoreOf<SingleBezierTimeSeriesReducer>
    let title: String
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            HStack{
                Toggle(title, isOn: viewStore.binding(get: \.plot, send: {SingleBezierTimeSeriesReducer.Action.plot($0)})).padding(.trailing)
                Button {
                    viewStore.send(.startPopoverEdit)
                } label: {
                    Text(Image(systemName: "square.on.square"))
                }
            }
            .popover(unwrapping: viewStore.binding(get: \.popoverEditingState, send: SingleBezierTimeSeriesReducer.Action.popoverEditing) ) { $value in
                SingleBezierTimeSeriesPopoverView(editingState: $value, title: title)
                    .modifier(FitPopoverViewModifier(width: 300, height: 800))
                        }
        }
    }
}

struct BezierTimeSeriesSampleView_Previews: PreviewProvider {
    static var previews: some View {
        let editingState = SingleBezierTimeSeriesReducer.State.PopoverEditingState()
        WithState(initialValue: editingState) { $value in
            SingleBezierTimeSeriesPopoverView(editingState: $value, title: "test")
        }
        
    }
}
