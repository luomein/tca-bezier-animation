//
//  BezierTimeSeriesPopoverView.swift
//  tca-bezier-animation
//
//  Created by MEI YIN LO on 2022/12/26.
//

import SwiftUI
import ComposableArchitecture
import SwiftUINavigation
import BezierTimeSeriesReducer

struct SingleBezierTimeSeriesPopoverView: View {
    @Binding var editingState : SingleBezierTimeSeriesReducer.State.PopoverEditingState
    let title: String
    
    var body: some View {
        
        Form{
            Section {
                Toggle(title, isOn: $editingState.plot)
            }
            Section("Trace") {

                Toggle("Show", isOn: $editingState.showTrace)
                Picker("Element", selection: $editingState.traceOption) {
                    Text("All").tag(BezierTimeSeriesDrawingOption.TraceOption.all)
                    Text("Last One").tag(BezierTimeSeriesDrawingOption.TraceOption.lastOne)
                }

                ColorPicker("Color", selection: $editingState.traceColor)
                HStack{
                    Text("Size")
                    Spacer()
                    Slider(value: $editingState.traceWidth,in: 1...20).frame(width: 100)//.padding(10)
                }
            }

            Section("Reference Line") {

                Toggle("Show", isOn: $editingState.showReferenceLine)
                Picker("Element", selection: $editingState.referenceLineOption) {
                    Text("All").tag(BezierTimeSeriesDrawingOption.ReferenceLineOption.all)
                    Text("Last One").tag(BezierTimeSeriesDrawingOption.ReferenceLineOption.lastOne)
                }

                ColorPicker("Color", selection: $editingState.referenceColor)
                HStack{
                    Text("Size")
                    Spacer()
                    Slider(value: $editingState.referenceLineWidth,in: 1...10).frame(width: 100)//.padding(10)
                }
            }
            
        }
        
        
    }
}
