//
//  tca_architectureTests.swift
//  tca architectureTests
//
//  Created by Daniel Sanabria on 24/04/26.
//

import ComposableArchitecture
import Testing

@testable import tca_architecture

@MainActor
struct tca_architectureTests {

    @Test func basics() async throws {
        let store = TestStore(initialState: CounterFeature.State()) {
            CounterFeature()
        }
        await store.send(.incrementButtonTapped){
            $0.count = 1
        }
        await store.send(.decrementButtonTapped){
            $0.count = 0
        }
    }
    
    @Test func timer() async throws {
        let clock = TestClock()
        let store = TestStore(initialState: CounterFeature.State()) {
            CounterFeature()
        } withDependencies: {
            $0.continuousClock = clock
        }
        
        await store.send(.toggleTimerButtonTapped) {
            $0.isTimerRunning = true
        }
        await clock.advance(by: .seconds(1))
        await store.receive(\.timerTick) {
            $0.count = 1
        }
        await store.send(.toggleTimerButtonTapped) {
            $0.isTimerRunning = false
        }
    }

}

