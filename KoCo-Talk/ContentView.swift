//
//  ContentView.swift
//  KoCo-Talk
//
//  Created by 하연주 on 1/28/25.
//

import SwiftUI

enum AuthStatus {
    case noUser
    case userExist
    
    case authorized
    case notauthorized
}

final class AuthManager : ObservableObject{
    @UserDefaultsWrapper(key : .userInfo, defaultValue : nil) var userInfo : LoginResponse?
    
    @Published var status : AuthStatus = .notauthorized
    
    static let shared = AuthManager()
    
    private init() {
        print("❤️init userInfo -> ", userInfo)
        if userInfo == nil {
            status = .noUser
        } else {
            status = .userExist
        }
    }
}

struct ContentView: View {
    @StateObject var authManager = AuthManager.shared
    
    @State private var selectedTab = 1
    @State private var loginViewShown = false
    @UserDefaultsWrapper(key : .userInfo, defaultValue : nil) var userInfo : LoginResponse?
    
    var body: some View {
        if authManager.status == AuthStatus.notauthorized ||
            authManager.status == AuthStatus.noUser {
            
            EmailLoginView()
            
        } else if authManager.status == AuthStatus.authorized ||
                    authManager.status == AuthStatus.userExist {
            
            TabView(selection: $selectedTab) {
                NavigationView{
                    MapView.build()
                }
                .tint(Assets.Colors.black)
                .tabItem {
                    Assets.SystemImages.mapFill
                    Text("Map")
                }
                .tag(0)
                
                NavigationView{
                    ChattingListView.build()
                        .navigationTitle("채팅")
                }
                .tint(Assets.Colors.black)
                .tabItem {
                    Assets.SystemImages.messageFill
                    Text("Chat")
                }
                .tag(1)
                
                NavigationView{
                    SettingsView()
                }
                .tint(Assets.Colors.black)
                .tabItem {
                    Assets.SystemImages.gearshapeFill
                    Text("Settings")
                }
                .tag(2)
                //                .badge(10)
            }
            .tint(Assets.Colors.pointGreen1)
            .font(.headline)
        }
        
    }
}
