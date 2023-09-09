//
//  ContentView.swift
//  ThesisAccessibilityHelper
//
//  Created by Dudas Tamas Alex on 2023. 09. 08..
//

import SwiftUI

struct ContentView: View {

    @State var tester = false
    var body: some View {
        BaseView {
            VStack {
                Text(Localized.helloWorld)
                Button("Show") {
                    tester.toggle()
                }
            }
        }
        .sheet(isPresented: $tester, content: {
            LongLoadingView()
                .sheetStyle(style: .medium, dismissable: true, showIndicator: true)
        })
        .ignoresSafeArea()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environment(\.locale, .init(identifier: Locales.en.rawValue))
    }
}
