//
//  AppDelegate.swift
//  ThesisAccessibilityHelper
//
//  Created by Dudas Tamas Alex on 2023. 10. 01..
//
import UIKit
import FirebaseCore
import FirebaseAuth
import FirebaseFirestore
import SwiftUI
import Combine

class AppDelegate: NSObject, UIApplicationDelegate {
    // MARK: - Functions
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()

        return true
    }

}
