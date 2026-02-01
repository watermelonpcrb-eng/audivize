//
//  SidePanel.swift
//  audi
//
//  Created by Sebastian Zimmerman on 12/18/25.
//
import SwiftUI

// MARK: - Color Utilities

/// Adds helper methods for extracting RGBA components from a SwiftUI `Color`.
/// Useful for persisting `Color` values (ex: to `UserDefaults`) by storing raw channel values.
extension Color {
    /// Attempts to convert this SwiftUI `Color` to a `UIColor`, then reads its RGBA channels.
    ///
    /// - Returns: A tuple of `(red, green, blue, opacity)` in `Double` range `[0.0, 1.0]`,
    ///            or `nil` if the conversion to RGB components fails.
    func getRGBComponents() -> (red: Double, green: Double, blue: Double, opacity: Double)? {
        let uiColor = UIColor(self)
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        
        if uiColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha) {
            return (Double(red), Double(green), Double(blue), Double(alpha))
        }
        return nil
    }
}

// MARK: - Side Panel Navigation Models

/// Represents the possible destinations the side panel can navigate to.
enum MenuDestination {
    case home
    case settings
    case profile
    case camera
}

/// Represents a single item in the side panel list.
struct MenuItems: Identifiable {
    var id = UUID()
    var text: String
    var destination: MenuDestination
}

// MARK: - Menu Destination Views

/// Placeholder/Home view for the `.home` destination.
struct HomeView: View {
    var body: some View {
        ZStack {
            Color.blue.opacity(0.2)
            VStack {
                Image(systemName: "house.fill")
                    .font(.system(size: 60))
                    .foregroundColor(.blue)
                Text("Home")
                    .font(.largeTitle)
                    .bold()
            }
        }
    }
}

/// Placeholder/Settings view for the `.settings` destination.
struct SettingsView: View {
    var body: some View {
        ZStack {
            Color.gray.opacity(0.2)
            VStack {
                Image(systemName: "gear")
                    .font(.system(size: 60))
                    .foregroundColor(.gray)
                Text("Settings")
                    .font(.largeTitle)
                    .bold()
            }
        }
        .ignoresSafeArea()
    }
}

// MARK: - Chat / Transcription Models

/// Represents a user in the transcription/chat system.
///
/// Notes:
/// - Conforms to `Identifiable` for use in SwiftUI lists.
/// - Conforms to `Equatable` based on `name` + `Color` equality (not `id`).
class User: Identifiable, Equatable {
    let id: UUID
    var name: String
    var Color: Color?
    
    /// Creates a user model with an id, name, and optional color.
    ///
    /// - Parameters:
    ///   - userId: The user UUID.
    ///   - userName: Display name.
    ///   - userColor: Optional display color associated with this user.
    init(fromId userId: UUID, fromName userName: String, fromColor userColor: Color?){
       id = userId
       name = userName
       Color = userColor
    }
    
    /// Equality check used for comparing users.
    /// Currently compares `name` and `Color` only.
    static func == (lhs: User, rhs: User) -> Bool {
        return lhs.name == rhs.name && lhs.Color == rhs.Color
    }
}

/// Represents a single message authored by a user.
struct Message: Identifiable, Equatable {
    let id: UUID = UUID()
    let content: String
    var user: User
}

// MARK: - Global Color Tracking

/// Global storage used to avoid generating duplicate colors.
/// Note: This is currently never appended to inside `colorPicker()`, so uniqueness isn't actually enforced yet.
var colors: [Color] = []

// MARK: - Color Generator

/// Generates random colors (intended for per-user message bubble coloring) and attempts to avoid duplicates.
class colorForText {
    /// Generates a random RGB `Color` with channels in `[0.0, 1.0]`.
    func generateColor() -> Color {
        
        let color = Color(red: Double.random(in: 0.0...1.0), green: Double.random(in: 0.0...1.0), blue: Double.random(in: 0.0...1.0))
        return color
    }
    
    /// Picks a random color, retrying while it is already present in the global `colors` array.
    ///
    /// - Returns: A `Color` that is not currently present in `colors`.
    func colorPicker() -> Color {
        
        var color = generateColor()
        
        while colors.contains(color) {
            color = generateColor()
        }
        return color
    }
    
    
}

// MARK: - Message Bubble View

/// Displays a single message bubble with a header showing the author and a colored message body.
struct MessageBubble: View {
    let message: Message
    var body: some View {
        VStack {
            Spacer()
            Text("From: \(message.user.name)")
                .padding(10)
            Text(message.content)
                .padding(10)
                .foregroundStyle(Color.white)
                .background(message.user.Color ?? Color.blue)
                .cornerRadius(10)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        }
    }
}

// MARK: - UUID Test Data / Helpers

/// Example UUID strings used to create deterministic test users.
let uuid3 = "ABFB77ED-9E4E-45D0-9A61-D4F6E57D6AA0"
let uuid4 = "AFE8D21D-0ED7-4C2B-9DDE-3193BC1B46D3"

