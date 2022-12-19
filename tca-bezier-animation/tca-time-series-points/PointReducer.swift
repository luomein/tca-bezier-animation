//
//  PointReducer.swift
//  tca-bezier-animation
//
//  Created by MEI YIN LO on 2022/12/17.
//

import Foundation
import ComposableArchitecture
import SwiftUI

struct PointReducer: ReducerProtocol {
    @Dependency(\.environmentVariables) var environmentVariables
    struct State: Equatable, Identifiable{
        var point : CGPoint
        var size : Double
        var color : Color
        var id: UUID
        var popoverEditingState: PopoverEditingState?
        var environmentVariables: EnvironmentVariables = .init()
        
        struct PopoverEditingState: Equatable{
            var point : CGPoint
            var size : Double
            var color : Color
            
            func updateState( state: inout State){
                state.point = self.point
                state.size = self.size
                state.color = self.color
            }
            init(from state: State){
                self.point = state.point
                self.color = state.color
                self.size = state.size
            }
        }
    }
    enum Action : Equatable{
        case point(CGPoint)
        case size(Double)
        case color(Color)
        case tap(UserInterfaceSizeClass?)
        case startPopoverEdit
        case popoverEditing(State.PopoverEditingState?)
        case requestEnvironmentVariables
        case notificationPosizitionChanged
    }
    func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
        switch action{
        case .point(let value):
            state.point = value
            return EffectTask(value: .notificationPosizitionChanged)
        case .size(let value):
            state.size = value
            return .none
        case .color(let value):
            state.color = value
            return .none
        case .startPopoverEdit:
            state.popoverEditingState = State.PopoverEditingState(from: state)
            return .none
        case .popoverEditing(let value):
            state.popoverEditingState = value
            if let value = value{
                let positionChanged = (value.point != state.point)
                value.updateState(state: &state)
                if positionChanged{ return EffectTask(value: .notificationPosizitionChanged) }
            }
            return .none
        case .tap(let hClass):
            if let hClass = hClass, hClass == .regular{
                return EffectTask(value: .startPopoverEdit)
            }
            return .none
        case .requestEnvironmentVariables:
            state.environmentVariables = environmentVariables
            //print("requestEnvironmentVariables", environmentVariables)
            return .none
        case .notificationPosizitionChanged:
            return .none
        }
    }
}
