//
//  ThesisAccessibilityHelperApp.swift
//  ThesisAccessibilityHelper
//
//  Created by Dudas Tamas Alex on 2023. 09. 08..
//

import SwiftUI

@main
struct ThesisAccessibilityHelperApp: App {
    // MARK: - Properties

    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject var demoModelData = DemoData()

    private let dataController = CoreDataController.shared

    var body: some Scene {
        WindowGroup {
            TabHosterView()
                .environment(\.managedObjectContext, dataController.container.viewContext)
                .environmentObject(demoModelData)
        }
    }
}
