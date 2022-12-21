//
//  PointArrayReducer.swift
//  tca-bezier-animation
//
//  Created by MEI YIN LO on 2022/12/17.
//

import Foundation
import IdentifiedCollections
import ComposableArchitecture
import SwiftUI

struct SingleTimeSeriesPointsReducer: ReducerProtocol {
    struct State: Equatable, Identifiable{
        var id: UUID
        var timeSeries : IdentifiedArray<PointReducer.State.ID, PointReducer.State>
        
        static func initFromOrigin(point: CGPoint, stateId: UUID = UUID(),
                                   pointID: UUID = UUID() )->State{
            return State(id: stateId, timeSeries: IdentifiedArray(uniqueElements: [
                PointReducer.State(point: point, size: 10, color: .black, id: pointID)
            ]))
        }
        static func initFromOrigin(richPoint: RichPoint, stateId: UUID = UUID(),
                                           pointID: UUID = UUID() )->State{
                    return State(id: stateId, timeSeries: IdentifiedArray(uniqueElements: [
                        PointReducer.State(point: richPoint.point, size: richPoint.size, color: richPoint.color, id: pointID)
                    ]))
                }
    }
    enum Action : Equatable{
        case notificationPosizitionChanged
        case jointReducerAction(PointReducer.State.ID, PointReducer.Action)
    }
    var body: some ReducerProtocol<State, Action> {
        Reduce{state, action  in
            switch action{
            case .jointReducerAction(_, let pointAction):
                switch pointAction{
                case .notificationPosizitionChanged:
                    return EffectTask(value: .notificationPosizitionChanged)
                default:
                    return .none
                }
            case .notificationPosizitionChanged:
                return .none
            }
        }
        .forEach(\.timeSeries, action: /Action.jointReducerAction) {
            PointReducer()
        }
    }
}
struct MultipleTimeSeriesPointsReducer: ReducerProtocol {
    struct State: Equatable{
        
        
        //var id: UUID
        var multipleSeries : IdentifiedArray<SingleTimeSeriesPointsReducer.State.ID, SingleTimeSeriesPointsReducer.State>
         = IdentifiedArray(uniqueElements: [] )

        static func initFromOrigin(points: [CGPoint])->State{
            return State(multipleSeries: IdentifiedArray(uniqueElements: points.map({
                SingleTimeSeriesPointsReducer.State.initFromOrigin(point: $0)
            })))

        }
        static func initFromOrigin(richPoints: [RichPoint])->State{
            return State(multipleSeries: IdentifiedArray(uniqueElements: richPoints.map({
                SingleTimeSeriesPointsReducer.State.initFromOrigin(richPoint: $0)
            })))
            
        }
        static func initFromGeometry(size: CGSize)->State{
            let center = CGPoint(x: size.width/2, y: size.height/2)
            let xrange =  Int(size.width/2)
            let yrange = Int(size.height/2)
            let pt1 = CGPoint(x: center.x - Double(Int.random(in: 10...xrange)), y: center.y - Double(Int.random(in: 10...yrange)))
            let pt2 = CGPoint(x: center.x - Double(Int.random(in: 10...xrange)), y: center.y + Double(Int.random(in: 10...yrange)))
            let pt3 = CGPoint(x: center.x + Double(Int.random(in: 10...xrange)), y: center.y + Double(Int.random(in: 10...yrange)))
            let pt4 = CGPoint(x: center.x + Double(Int.random(in: 10...xrange)), y: center.y - Double(Int.random(in: 10...yrange)))
//            print("initFromGeometryProxy")
            return initFromOrigin(points: [pt1,pt2,pt3,pt4])
        }
    }
    enum Action : Equatable{
        case notificationPosizitionChanged
        case jointReducerAction(SingleTimeSeriesPointsReducer.State.ID, SingleTimeSeriesPointsReducer.Action)
//        case jointLatestPointsReducerAction(PointReducer.State.ID,PointReducer.Action)
    }
    var body: some ReducerProtocol<State, Action> {
        Reduce{state, action  in
            switch action{
            case .jointReducerAction(_, let subAction):
                switch subAction{
                case .notificationPosizitionChanged:
                    return EffectTask(value: .notificationPosizitionChanged)
                default:
                    return .none
                }
            case .notificationPosizitionChanged:
                return .none
            }
        }
        .forEach(\.multipleSeries, action: /Action.jointReducerAction) {
            SingleTimeSeriesPointsReducer()
        }
//        .forEach(\.latestPoints, action: /Action.jointLatestPointsReducerAction) {
//            PointReducer()
//        }
    }
}
