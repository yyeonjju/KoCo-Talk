//
//  ContentView.swift
//  KoCo-Talk
//
//  Created by 하연주 on 1/28/25.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedTab = 1
    
    var body: some View {
        TabView(selection: $selectedTab) {
            NavigationView{
                MapView()
            }
            .tint(Assets.Colors.black)
            .tabItem {
                Assets.SystemImage.mapFill
                Text("Map")
            }
            .tag(0)
            
            NavigationView{
                ChattingListView()
                    .navigationTitle("채팅")
            }
            .tint(Assets.Colors.black)
            .tabItem {
                Assets.SystemImage.messageFill
                Text("Chat")
            }
            .tag(1)
            
            NavigationView{
                SettingsView()
            }
            .tint(Assets.Colors.black)
            .tabItem {
                Assets.SystemImage.gearshapeFill
                Text("Settings")
            }
            .tag(2)
            //                .badge(10)
        }
        .tint(Assets.Colors.pointGreen1)
        .font(.headline)
        
    }
}
