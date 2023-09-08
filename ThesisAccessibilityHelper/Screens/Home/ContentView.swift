//
//  ContentView.swift
//  ThesisAccessibilityHelper
//
//  Created by Dudas Tamas Alex on 2023. 09. 08..
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Text(Localized.helloWorld)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environment(\.locale, .init(identifier: Locales.en.rawValue))
    }
}
