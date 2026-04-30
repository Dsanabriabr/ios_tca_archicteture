//
//  CounterFeature.swift
//  tca architecture
//
//  Created by Daniel Sanabria on 20/04/26.
//

import ComposableArchitecture
import SwiftUI
import Clocks

@Reducer
struct CounterFeature {
    @ObservableState
    struct State: Equatable, Identifiable {
        let id: UUID
        var count = 0
        var fact: String?
        var isLoading = false
        var isTimerRunning = false
    }
    
    enum Action {
        case decrementButtonTapped
        case incrementButtonTapped
        case factButtonTapped
        case factClientResponse(String)
        case toggleTimerButtonTapped
        case timerTick
    }
    
    enum CancelID: Hashable { case timer(UUID) }
    @Dependency(\.continuousClock) var clock
    @Dependency(\.numberFactClient) var numberFactClient
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .decrementButtonTapped:
                state.count -= 1
                state.fact = nil
                return .none
                
            case .incrementButtonTapped:
                state.count += 1
                state.fact = nil
                return .none
                
            case .factButtonTapped:
                state.fact = nil
                state.isLoading = true
                state.isTimerRunning = false

                return .merge(
                        .cancel(id: CancelID.timer(state.id)),
                        .run { [count = state.count] send in
                        try await send(.factClientResponse(self.numberFactClient.fact(count)))
                    })
            case .factClientResponse(let fact):
                state.fact = fact
                state.isLoading = false
                return .none
                
            case .toggleTimerButtonTapped:
                    state.isTimerRunning.toggle()
                if state.isTimerRunning {
                  return .run { send in
                      for await _ in self.clock.timer(interval: .seconds(1)) {
                          await send(.timerTick)
                      }
                  }
                  .cancellable(id: CancelID.timer(state.id))
                } else {
                  return .cancel(id: CancelID.timer(state.id))
                }
            case .timerTick:
                    state.count += 1
                    state.fact = nil
                    return .none
            }
        }
    }
}
    
struct CounterView: View {
        let store: StoreOf<CounterFeature>
        
        var body: some View {
            VStack {
                Text("\(store.count)")
                    .font(.largeTitle)
                    .padding()
                    .background(Color.black.opacity(0.1))
                    .cornerRadius(10)
                HStack {
                    Button("-") {
                        store.send(.decrementButtonTapped)
                    }
                    .font(.largeTitle)
                    .padding()
                    .background(Color.black.opacity(0.1))
                    .cornerRadius(10)
                    
                    Button("+") {
                        store.send(.incrementButtonTapped)
                    }
                    .font(.largeTitle)
                    .padding()
                    .background(Color.black.opacity(0.1))
                    .cornerRadius(10)
                }
                Button(store.isTimerRunning ? "Stop timer" : "Start timer") {
                        store.send(.toggleTimerButtonTapped)
                      }
                      .font(.largeTitle)
                      .padding()
                      .background(Color.black.opacity(0.1))
                      .cornerRadius(10)
                Button("Fact") {
                        store.send(.factButtonTapped)
                      }
                      .font(.largeTitle)
                      .padding()
                      .background(Color.black.opacity(0.1))
                      .cornerRadius(10)
                if store.fact != nil {
                    Text("\(store.fact!)")
                        .font(.largeTitle)
                        .padding()
                        .alignmentGuide(.lastTextBaseline) { d in d[.bottom] }
                }
            }
        }
    }
    
#Preview {
    CounterView(store: Store(initialState: CounterFeature.State(id: UUID())) {
            CounterFeature()
        }
    )
}

