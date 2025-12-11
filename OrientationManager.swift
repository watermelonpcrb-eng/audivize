//
//  OrientationManager.swift
//  audiv
//
//  Created by SZ on 12/8/25.
//
import SwiftUI
import UIKit
import Combine


class OrientationManager: ObservableObject {
    @Published var orientationLock: UIInterfaceOrientationMask = .landscape
}

class AppDelegate: UIResponder, UIApplicationDelegate {
    var orientationManager = OrientationManager()
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return orientationManager.orientationLock
    }
}

class LandscapeController<Content: View>: UIHostingController<Content> {
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscape
    }
    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return .landscapeLeft
    }
}
