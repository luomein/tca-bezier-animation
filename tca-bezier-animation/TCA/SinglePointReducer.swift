//
//  SinglePointFeature.swift
//  labPlayground
//
//  Created by MEI YIN LO on 2022/12/5.
//

import Foundation
import ComposableArchitecture

struct SinglePointReducer: ReducerProtocol {
    enum Action : Equatable{
        case movePoint(CGPoint)
    }
    func reduce(into state: inout IdentifiedCGPointArray, action: Action) -> EffectTask<Action> {
        switch action{
        case .movePoint(let pt):
            //state.ptArray[state.ptArray.count-1] = pt
            state.lastPoint = pt
            return .none
        }
    }
}
