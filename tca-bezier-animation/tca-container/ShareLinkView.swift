//
//  ShareLinkView.swift
//  tca-bezier-animation
//
//  Created by MEI YIN LO on 2022/12/30.
//

import SwiftUI
import ComposableArchitecture

struct ShareLinkView: View {
    let store: StoreOf<ContainerReducer>
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in

            let title = Bundle.main.infoDictionary?["CFBundleDisplayName"] as? String ?? ""
            let image = Image(uiImage: viewStore.snapShot ?? UIImage() )
            ShareLink(item: image ,
                      preview: SharePreview(title,image: image))
            {
                Image(systemName: "square.and.arrow.up")
            }


        }
    }

}

struct ShareLinkView_Previews: PreviewProvider {
    static var previews: some View {
        ShareLinkView(store: Store(initialState: .init() , reducer: ContainerReducer()))
        
    }
}
