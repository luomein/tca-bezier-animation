//
//  ContainerView.swift
//  labPlayground
//
//  Created by MEI YIN LO on 2022/12/3.
//

import SwiftUI
import ComposableArchitecture


struct ContainerView: View{
    let store: StoreOf<ContainerReducer>
    
    var body: some View {
        ContainerLayoutView(store: store, plottingViewBuilder: PlottingView.init, settingViewBuilder: SettingView.init)
            
    }
}

struct ContainerView_Previews: PreviewProvider {
    static var previews: some View {

            ContainerView(store: Store(initialState: .init(), reducer: ContainerReducer()))
                

        
    }
}

