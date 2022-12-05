//
//  TCA.swift
//  labPlayground
//
//  Created by MEI YIN LO on 2022/12/2.
//

import Foundation
import SwiftUI
import ComposableArchitecture

extension CGPoint : Hashable{
    public func hash(into hasher: inout Hasher) {
        hasher.combine(x)
        hasher.combine(y)
    }
    
    
}
struct IdentifiedCGPointArray: Identifiable, Equatable{
    let id : UUID //= UUID()
    var ptArray : [CGPoint]
    var lastPoint : CGPoint{
        get {return ptArray.last!}
        set(newValue){
            ptArray[ptArray.count - 1] = newValue
        }
    }
    public init(id: UUID = UUID() , ptArray: [CGPoint] = []) {
        self.id = id
        self.ptArray = ptArray
    }
    
}



extension Feature{
    func cleanTrace(state: inout State){
        BezierOrderLayerReducer.cleanTrace(state: &state.bezierOrderLayer1)
        BezierOrderLayerReducer.cleanTrace(state: &state.bezierOrderLayer2)
        BezierOrderLayerReducer.cleanTrace(state: &state.bezierOrderLayer3)
    }
    func calculateLocation(start:CGPoint, end:CGPoint, t: Double)->CGPoint{
        return CGPoint(x: (1.0-t) * start.x + t * end.x , y:  (1.0-t) * start.y + t * end.y )
    }
    func calculateBezierOrderLayerNewPoint(referencePoints: IdentifiedArray<UUID,IdentifiedCGPointArray>, t: Double, state: inout BezierOrderLayerReducer.State){
        state.referencePoints = referencePoints.map({$0.lastPoint})
        calculateNewPoint(referencePoints: referencePoints, t: t, state: &state.allPtArray)
    }
    func calculateAllBezierOrderLayerNewPoint(state: inout State, t: Double){
        calculateBezierOrderLayerNewPoint(referencePoints: state.controlPoints.allPtArray, t: t, state: &state.bezierOrderLayer1)
        calculateBezierOrderLayerNewPoint(referencePoints: state.bezierOrderLayer1.allPtArray, t: t, state: &state.bezierOrderLayer2)
        calculateBezierOrderLayerNewPoint(referencePoints: state.bezierOrderLayer2.allPtArray, t: t, state: &state.bezierOrderLayer3)
    }
    func calculateNewPoint(referencePoints: IdentifiedArray<UUID,IdentifiedCGPointArray>, t: Double, state: inout IdentifiedArray<UUID,IdentifiedCGPointArray>){
            assert(referencePoints.count>=2)
            var referencePointsCopy = referencePoints
                var tempPt = referencePointsCopy.removeFirst().ptArray.last!
            let result = referencePointsCopy.reduce([CGPoint]()) { partialResult, element in
                
                let combined = partialResult + [calculateLocation(start: tempPt, end: element.ptArray.last!, t: t)]
                tempPt = element.ptArray.last!
                return combined
            }
            if state.count > 0 {
                let combined = Array(zip(state, result))
                state = IdentifiedArray(uniqueElements:  combined.map({
                    IdentifiedCGPointArray(id: idProvider(), ptArray:  $0.0.ptArray + [$0.1] )
                })
                )
            }else{
                state = IdentifiedArray(uniqueElements: result.map({ IdentifiedCGPointArray(id: idProvider(), ptArray:  [$0] ) }) )
            }
        }
}
struct Feature: ReducerProtocol {
    var idProvider : ()->UUID
    init(idProvider: @escaping () -> UUID = {UUID()}) {
        self.idProvider = idProvider
    }
    struct State: Equatable {
        struct DisplayOptions: OptionSet {
            let rawValue: Int
            
            static let bezierOrderLayer1    = DisplayOptions(rawValue: 1 << 0)
            static let bezierOrderLayer2  = DisplayOptions(rawValue: 1 << 1)
            static let bezierOrderLayer3   = DisplayOptions(rawValue: 1 << 2)
            static let controlPoints   = DisplayOptions(rawValue: 1 << 3)
        }
        var timer = TimerReducer.State()
        
        var controlPoints = BezierOrderLayerReducer.State(expandingDrawingID: .controlPoints, allPtArray: IdentifiedArray(uniqueElements: [ IdentifiedCGPointArray(ptArray: [CGPoint(x: 10.0, y: 10.0)] ) ,
                                                                                                                                            IdentifiedCGPointArray(ptArray: [CGPoint(x: 100.0, y: 150.0)] ) ,
                                                                                                                                            IdentifiedCGPointArray(ptArray: [CGPoint(x: 200.0, y: 200.0)] ),
                                                                                                                                            IdentifiedCGPointArray(ptArray: [CGPoint(x: 320.0, y: 150.0)])
                                                                                                                                          ] ))
        var bezierOrderLayer1 = BezierOrderLayerReducer.State( expandingDrawingID: .bezierOrderLayer1)
        var bezierOrderLayer2 = BezierOrderLayerReducer.State( expandingDrawingID: .bezierOrderLayer2)
        var bezierOrderLayer3 = BezierOrderLayerReducer.State( expandingDrawingID: .bezierOrderLayer3)
    }
    
