//
//  SinglePointView.swift
//  tca-bezier-animation
//
//  Created by MEI YIN LO on 2022/12/8.
//

import SwiftUI
import ComposableArchitecture

struct PointsShape: Shape {
    let ptList : [CGPoint]
    let ptSize : Double
    var ellipseSize : CGSize{
        return CGSize(width: ptSize, height: ptSize)
    }
    func calculateOrigin(pt: CGPoint, ptSize: Double)->CGPoint{
        return CGPoint(x: pt.x - ptSize/2, y: pt.y - ptSize/2)
    }
    func path(in rect: CGRect) -> Path {
        Path { path in
            //path.move(to: CGPoint(x: 0, y: 0))
            for pt in ptList {
                //path.addLine(to: pt)
                path.addEllipse(in: CGRect(origin: calculateOrigin(pt: pt, ptSize: ptSize), size: ellipseSize), transform: .identity)
                    
                
            }
        }
    }
}

struct SinglePointView: View{
    let store: StoreOf<SinglePointReducer>
    let ptSize : Double
    let color : Color
    @GestureState private var startLocation: CGPoint? = nil
    
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            let dragGesture = DragGesture()
                .onChanged { value in
                                var newLocation = startLocation ?? viewStore.ptArray.last!
                                newLocation.x += value.translation.width
                                newLocation.y += value.translation.height
                                //self.location = newLocation
                    viewStore.send(.movePoint(newLocation))
                            }.updating($startLocation) { (value, startLocation, transaction) in
                                startLocation = startLocation ?? viewStore.ptArray.last!
                            }
            PointsShape(ptList: [viewStore.ptArray.last!], ptSize: ptSize)
                .foregroundColor(color)
                .gesture(dragGesture)
        }
    }
}
