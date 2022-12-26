//
//  BezierTimeSeriesPointsReducer.swift
//  tca-bezier-animation
//
//  Created by MEI YIN LO on 2022/12/18.
//

import Foundation
import SwiftUI
import ComposableArchitecture

struct BezierTimeSeriesPointsReducer: ReducerProtocol{
    @Dependency(\.uuid) var uuid
    struct State: Equatable {
        var trace : MultipleTimeSeriesPointsReducer.State
        //var showLastPoint = false
        var showTrace = true
        var showReferenceLine = true
        //var lastPointColor = Color.black
        var traceColor = Color.black
        var referenceColor = Color.black
        //var lastPointSize : Double = 5
        var referenceLineWidth : Double = 2
        var traceWidth : Double = 2
        var plot = true
        var popoverEditingState: PopoverEditingState?
        var traceOption : BezierTimeSeriesDrawingOption.TraceOption = .all
        var referenceLineOption : BezierTimeSeriesDrawingOption.ReferenceLineOption = .lastOne
        
        init(drawingOption: BezierTimeSeriesDrawingOption){
            self.plot = drawingOption.plot
            //self.showLastPoint = drawingOption.showLastPoint
            self.showTrace = drawingOption.showTrace
            self.showReferenceLine = drawingOption.showReferenceLine
            //self.lastPointColor = drawingOption.lastPointColor
            self.traceColor = drawingOption.traceColor
            self.referenceColor = drawingOption.referenceColor
            //self.lastPointSize = drawingOption.lastPointSize
            self.referenceLineWidth = drawingOption.referenceLineWidth
            self.traceWidth = drawingOption.traceWidth
            self.referenceLineOption = drawingOption.referenceLineOption ?? .lastOne
            self.traceOption = drawingOption.traceOption ?? .all
            
            trace = .initFromOrigin(richPoints: [])
        }
        
        struct PopoverEditingState: Equatable{
            var plot = true
            var showLastPoint = false
            var showTrace = true
            var showReferenceLine = true
            var lastPointColor = Color.black
            var traceColor = Color.black
            var referenceColor = Color.black
            var lastPointSize : Double = 5
            var referenceLineWidth : Double = 2
            var traceWidth : Double = 2
            var traceOption : BezierTimeSeriesDrawingOption.TraceOption = .all
            var referenceLineOption : BezierTimeSeriesDrawingOption.ReferenceLineOption = .lastOne
            
            func updateState( state: inout State){
                state.plot = self.plot
//                state.showLastPoint = self.showLastPoint
                state.showTrace = self.showTrace
                state.showReferenceLine = self.showReferenceLine
                //state.lastPointColor = self.lastPointColor
                state.traceColor = self.traceColor
                state.referenceColor = self.referenceColor
                //state.lastPointSize = self.lastPointSize
                state.referenceLineWidth = self.referenceLineWidth
                state.traceWidth = self.traceWidth
                state.referenceLineOption = self.referenceLineOption
                state.traceOption = self.traceOption
                
                
                
            }
            init(){
                
            }
            init(from state: State){
                self.plot = state.plot
                //self.showLastPoint = state.showLastPoint
                self.showTrace = state.showTrace
                self.showReferenceLine = state.showReferenceLine
                //self.lastPointColor = state.lastPointColor
                self.traceColor = state.traceColor
                self.referenceColor = state.referenceColor
                //self.lastPointSize = state.lastPointSize
                self.referenceLineWidth = state.referenceLineWidth
                self.traceWidth = state.traceWidth
                self.referenceLineOption = state.referenceLineOption
                self.traceOption = state.traceOption
            }
            
        }

    }
    enum Action : Equatable{
        //        case calculateNewPoint(referencePoints: MultipleTimeSeriesPointsReducer.State, t: Double)
        //        case recalculateTrace(referencePoints: MultipleTimeSeriesPointsReducer.State, tick: Double, totalTicks: Double)
        case startPopoverEdit
        case popoverEditing(State.PopoverEditingState?)
        case plot(Bool)
    }
    func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
        switch action{
        case .plot(let value):
            state.plot = value
            return .none
        case .startPopoverEdit:
            state.popoverEditingState = State.PopoverEditingState(from: state)
            return .none
        case .popoverEditing(let value):
            state.popoverEditingState = value
            if let value = value{
                let beforeUpdate = State.PopoverEditingState(from: state)
                value.updateState(state: &state)
                if beforeUpdate != value{
                    if beforeUpdate.plot && !value.plot{
                        return .none
                    }
                    else{
                        state.popoverEditingState!.plot = true
                        return EffectTask(value: .plot(true))
                    }
                }
                
            }
            return .none
        }
    }
//    func calculateLocation(start:CGPoint, end:CGPoint, t: Double)->CGPoint{
//        return CGPoint(x: (1.0-t) * start.x + t * end.x , y:  (1.0-t) * start.y + t * end.y )
//    }
//    func calculateNewPoint(referencePoints: MultipleTimeSeriesPointsReducer.State, t: Double, state: inout MultipleTimeSeriesPointsReducer.State){
//        assert(referencePoints.multipleSeries.count>=2)
//        var referencePointsCopy = referencePoints
//        var tempPt = referencePointsCopy.multipleSeries.removeFirst().timeSeries.last!
//        let result = referencePointsCopy.multipleSeries.reduce([CGPoint]()) { partialResult, element in
//            
//            let combined = partialResult + [calculateLocation(start: tempPt.point, end: element.timeSeries.last!.point, t: t)]
//            tempPt = element.timeSeries.last!
//            return combined
//        }
//        if state.multipleSeries.count > 0 {
//            let combined = Array(zip(state.multipleSeries, result))
//            state.multipleSeries = IdentifiedArray(uniqueElements:
//                                                    combined.map({
//                SingleTimeSeriesPointsReducer.State(id: $0.0.id, timeSeries: $0.0.timeSeries +
//                                                    SingleTimeSeriesPointsReducer.State.initFromOrigin(point: $0.1,
//                                                                                                       stateId: uuid(), pointID: uuid()                                          ).timeSeries
//                )
//            })
//                                                   )
//
//        }else{
//            state.multipleSeries = IdentifiedArray(uniqueElements: result.map({ //IdentifiedCGPointArray(id: uuid(), ptArray:  [$0] )
//                SingleTimeSeriesPointsReducer.State.initFromOrigin(point: $0,
//                stateId: uuid(), pointID: uuid()
//                )
//                
//            }) )
//        }
//    }
}
