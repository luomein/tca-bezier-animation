//
//  BezierTimeSeriesDrawingOption.swift
//  tca-bezier-animation
//
//  Created by MEI YIN LO on 2022/12/21.
//

import Foundation
import SwiftUI

struct BezierTimeSeriesDrawingOption : Codable{
    //var showLastPoint : Bool // = false
    var showTrace : Bool // = true
    var showReferenceLine : Bool // = true
    //var lastPointColor : Color // = Color.black
    var traceColor : Color // = Color.black
    var referenceColor : Color // = Color.black
    //var lastPointSize : Double //= 5
    var referenceLineWidth : Double //= 2
    var traceWidth : Double //= 2
    var plot : Bool //  = true
    var traceOption : TraceOption? = .all
    var referenceLineOption : ReferenceLineOption? = .lastOne
    
    enum TraceOption : Int, Codable{
        
        case lastOne = 0
        case all = 1
    }
    enum ReferenceLineOption : Int, Codable{
        
        case lastOne = 0
        case all = 1
    }
    
    static func initFromState(state: SingleBezierTimeSeriesReducer.State)->BezierTimeSeriesDrawingOption{
        return BezierTimeSeriesDrawingOption(
            //showLastPoint: state.showLastPoint,
            showTrace: state.showTrace,
            showReferenceLine: state.showReferenceLine,
            //lastPointColor: state.lastPointColor,
            traceColor: state.traceColor,
            referenceColor: state.referenceColor,
            //lastPointSize: state.lastPointSize,
            referenceLineWidth: state.referenceLineWidth,
            traceWidth: state.traceWidth,
            plot: state.plot,
            traceOption: state.traceOption,
            referenceLineOption : state.referenceLineOption
        )
    }
    
    static func encodedFromState(state: SingleBezierTimeSeriesReducer.State)->Data{
            let encoder = JSONEncoder()
            do{
                return try encoder.encode(
                    initFromState(state: state)
                )
            }catch{
                fatalError()
            }
        }
}
