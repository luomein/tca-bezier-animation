//
//  EnvironmentKey.swift
//  tca-bezier-animation
//
//  Created by MEI YIN LO on 2022/12/18.
//

import Foundation
import SwiftUI
import ComposableArchitecture

struct EnvironmentVariables : Equatable {
    var canvasSize : CGSize = .zero
    
}
extension EnvironmentVariables: DependencyKey {
  static let liveValue = EnvironmentVariables()
}



extension DependencyValues {
  var environmentVariables: EnvironmentVariables {
    get { self[EnvironmentVariables.self] }
    set { self[EnvironmentVariables.self] = newValue }
  }
    
}
//private struct MainWindowSizeKey: EnvironmentKey {
//    static let defaultValue: CGSize = .zero
//}
//
//extension EnvironmentValues {
//    var mainWindowSize: CGSize {
//        get { self[MainWindowSizeKey.self] }
//        set { self[MainWindowSizeKey.self] = newValue }
//    }
//}
