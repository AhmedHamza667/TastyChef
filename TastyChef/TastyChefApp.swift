//
//  TastyChefApp.swift
//  TastyChef
//
//  Created by Ahmed Hamza on 3/24/25.
//

import SwiftUI
import Firebase

@main
struct TastyChefApp: App {
    @StateObject private var authStateManager = AuthenticationStateManager.shared
    @UIApplicationDelegateAdaptor(AppDelete.self) var delegate
    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(authStateManager)
        }
    }
}

class AppDelete: NSObject, UIApplicationDelegate{
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        return true
    }
}
