//
//  ThesisAccessibilityHelperApp.swift
//  ThesisAccessibilityHelper
//
//  Created by Dudas Tamas Alex on 2023. 09. 08..
//

import SwiftUI

// TODO: Replace prints with logs

@main
struct ThesisAccessibilityHelperApp: App {
    // MARK: - Properties

    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject private var dataController = CoreDataController()

    var body: some Scene {
        WindowGroup {
            TabHosterView()
                .environment(\.managedObjectContext, dataController.container.viewContext)
        }
    }
}
