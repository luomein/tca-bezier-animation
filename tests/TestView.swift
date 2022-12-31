//
//  TestView.swift
//  tests
//
//  Created by MEI YIN LO on 2022/12/31.
//

import SwiftUI

struct TestView: View {
    struct MaskView : View{
        var body: some View {
            AngularGradient(
                gradient: Gradient(colors: [Color.blue, .white]),
                center: .center
                //,
                //startAngle: .degrees(130),
                //endAngle: .degrees(0)
            )
            .mask {
                Path{path in
    //                path.move(to: CGPoint(x: 0, y: 0))
    //                path.addLine(to: CGPoint(x: 100, y: 100))
    //                path.addLine(to: CGPoint(x: 100, y: 200))
    //                path.addLine(to: CGPoint(x: 200, y: 200))
    //                path.addLine(to: CGPoint(x: 300, y: 300))
                    path.addEllipse(in: CGRect(origin: CGPoint(x: 200, y: 200), size: CGSize(width: 200, height: 200)))
                }
                //.stroke()
                //.fill(.blue.gradient)
                .stroke(
    //            LinearGradient(gradient: Gradient(colors: [.red, .green]), startPoint: .top, endPoint: .bottom)
                     style: StrokeStyle(lineWidth: 46, lineCap: .round)
                )
            }

        }
    }
    struct ShapeView : View{
        var body: some View {
            Path{path in
//                path.move(to: CGPoint(x: 0, y: 0))
//                path.addLine(to: CGPoint(x: 100, y: 100))
//                path.addLine(to: CGPoint(x: 100, y: 200))
//                path.addLine(to: CGPoint(x: 200, y: 200))
//                path.addLine(to: CGPoint(x: 300, y: 300))
                path.addEllipse(in: CGRect(origin: CGPoint(x: 20, y: 200), size: CGSize(width: 200, height: 200)))
            }
            //.stroke()
            //.fill(.blue.gradient)
            .stroke(
//            LinearGradient(gradient: Gradient(colors: [.red, .green]), startPoint: .top, endPoint: .bottom)
                LinearGradient(
                                    gradient: Gradient(colors: [.red, .green]),
                                    startPoint:  .leading,
                                    endPoint: .trailing
                                )
//                AngularGradient(
//                    gradient: Gradient(colors: [Color.blue, .white]),
//                    center: .center
//                    //,
//                    //startAngle: .degrees(130),
//                    //endAngle: .degrees(0)
//                )
            , style: StrokeStyle(lineWidth: 46, lineCap: .round)
            )
        }
    }
    var body: some View {
        ZStack{
            Circle()
                .fill(
                    AngularGradient(gradient: Gradient(colors: [.red, .yellow, .green, .blue, .purple, .red]), center: .center)
                )
                .frame(width: 200, height: 200)
            Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
            MaskView()
        }
    }
}

struct TestView_Previews: PreviewProvider {
    static var previews: some View {
        TestView.ShapeView().frame(width: 200,height: 200)
    }
}
