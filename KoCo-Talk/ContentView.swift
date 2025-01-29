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
        NavigationStack{
            TabView(selection: $selectedTab) {
                MapView()
                    .tabItem {
                        Assets.SystemImage.mapFill
                        Text("Map")
                    }
                    .tag(0)
                
                ChattingListView()
                    .tabItem {
                        Assets.SystemImage.messageFill
                        Text("Chat")
                    }
                    .tag(1)
                
                SettingsView()
                    .tabItem {
                        Assets.SystemImage.gearshapeFill
                        Text("Settings")
                    }
                    .tag(2)
    //                .badge(10)
            }
            .tint(.pointGreen1)
            .font(.headline)
        }

    }
}

#Preview {
    ContentView()
}