/// Minimal wrapper for converting a UUID string into an optional `UUID`.
/// This is used below to build `uuid1` and `uuid2`.
class john {
    private let _uuid1: UUID?
    /// Creates a wrapper and attempts to parse a UUID from `uuidS`.
    ///
    /// - Parameter uuidS: UUID string (ex: "ABFB...").
    init(uuidS: String) {
        self._uuid1 = UUID(uuidString: uuidS)
    }
    /// Returns the parsed UUID if conversion succeeded.
    var uuid1: UUID? {
        return _uuid1
    }
    
    
}

/// Parsed UUIDs from the test UUID strings. Force-unwrapped (crashes if invalid).
var uuid1: UUID = john(uuidS: uuid3).uuid1!
var uuid2: UUID = john(uuidS: uuid4).uuid1!

/// Test users used in the transcription example.
var user1: User = User(fromId: uuid1, fromName: "trey", fromColor: nil)
var user2: User = User(fromId: uuid2, fromName: "greg", fromColor: nil)
 
// MARK: - Test Data + UserDefaults Wiring

/// Test harness that:
/// 1) assigns a random persistent color to each user via `UserDefaults`
/// 2) builds a sample message list (`speech`)
class testSpeech {
    
    /// Color generator used for assigning per-user bubble colors.
    var colorText = colorForText()
    
    /// Adds an entry to `UserDefaults` mapping a user's UUID string to `[r, g, b]`.
    ///
    /// Behavior:
    /// - Generates a random color.
    /// - Converts it to RGB components.
    /// - Stores `[red, green, blue]` under key `userUUID.uuidString` if no value exists yet.
    ///
    /// - Parameter userUUID: The user's UUID used as the `UserDefaults` key.
    func addUserDefaults(userUUID: UUID) -> Void {
        let strUserUUID: String = userUUID.uuidString
        let colorU: Color = colorText.colorPicker()
        if let components = colorU.getRGBComponents() {
            let colors: [Double] = [components.red, components.green, components.blue]
            if UserDefaults.standard.array(forKey: strUserUUID) == nil {
                UserDefaults.standard.set(colors, forKey: strUserUUID)
            }
        }
    }
    
    
    /// Local test users for this harness.
    lazy var arrayOfUsersTest: [User] = [user1, user2]
    
    /// Ensures each user has a stored color in `UserDefaults`, then assigns that color back onto the `User` object.
    ///
    /// Notes:
    /// - Force-casts the array from `UserDefaults` to `[Double]` (will crash if wrong type).
    /// - Prints stored values + UUID for debugging.
    func addUsers() -> Void {
        for user in arrayOfUsersTest {
            addUserDefaults(userUUID: user.id)
            let color: [Double] = UserDefaults.standard.array(forKey: user.id.uuidString) as! [Double]
            user.Color = Color(red: color[0], green: color[1], blue: color[2])
            print(UserDefaults.standard.value(forKey: user.id.uuidString) as! [Double])
            print(user.id)
        }
    }
   
    /// Example transcription/messages used for rendering in `TranscriptionView`.
    lazy var speech: [Message] = [
        Message(content: "dwqdwq", user: user1),
        Message(content: "djwqidjwq", user: user1),
    ]
}

/// Singleton-ish test instance used by `TranscriptionView`.
let testCases = testSpeech()

// MARK: - Transcription UI

/// Renders the `speech` messages from `testCases` in a scrollable view.
struct TranscriptionView: View {
    
    /// Triggers user initialization/assignment of colors (side-effect).
    /// Note: This executes at init-time of the struct, not on a lifecycle event.
    var userCall: Void = testCases.addUsers()
    var body: some View {
        ZStack {
            VStack {
                ScrollView {
                    ForEach(testCases.speech) { statement in
                        HStack {
                            Spacer()
                            MessageBubble(message: statement)
                        }
                    }
                    Spacer()
                }
            }
            .padding(.top, 100)
        }
        .ignoresSafeArea()
    }
}


// MARK: - Side Panel Content

/// Displays the selectable menu items and updates `selectedDestination`.
//struct SidePanelContent: View {
//    @Binding var selectedDestination: MenuDestination
//    let toggleMenu: () -> Void
    
    /// Side panel menu items.
//    let items: [MenuItems] = [
//        MenuItems(text: "Home", destination: .home),
//        MenuItems(text: "Settings", destination: .settings),
//        MenuItems(text: "Profile", destination: .profile),
//        MenuItems(text: "Camera", destination: .camera),
//    ]
//    var body: some View {
//        ZStack{
//            Color(UIColor(red: 33/255.0, green: 33/255.0, blue: 33/255.0, alpha: 1))
//            
//            VStack(alignment: .leading, spacing: 0){
//                ForEach(items) { item in
//                    Button(action: {
//                        selectedDestination = item.destination
//                        toggleMenu()
//                    }) {
//                        HStack {
//                            Text(item.text)
//                                .bold()
//                                .multilineTextAlignment(.leading)
//                                .font(.system(size: 22))
//                                .foregroundColor(selectedDestination == item.destination ? .blue : .white)
//                            Spacer()
//                            if selectedDestination == item.destination {
//                                Image(systemName: "checkmark")
//                                    .foregroundColor(.blue)
//                            }
//                        }
//                        .padding()
//                    }
//                    Divider()
//                }
//                Spacer()
//            }
//            .padding(.top, 100)
//        }
//    }
//}

