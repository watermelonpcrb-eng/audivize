//
//  SidePanel.swift
//  audi
//
//  Created by Sebastian Zimmerman on 12/18/25.
//
import SwiftUI


enum MenuDestination {
    case home
    case settings
    case profile
    case camera
}

struct MenuItems: Identifiable {
    var id = UUID()
    var text: String
    var destination: MenuDestination
}
// Menuitem views

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

struct ProfileView: View {
    var body: some View {
        ZStack {
            Color.green.opacity(0.2)
            VStack {
                Image(systemName: "person.circle.fill")
                    .font(.system(size: 60))
                    .foregroundColor(.green)
                Text("Profile")
                    .font(.largeTitle)
                    .bold()
            }
        }
        
        .ignoresSafeArea()
    }
}


struct SidePanelContent: View {
    @Binding var selectedDestination: MenuDestination
    let toggleMenu: () -> Void
    
    let items: [MenuItems] = [
        MenuItems(text: "Home", destination: .home),
        MenuItems(text: "Settings", destination: .settings),
        MenuItems(text: "Profile", destination: .profile),
        MenuItems(text: "Camera", destination: .camera),
    ]
    var body: some View {
        ZStack{
            Color(UIColor(red: 33/255.0, green: 33/255.0, blue: 33/255.0, alpha: 1))
            
            VStack(alignment: .leading, spacing: 0){
                ForEach(items) { item in
                    Button(action: {
                        selectedDestination = item.destination
                        toggleMenu()
                    }) {  
                        HStack {
                            Text(item.text)
                                .bold()
                                .multilineTextAlignment(.leading)
                                .font(.system(size: 22))
                                .foregroundColor(selectedDestination == item.destination ? .blue : .white)
                            Spacer()
                            if selectedDestination == item.destination {
                                Image(systemName: "checkmark")
                                    .foregroundColor(.blue)
                            }
                        }
                        .padding()
                    }  
                    Divider()
                }
                Spacer()
            }
            .padding(.top, 50)
        }
    }
}
    struct SidePanelView: View {
        let width: CGFloat
        let menuOpened: Bool
        let toggleMenu: () -> Void
        @Binding var selectedDestination: MenuDestination
        
        var body: some View {
            ZStack {
                GeometryReader { _ in
                    EmptyView()
                }
                
                .background(.black)
                .opacity(self.menuOpened ? 1 : 0)
                .animation(.easeInOut(duration: 0.25), value: menuOpened)
                .onTapGesture {
                    self.toggleMenu()
                }
                //  MenuContent
                HStack {
                    SidePanelContent(
                        selectedDestination: $selectedDestination,
                        toggleMenu: toggleMenu
                    )
                    .frame(width: width)
                    .offset(x: menuOpened ? 0 : -width)
                    .animation(.default, value: menuOpened)
                    Spacer()
                }
            }
        }
    }

