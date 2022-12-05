//
//  DrawView.swift
//  labPlayground
//
//  Created by MEI YIN LO on 2022/12/3.
//

import SwiftUI
import ComposableArchitecture

struct SegmentLineShape: Shape{
    let ptList : [CGPoint]
    func path(in rect: CGRect) -> Path {
        Path { path in
            path.addLines(ptList)
        }
    }
}
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


struct DrawView : View {
    let store: StoreOf<Feature>
    
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in

            ZStack{
                TimerProgressView(store: store.scope(state: \.timer, action: {.jointTimerReducer($0)}))
                if viewStore.controlPoints.drawingOptions.draw{
                    ForEachStore(store.scope(state: \.controlPoints.allPtArray, action: {childAction in
                        Feature.Action.movePoint(id: childAction.0, action: childAction.1)
                    })) { singlePointStore in
                        SinglePointView(store: singlePointStore, ptSize: viewStore.controlPoints.drawingOptions.pointSize, color: viewStore.controlPoints.drawingOptions.pointColor)
                    }
                }
                BezierOrderLayerView(store: store.scope(state: \.bezierOrderLayer1, action: {.jointBezierOrderLayer1Reducer($0)}))
                BezierOrderLayerView(store: store.scope(state: \.bezierOrderLayer2, action: {.jointBezierOrderLayer2Reducer($0)}))
                BezierOrderLayerView(store: store.scope(state: \.bezierOrderLayer3, action: {.jointBezierOrderLayer3Reducer($0)}))

            }.padding(30)
                
        }
    }
}
struct DrawView_Previews: PreviewProvider {
    static var previews: some View {
        DrawView(store: Store(initialState: Feature.State(),
                              reducer: Feature()))
    }
}
