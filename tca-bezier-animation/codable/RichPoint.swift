//
//  RichPoint.swift
//  tca-bezier-animation
//
//  Created by MEI YIN LO on 2022/12/21.
//

import Foundation
import SwiftUI
import MultipleTimeSeriesReducer

struct  RichPoint : Codable{
    var point : CGPoint
    var size : Double
    var color : Color

    static func encodedFromState(state: [PointReducer.State])->Data{
        let encoder = JSONEncoder()
        do{
            return try encoder.encode(state.map({
                RichPoint(point: $0.point, size: $0.size, color: $0.color)
            }))
        }catch{
            fatalError()
        }
    }
}

