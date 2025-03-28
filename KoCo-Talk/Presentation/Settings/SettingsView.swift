//
//  SettingsView.swift
//  KoCo-Talk
//
//  Created by 하연주 on 1/29/25.
//

import SwiftUI

struct SettingsView: View {
    var body: some View {
        List{
            NavigationLink{
                StoreInfoRegisterView.build()
            } label : {
                Text("매장등록")
            }
            
            NavigationLink{
                UserProfileView()
            } label : {
                Text("프로필")
            }
        }
        
    }
}
