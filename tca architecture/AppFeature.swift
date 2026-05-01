//
//  AppFeature.swift
//  tca architecture
//
//  Created by Daniel Sanabria on 24/04/26.
//

import ComposableArchitecture
import SwiftUI

struct AppView: View {
    let store: StoreOf<AppFeature>
    
    var body: some View {
        TabView {
            ForEach(
                store.scope(state: \.counters, action: \.counters)
            ) { itemStore in
                CounterView(store: itemStore).tabItem {
                    Label(
                            "Counter \(itemStore.id.uuidString.prefix(2))",
                            systemImage: "clock"
                        )
                }
            }
        }
    }
}

@Reducer
struct AppFeature {
    @ObservableState
    struct State: Equatable {
        var counters: IdentifiedArrayOf<CounterFeature.State> = [
            .init(id: UUID()),
            .init(id: UUID()),
            .init(id: UUID()),
            .init(id: UUID())
        ]
    }
    enum Action {
        case counters(IdentifiedActionOf<CounterFeature>)
    }
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            .none
        }
        .forEach(\.counters, action: \.counters) {
            CounterFeature()
        }
    }
}
#Preview {
  AppView(
    store: Store(initialState: AppFeature.State()) {
      AppFeature()
    }
  )
}
