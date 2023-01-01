//
//  AwardView.swift
//  tests
//
//  Created by MEI YIN LO on 2023/1/1.
//

import SwiftUI

struct AwardView: View {
    @State var capture: UIImage?
    var body: some View {
        let trophyAndDate = createAwardView(forUser: "test",
                                             date: Date())
        VStack {
            //trophyAndDate
            
            Button("Save Achievement") {
                //let renderer = ImageRenderer(content: trophyAndDate)
                let renderer = ImageRenderer(content: testView())
                capture = renderer.uiImage
//                if let image = renderer.uiImage {
//                    uploadAchievementImage(image)
//                }
            }
            if let capture{
                Image(uiImage: capture)
            }
        }
    }
    func  testView()->some View{
        Path{path in
            path.addEllipse(in: CGRect(origin: CGPoint(x: 200, y: 200), size: CGSize(width: 200, height: 200)))
        }.stroke()
    }
    private func createAwardView(forUser: String, date: Date) -> some View {
        //GeometryReader { proxy in
            VStack {
                Image(systemName: "trophy")
                    .resizable()
                    .frame(width: 200, height: 200)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .shadow(color: .mint, radius: 5)
                Text(forUser)
                    .font(.largeTitle)
                Text(date.formatted())
            }
            .multilineTextAlignment(.center)
            .frame(width: 200, height: 290)
        //}
        
    }
}

struct AwardView_Previews: PreviewProvider {
    static var previews: some View {
        AwardView()
    }
}
