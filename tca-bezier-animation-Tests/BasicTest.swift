//
//  BasicTest.swift
//  tca-bezier-animationTests
//
//  Created by MEI YIN LO on 2022/12/9.
//

//import XCTest
//import ComposableArchitecture
//import SwiftUI
//
//@MainActor
//class CounterTests: XCTestCase {
//    func testBasics() async {
//        let uuid = UUID()
//        let child = ChildReducer.State(id: uuid, pt: CGPoint(x: 0, y: 0))
//        let store = TestStore(initialState: ParentReducer.State(children: []), reducer: ParentReducer())
//        await store.send(.joinReducerAction(child.id, .movePoint(CGPoint(x: 100, y: 100)))){
//            $0.children[id: uuid]!.pt = CGPoint(x: 100, y: 100)
//        }
//    }
//}
