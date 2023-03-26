//
//  ContentView.swift
//  SUIPrefKeysResponderChain
//
//  Created by Gennady Stepanov on 26.03.2023.
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
            .onPreferenceChange(OnTapPreferenceKey.self) { text in
                guard !text.isEmpty else { return }
                
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
    
    @State var tappedButton = false
    
    var body: some View {
        Button("Test me") {
            tappedButton = true
        }.background {
            if tappedButton {
                Color(.clear).preference(
                    key: OnTapPreferenceKey.self,
                    value: "foo"
                )
                .onAppear {
                    tappedButton = false
                }
            } else {
                EmptyView()
            }
        }
    }
}

// MARK: - Preference keys

public  struct OnTapPreferenceKey: PreferenceKey {
    public static var defaultValue: String = ""
    
    public static func reduce(value: inout String, nextValue: () -> String) {
        guard !nextValue().isEmpty else { return }
        
        value = nextValue()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
