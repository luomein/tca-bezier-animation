//
//  BezierShapeView.swift
//  tca-bezier-animation
//
//  Created by MEI YIN LO on 2022/12/9.
//

import SwiftUI

struct BezierShapeView: View {
    let ptArray : [CGPoint]
    var body: some View {
        Path { path in
            path.move(to: ptArray[0])
            path.addCurve(to: ptArray[3],
                          control1: ptArray[1],
                          control2: ptArray[2])
        }
        .stroke(Color.blue)
    }
}

struct BezierShapeView_Previews: PreviewProvider {
    static var previews: some View {
        BezierShapeView(ptArray: [CGPoint(x: 10, y: 10),
                                  CGPoint(x: 40, y: 80),
                                 CGPoint(x: 60, y: 90),
                                 CGPoint(x: 100, y: 140)])
    }
}
