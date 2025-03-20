//
//  ContentView.swift
//  KoCo-Talk
//
//  Created by 하연주 on 1/28/25.
//

import SwiftUI

//TODO: custom tabbar
//https://velog.io/@0000_0010/SwiftUI-Custom-Tab-Bar


enum AuthStatus {
    case noUser
    case userExist
    
    case authorized
    case notauthorized
}

final class AuthManager : ObservableObject{
    @Published var status : AuthStatus = .notauthorized
    
    static let shared = AuthManager()
    
    private init() {
        print("❤️init userInfo -> ", UserDefaultsManager.userInfo)
        if UserDefaultsManager.userInfo == nil {
            status = .noUser
        } else {
            status = .userExist
        }
    }
}

final class TabBarManager : ObservableObject {
    @Published var selectedTag : TabBarTag = .map
}

enum TabBarTag {
    case map
    case chat
    case settings
}

struct ContentView: View {
    @StateObject var authManager = AuthManager.shared
    @StateObject var tabbarManager = TabBarManager()
    
    @State private var loginViewShown = false
    
    var body: some View {
        if authManager.status == AuthStatus.notauthorized ||
            authManager.status == AuthStatus.noUser {
            
            EmailLoginView()
            
        } else if authManager.status == AuthStatus.authorized ||
                    authManager.status == AuthStatus.userExist {
            
            TabView(selection: $tabbarManager.selectedTag) {
                NavigationView{
                    MapView.build()
                        .environmentObject(tabbarManager)
                }
                .tint(Assets.Colors.black)
                .tabItem {
                    Assets.SystemImages.mapFill
                    Text("Map")
                }
                .tag(TabBarTag.map)
                
                NavigationView{
                    ChattingListView.build()
                        .navigationTitle("채팅")
                }
                .tint(Assets.Colors.black)
                .tabItem {
                    Assets.SystemImages.messageFill
                    Text("Chat")
                }
                .tag(TabBarTag.chat)
                
                NavigationView{
                    SettingsView()
                }
                .tint(Assets.Colors.black)
                .tabItem {
                    Assets.SystemImages.gearshapeFill
                    Text("Settings")
                }
                .tag(TabBarTag.settings)
                //                .badge(10)
            }
            .tint(Assets.Colors.pointGreen1)
            .font(.headline)
            .onAppear {
                UITabBar.appearance().backgroundColor = .white
            }
        }
        
    }
}
