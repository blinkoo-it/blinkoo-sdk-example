//
//  ContentView.swift
//  blinkoo components example
//
//  Created by Davide Quadrelli on 21/01/25.
//

import SwiftUI
import blinkoo_ios_components

struct ContentView: View {
    let blinkooFeed =
    BlinkooFeedComponent("wh57akzi00zcvcq7274ovr3xmrpvoc55yzev93frezt83v47hv275erfdp0ng8nxjx2q971b85ngrdsotn1blhsyxkpdken0")
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
