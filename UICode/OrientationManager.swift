//
//  OrientationManager.swift
//  audi
//
//  Created by Sebastian Zimmerman on 12/11/25.
//

import SwiftUI

class landscapeUIViewController<Content: View>: UIHostingController<Content> {
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        .landscape
    }
    
    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        .landscapeRight
    }
    override var shouldAutorotate: Bool {
        true
    }
    
}

struct LandscapeView<Content: View>: UIViewControllerRepresentable {
    let content: Content
    
    func makeUIViewController(context: Context) -> UIViewController {
        landscapeUIViewController(rootView: content)
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
}
