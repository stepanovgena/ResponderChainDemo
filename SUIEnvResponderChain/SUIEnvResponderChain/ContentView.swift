//
//  ContentView.swift
//  SUIEnvResponderChain
//
//  Created by Gennady Stepanov on 25.03.2023.
//

import SwiftUI

// MARK: - Hierarchy

struct ContentView: View {
    var body: some View {
        Container()
            .foregroundColor(.yellow)
            .background {
                Color(.yellow)
                    .frame(width: 200, height: 200)
            }
            .environment(\.onTapped) { text in
                print("Tapped on distant child, text: \(text)")
            }
    }
}

struct Container: View {
    
    @State private var isModalPresented = false
    
    var body: some View {
        Child()
            .background {
                Color(.orange)
                    .frame(width: 160, height: 160)
            }
    }
}

struct Child: View {
    @Environment(\.onTapped) var onTapped
    
    var body: some View {
        Button("Test me") {
            onTapped("foo")
        }
    }
}

// MARK: - Responder chain setup

struct ActionEnvironmentKey: EnvironmentKey {
    static var defaultValue: (String) -> Void = { _ in
        assertionFailure("Must set closure to environment key \(Self.self)")
    }
}

extension EnvironmentValues {
    var onTapped: (String) -> Void {
        get { self[ActionEnvironmentKey.self] }
        set { self[ActionEnvironmentKey.self] = newValue }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
