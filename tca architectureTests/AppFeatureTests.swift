//
//  AppFeatureTests.swift
//  tca architecture
//
//  Created by Daniel Sanabria on 24/04/26.
//

import ComposableArchitecture
import Foundation
import Testing

@testable import tca_architecture

@MainActor
struct AppFeatureTests {
    @Test func incrementInEachTab() async throws {
        let featureArray: IdentifiedArrayOf<CounterFeature.State> = [
            .init(id: UUID()),
            .init(id: UUID()),
            .init(id: UUID()),
            .init(id: UUID())
        ]
        
        let store = TestStore(initialState: AppFeature.State(
            counters: featureArray
        )) {
            AppFeature()
        }
        for counter in featureArray {
            await store.send(.counters(.element(id: counter.id, action: .incrementButtonTapped))
            ) {
                $0.counters[id: counter.id]!.count = 1
            }
        }
    }
}
