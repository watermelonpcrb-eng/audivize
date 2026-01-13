//
//  ContentView.swift
//  audi
//
//  Created by Sebastian Zimmerman on 12/11/25.
//

import SwiftUI

struct ContentView: View {
    @State var menuOpened = false
    @State var selectedDestination: MenuDestination = .home
    @StateObject private var camera = CameraModel()
    @StateObject var orientationManager = OrientationManager()
    var body: some View {
        ZStack {
            // Display the selected view
            switch selectedDestination {
            case .home:
                HomeView()
            case .settings:
                SettingsView()
            case .profile:
                ProfileView()
            case .camera:
                CameraView()
            }
            
            // Menu button overlay
            VStack {
                HStack {
                    Button(action: {
                        self.menuOpened.toggle()
                    }) {
                        Image(systemName: "line.3.horizontal")
                            .font(.system(size: 24))
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.black.opacity(0.6))
                            .clipShape(Circle())
                    }
                    .padding()
                    Spacer()
                }
                .padding(.top, 45)
                .modifier(LandscapeViewModifier(orientationManager: orientationManager))
                Spacer()
            }
            
            // Side menu
            SidePanelView(
                width: 200,
                menuOpened: menuOpened,
                toggleMenu: toggleMenu,
                selectedDestination: $selectedDestination
            )
        }
        .environmentObject(orientationManager)
        .edgesIgnoringSafeArea(.all)
    }
    
    func toggleMenu() {
        menuOpened.toggle()
    }
}

#Preview {
    ContentView()
}
