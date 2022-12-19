//
//  FitPopoverViewModifier.swift
//  tca-bezier-animation
//
//  Created by MEI YIN LO on 2022/12/19.
//

import Foundation
import SwiftUI


struct FitPopoverViewModifier : ViewModifier{
    @Environment(\.dismiss) var dismiss
    var width : Double
    var height : Double
    func body(content: Content) -> some View {
        if UIDevice.current.userInterfaceIdiom == .phone{
            content
                .presentationDetents([.medium, .large])
                .onTapGesture {
                    dismiss()
                }
        }
        else{
            content
                .frame(width:width,height: height)
                .background(Color.gray.opacity(0.2) )
                .scrollContentBackground(.hidden)
        }
        
    }
}
struct FitPopoverViewModifier_Previews: PreviewProvider {
    static var previews: some View {
        Form{
            Text("test")
        }
            .modifier(FitPopoverViewModifier(width: 100, height: 100))
    }
}
