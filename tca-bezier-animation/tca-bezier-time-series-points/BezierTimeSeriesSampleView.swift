//
//  BezierTimeSeriesSampleView.swift
//  tca-bezier-animation
//
//  Created by MEI YIN LO on 2022/12/18.
//

import SwiftUI
import ComposableArchitecture
import SwiftUINavigation

struct BezierTimeSeriesPopoverView: View {
    @Binding var editingState : BezierTimeSeriesPointsReducer.State.PopoverEditingState
    let title: String
    
    var body: some View {
        
        Form{
            Section {
                Toggle(title, isOn: $editingState.plot)
            }
            Section("Point") {
                
                Toggle("Show", isOn: $editingState.showLastPoint)
                ColorPicker("Color", selection: $editingState.lastPointColor)
                HStack{
                    Text("Size")
                    Spacer()
                    Slider(value: $editingState.lastPointSize,in: 2...30).frame(width: 100)//.padding(10)
                }
            }
            Section("Reference Line") {
                
                Toggle("Show", isOn: $editingState.showReferenceLine)
                ColorPicker("Color", selection: $editingState.referenceColor)
                HStack{
                    Text("Size")
                    Spacer()
                    Slider(value: $editingState.referenceLineWidth,in: 1...10).frame(width: 100)//.padding(10)
                }
            }
            Section("Trace") {
                
                Toggle("Show", isOn: $editingState.showTrace)
                ColorPicker("Color", selection: $editingState.traceColor)
                HStack{
                    Text("Size")
                    Spacer()
                    Slider(value: $editingState.traceWidth,in: 1...10).frame(width: 100)//.padding(10)
                }
            }
        }
        
        
    }
}
struct BezierTimeSeriesConfigListItemView: View {
    let store: StoreOf<BezierTimeSeriesPointsReducer>
    let title: String
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            HStack{
                Toggle(title, isOn: viewStore.binding(get: \.plot, send: {BezierTimeSeriesPointsReducer.Action.plot($0)})).padding()
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
