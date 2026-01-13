//
//  audiApp.swift
//  audi
//
//  Created by Sebastian Zimmerman on 12/11/25.
//


import SwiftUI
import UIKit

class AppDelegate: NSObject, UIApplicationDelegate {
    static var orientationManager = OrientationManager()
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return AppDelegate.orientationManager.orientationLock
    }
}

@main
struct audivApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(AppDelegate.orientationManager)
                .ignoresSafeArea()
        }
    }
}
