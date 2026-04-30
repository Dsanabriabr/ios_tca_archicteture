//
//  NumberFactClient.swift
//  tca architecture
//
//  Created by Daniel Sanabria on 24/04/26.
//
import ComposableArchitecture
import Foundation

struct NumberFactClient {
    var fact: (Int) async throws -> String
}

extension NumberFactClient: DependencyKey {
    static let liveValue = Self(
        fact: { number in
            let (data, _) = try await URLSession.shared.data(from: URL(string: "http://number-trivia.com/\(number)")!)
            return String(decoding: data, as:UTF8.self)
        }
    )
}

extension DependencyValues {
    var numberFactClient: NumberFactClient {
        get { self[NumberFactClient.self]}
        set { self[NumberFactClient.self] = newValue}
    }
}
