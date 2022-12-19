//
//  tests.swift
//  tests
//
//  Created by MEI YIN LO on 2022/12/9.
//

import XCTest
@testable import tca_bezier_animation

import ComposableArchitecture
import SwiftUI

//@MainActor
//class CounterTests: XCTestCase {
//    func testBasics() async {
//        let uuid = UUID()
//        let child = ChildReducer.State(id: uuid, pt: CGPoint(x: 0, y: 0))
//        let store = TestStore(initialState: ParentReducer.State(children: [child]), reducer: ParentReducer())
//        await store.send(.joinReducerAction(child.id, .movePoint(CGPoint(x: 100, y: 100)))){
//            $0.children[id: uuid]!.pt = CGPoint(x: 100, y: 100)
//        }
//    }
//}
//@MainActor
//class BezierTimeSeriesPointsReducerTests: XCTestCase{
//    func testBasics() async {
//        let store = TestStore(initialState: BezierTimeSeriesPointsReducer.State(multipleSeries: .initFromOrigin(points: [])), reducer: BezierTimeSeriesPointsReducer())
//        store.dependencies.uuid = .incrementing
//        let reference = MultipleTimeSeriesPointsReducer.State.initFromOrigin(points: [CGPoint(x: 100, y: 100),
//                                                                                     CGPoint(x: 200, y: 200)
//                                                                                     ])
//        //await store.send(.calculateNewPoint(referencePoints: reference, t: 0.5))
//    }
//}

final class tests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }

}
