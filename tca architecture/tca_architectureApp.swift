//
//  tca_architectureApp.swift
//  tca architecture
//
//  Created by Daniel Sanabria on 20/04/26.
//

import SwiftUI
import ComposableArchitecture

@main
struct tca_architectureApp: App {
    
    static let store = Store(initialState: CounterFeature.State()) {
        CounterFeature()
            ._printChanges()
    }
    var body: some Scene {
        WindowGroup {
            CounterView(store: tca_architectureApp.store)
        }
    }
}
