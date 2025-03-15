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
                StoreInfoRegisterView()
            } label : {
                Text("매장등록")
            }
        }
        
    }
}
