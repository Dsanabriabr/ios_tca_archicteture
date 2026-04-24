//
//  AppFeatureTests.swift
//  tca architecture
//
//  Created by Daniel Sanabria on 24/04/26.
//

import ComposableArchitecture
import Testing

@testable import tca_architecture

@MainActor
struct AppFeatureTests {
    @Test func incrementInFirstTab() async throws {
        let store = TestStore(initialState: AppFeature.State()) {
            AppFeature()
        }
        await store.send(\.tab1.incrementButtonTapped) {
            $0.tab1.count = 1
        }
    }
}
