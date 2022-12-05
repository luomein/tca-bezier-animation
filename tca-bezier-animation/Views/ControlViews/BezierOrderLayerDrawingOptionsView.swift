//
//  BezierOrderLayerDrawingOptionsView.swift
//  tca-bezier-animation
//
//  Created by MEI YIN LO on 2022/12/5.
//

import SwiftUI
import ComposableArchitecture

struct BezierOrderLayerDrawingOptionsView : View {
    struct DisplayOptions: OptionSet {
        let rawValue: Int

        static let pointSize    = DisplayOptions(rawValue: 1 << 0)
        static let drawReferenceLine  = DisplayOptions(rawValue: 1 << 1)
        static let drawTrace   = DisplayOptions(rawValue: 1 << 2)
        

        static let all: DisplayOptions = [.pointSize, .drawReferenceLine, .drawTrace]
    }
    let store: StoreOf<BezierOrderLayerReducer>
    let title: String
    let displayOptions : DisplayOptions
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            DisclosureGroup {
                VStack{
                    if displayOptions.contains(.pointSize){
                        HStack{
                            Text("Point Size")
                            Spacer()
                            Slider(value: viewStore.binding(get: \.drawingOptions.pointSize, send: {.drawPointSize($0)} ),
                                   in: 5.0...20.0, step: 1.0
                            )
                        }
                    }
                    if displayOptions.contains(.drawReferenceLine){
                        
                        ColorPicker(selection: viewStore.binding(get: \.drawingOptions.colorReferenceLine, send: {.colorReferenceLine($0)})) {
                            HStack{
                                
                                Toggle(isOn: viewStore.binding(get: \.drawingOptions.drawReferenceLine, send: {.drawReferenceLine($0)}), label: {EmptyView()})
                                Text("Reference Line")
                                    .minimumScaleFactor(0.01)
                                    .lineLimit(1)
                                
                            }
                        }
                    }
                    if displayOptions.contains(.drawTrace){
                        ColorPicker( selection: viewStore.binding(get: \.drawingOptions.colorTrace, send: {.colorTrace($0)}))
                        {
                            HStack{
                                Toggle(isOn: viewStore.binding(get: \.drawingOptions.drawTrace, send: {.drawTrace($0)}), label: {EmptyView()})
                                Text("Trace")
                                    .minimumScaleFactor(0.01)
                                    .lineLimit(1)
                                
                            }
                        }
                    }
                }
            } label: {
                ColorPicker(selection: viewStore.binding(get: \.drawingOptions.pointColor, send: {.pointColor($0)})){
                    HStack{
                        Toggle(isOn: viewStore.binding(get: \.drawingOptions.draw, send: {.draw($0)}), label: {EmptyView()})
                        Text(title)
                            .minimumScaleFactor(0.01)
                            .lineLimit(1)
                        
                    }
                }
                
            }

        }
    }
}
