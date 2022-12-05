//
//  BezierOrderLayerReducer.swift
//  labPlayground
//
//  Created by MEI YIN LO on 2022/12/5.
//

import Foundation
import SwiftUI
import ComposableArchitecture

struct BezierOrderLayerReducer:ReducerProtocol {
    struct State: Equatable {
        
        struct DrawingOptions: Equatable{
            var pointSize: Double = 15.0
            var pointColor = Color.black
            var drawReferenceLine = true
            var drawTrace = true
            var draw = true
            var colorReferenceLine = Color.yellow
            var colorTrace = Color.blue
        }
        var expandingDrawingOptions = false
        var expandingDrawingID : Feature.State.DisplayOptions
        var drawingOptions = DrawingOptions()
        var allPtArray: IdentifiedArray<UUID,IdentifiedCGPointArray> = []
        var referencePoints: [CGPoint] = []
    }
    static func cleanTrace(state: inout BezierOrderLayerReducer.State){
        state.allPtArray = []
        state.referencePoints = []
    }
    enum Action : Equatable{
        case drawReferenceLine(Bool)
        case drawTrace(Bool)
        case drawPointSize(Double)
        case pointColor(Color)
        case colorReferenceLine(Color)
        case colorTrace(Color)
        case draw(Bool)
        case expandingDrawingOptions(Bool)
        case expandingDrawingID(Feature.State.DisplayOptions)
    }
    func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
        switch action{
        case .expandingDrawingID:
            return .none
        case .expandingDrawingOptions(let value):
            state.expandingDrawingOptions = value
            return EffectTask(value: .expandingDrawingID(state.expandingDrawingID))
        case .draw(let value):
            state.drawingOptions.draw = value
            state.drawingOptions.drawTrace = value
            state.drawingOptions.drawReferenceLine = value
            return .none
        case .drawReferenceLine(let value):
            state.drawingOptions.drawReferenceLine = value
            state.drawingOptions.draw = value
            return .none
        case .drawTrace(let value):
            state.drawingOptions.drawTrace = value
            state.drawingOptions.draw = value
            return .none
        case .drawPointSize(let value):
            state.drawingOptions.pointSize = value
            return .none
        case .pointColor(let value):
            state.drawingOptions.pointColor = value
            return .none
        case .colorReferenceLine(let value):
            state.drawingOptions.colorReferenceLine = value
            return .none
        case .colorTrace(let value):
            state.drawingOptions.colorTrace = value
            return .none
        }
    }
}