    enum Action: Equatable {
        case movePoint(id: UUID, action: SinglePointReducer.Action)
        
       
//        case parameterTotalStep(Double)
//        case parameterTimerSpeed(Double)
//
//        case startTimer(Bool)
//        case toggleTimer(Bool)
//        case progressTimer(Double)
//        case slideTimer(Double)
        
        //case resetState
        case calculateNewPoint
        
        case jointTimerReducer(TimerReducer.Action)
        
        case jointControlPointsReducer(BezierOrderLayerReducer.Action)
        case jointBezierOrderLayer1Reducer(BezierOrderLayerReducer.Action)
        case jointBezierOrderLayer2Reducer(BezierOrderLayerReducer.Action)
        case jointBezierOrderLayer3Reducer(BezierOrderLayerReducer.Action)
    }
    var body: some ReducerProtocol<State, Action> {
        Scope(state: \.timer, action: /Action.jointTimerReducer) {
            TimerReducer()
        }
        Scope(state: \.controlPoints, action: /Action.jointControlPointsReducer) {
            BezierOrderLayerReducer()
        }
        Scope(state: \.bezierOrderLayer1, action: /Action.jointBezierOrderLayer1Reducer) {
            BezierOrderLayerReducer()
        }
        Scope(state: \.bezierOrderLayer2, action: /Action.jointBezierOrderLayer2Reducer) {
            BezierOrderLayerReducer()
        }
        Scope(state: \.bezierOrderLayer3, action: /Action.jointBezierOrderLayer3Reducer) {
            BezierOrderLayerReducer()
        }
        Reduce { state, action in
            switch action{
            case .movePoint:
                return EffectTask(value: .jointTimerReducer(.resetState))
            
            case .calculateNewPoint:
                calculateAllBezierOrderLayerNewPoint(state: &state, t: state.timer.t)
                return .none
//            case .resetState:
//                resetState(state: &state)
//                return EffectTask(value: .calculateNewPoint)
            
            
            case .jointControlPointsReducer(let sideEffect):
                switch sideEffect{
                case .expandingDrawingID(let value):
                    state.bezierOrderLayer1.expandingDrawingOptions = false
                    state.bezierOrderLayer2.expandingDrawingOptions = false
                    state.bezierOrderLayer3.expandingDrawingOptions = false
                    return .none
                default:
                    return .none
                }
                
            case .jointBezierOrderLayer1Reducer(let sideEffect):
                switch sideEffect{
                                case .expandingDrawingID(let value):
                                    state.controlPoints.expandingDrawingOptions = false
                                    state.bezierOrderLayer2.expandingDrawingOptions = false
                                    state.bezierOrderLayer3.expandingDrawingOptions = false
                                    return .none
                                default:
                                    return .none
                                }
            case .jointBezierOrderLayer2Reducer(let sideEffect):
                switch sideEffect{
                                case .expandingDrawingID(let value):
                                    state.bezierOrderLayer1.expandingDrawingOptions = false
                                    state.controlPoints.expandingDrawingOptions = false
                                    state.bezierOrderLayer3.expandingDrawingOptions = false
                                    return .none
                                default:
                                    return .none
                                }
            case .jointBezierOrderLayer3Reducer(let sideEffect):
                switch sideEffect{
                                case .expandingDrawingID(let value):
                                    state.bezierOrderLayer1.expandingDrawingOptions = false
                                    state.bezierOrderLayer2.expandingDrawingOptions = false
                                    state.controlPoints.expandingDrawingOptions = false
                                    return .none
                                default:
                                    return .none
                                }
            case .jointTimerReducer(let timerSideEffect):
                switch timerSideEffect{
                case .timerProgressUpdated:
                    return EffectTask(value: .calculateNewPoint)
                case .timerInitStateUpdated:
                    cleanTrace(state: &state)
                    for i in 0...Int(state.timer.timerProgress){
                        //var t : Double { timerProgress / Double(parameter.totalStep )}
                        let t = Double(i) / Double(state.timer.parameter.totalStep)
                        calculateAllBezierOrderLayerNewPoint(state: &state, t: t)
                    }
                    return .none
                default:
                    return .none
                }
            }
        }
        .forEach(\.controlPoints.allPtArray, action: /Action.movePoint(id:action:)) {
            SinglePointReducer()
        }
    }

    
}
