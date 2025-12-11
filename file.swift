// 1. Create a helper to hold orientation state
class OrientationManager: ObservableObject {
    @Published var orientationLock: UIInterfaceOrientationMask = .portrait // Default
}

// 2. In your AppDelegate/SceneDelegate, manage the lock
class AppDelegate: UIResponder, UIApplicationDelegate {
    var orientationManager = OrientationManager()

    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return orientationManager.orientationLock
    }
}

// 3. Create a UIHostingController subclass for landscape
class LandscapeHostingController<Content: View>: UIHostingController<Content> {
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscape
    }
    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return .landscapeLeft // Or .landscapeRight
    }
}

// 4. Create a View Modifier to use the controller
struct LandscapeViewModifier<Content: View>: ViewModifier {
    let content: Content
    let orientationManager: OrientationManager

    init(content: Content, orientationManager: OrientationManager) {
        self.content = content
        self.orientationManager = orientationManager
    }

    func body(content: Content) -> some View {
        content
            .onAppear {
                // When this view appears, allow landscape for it
                orientationManager.orientationLock = .landscape
            }
            .onDisappear {
                // When it disappears, revert to default (e.g., portrait)
                orientationManager.orientationLock = .portrait
            }
    }
}

// 5. In your Main App or a parent view, set up the SceneDelegate/AppDelegate
@main
struct YourApp: App {
    @StateObject var orientationManager = OrientationManager()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(orientationManager) // Pass the manager
                // Use a conditional to wrap the specific view in the landscape controller
                .background(
                    LandscapeHostingController(rootView: EmptyView()) // Placeholder
                        .environmentObject(orientationManager) // Pass down
                )
        }
    }
}

// 6. Apply the modifier to your specific landscape view
struct LandscapeSpecificView: View {
    @EnvironmentObject var orientationManager: OrientationManager

    var body: some View {
        // Your actual landscape-optimized UI
        Text("I am in Landscape!")
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.blue)
            .modifier(LandscapeViewModifier(content: self, orientationManager: orientationManager))
    }
}







