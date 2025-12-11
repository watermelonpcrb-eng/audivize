//
//  audivApp.swift
//  audiv
//
//  Created by SZ on 12/8/25.
//

import SwiftUI

@main
struct audivApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject var orientationManager = OrientationManager()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(orientationManager)
            
        }
    }
}
