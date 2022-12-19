//
//  PointEditingStatePopoverView.swift
//  tca-bezier-animation
//
//  Created by MEI YIN LO on 2022/12/18.
//

import SwiftUI
import SwiftUINavigation

struct PointEditingStatePopoverView: View {
    //@Environment(\.mainWindowSize) var mainWindowSize
    //@EnvironmentObject var environmentVariables : EnvironmentVariables
    var environmentVariables : EnvironmentVariables
    @Binding var editingState : PointReducer.State.PopoverEditingState
    var body: some View {
        Form{
            HStack{
                Text("x: \(Int(editingState.point.x))")
                Slider(value: $editingState.point.x,
                       in: 0...environmentVariables.canvasSize.width).padding(10)
            }
            HStack{
                Text("y: \(Int(editingState.point.y))")
                Slider(value: $editingState.point.y,
                       in: 0...environmentVariables.canvasSize.height).padding(10)
            }
            HStack{
                ColorPicker("color", selection: $editingState.color)
            }
            HStack{
                Text("size: \(Int(editingState.size))")
                Slider(value: $editingState.size, in: 2...30).padding(10)
            }
        }.padding(10)
            .frame(width:300,height: 400)
            
    }
}

struct PointEditingStatePopoverView_Previews: PreviewProvider {
    static var previews: some View {
        let state = PointReducer.State(point: CGPoint(x: 100, y: 100), size: 10, color: .yellow, id: UUID())
        let editingState = PointReducer.State.PopoverEditingState(from: state)
        WithState(initialValue: editingState) { $value in
            PointEditingStatePopoverView(environmentVariables:  .init(canvasSize: .init(width: 100, height: 100)), editingState: $value)
                
        }
        
    }
}
