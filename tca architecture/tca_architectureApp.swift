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
    
    static let store = Store(initialState: AppFeature.State()) {
        AppFeature()
            ._printChanges()
    }
    var body: some Scene {
        WindowGroup {
            AppView(store: tca_architectureApp.store)
        }
    }
}
