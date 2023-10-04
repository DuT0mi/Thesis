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
    @StateObject private var dataController: CoreDataController = CoreDataController()

    var body: some Scene {
        WindowGroup {
            TabHosterView()
                .environment(\.managedObjectContext, dataController.container.viewContext)
        }
    }
}
