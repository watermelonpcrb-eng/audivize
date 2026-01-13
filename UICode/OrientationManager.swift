//
//  OrientationManager.swift
//  audi
//
//  Created by Sebastian Zimmerman on 12/11/25.
//

import SwiftUI
import UIKit
import Combine


class OrientationManager: ObservableObject {
    @Published var orientationLock: UIInterfaceOrientationMask = .portrait
    
    func lockOrientation(_ orientation: UIInterfaceOrientationMask, andRotateTo rotateOrientation: UIInterfaceOrientation? = nil) {
        self.orientationLock = orientation
        
        if let rotateOrientation = rotateOrientation {
            UIDevice.current.setValue(rotateOrientation.rawValue, forKey: "orientation")
        }
        
        UINavigationController.attemptRotationToDeviceOrientation()
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
struct LandscapeViewModifier: ViewModifier {
    @ObservedObject var orientationManager: OrientationManager
    
    func body(content: Content) -> some View {
        content
            .onAppear {
                // Lock to landscape and force rotation
                orientationManager.lockOrientation(.landscape, andRotateTo: .landscapeRight)
            }
            .onDisappear {
                // Return to portrait and force rotation
                orientationManager.lockOrientation(.portrait, andRotateTo: .portrait)
            }
    }
}
