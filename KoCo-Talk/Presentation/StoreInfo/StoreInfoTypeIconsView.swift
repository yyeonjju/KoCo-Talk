//
//  StoreInfoTypeIconsView.swift
//  KoCo-Talk
//
//  Created by 하연주 on 3/12/25.
//

import SwiftUI

struct StoreInfoTypeIconsView : View {
    
//    @Binding var selectedType
    
    struct StoreInfoType : Identifiable {
        let id = UUID()
        let icon : Image
        let iconColor : Color
    }
    
    let icons = [
        StoreInfoType(icon: Assets.SystemImages.calendarBadgeClock, iconColor: Assets.Colors.pointGreen1),
        StoreInfoType(icon: Assets.SystemImages.personWave, iconColor: Assets.Colors.pointGreen1),
        StoreInfoType(icon: Assets.SystemImages.giftcard, iconColor: Assets.Colors.pointGreen1),
        StoreInfoType(icon: Assets.SystemImages.handThumbsup, iconColor: Assets.Colors.pointGreen1),
    ]
    
    var body: some View {
        HStack(spacing : 20){
            ForEach(icons) {icon in
                IconCircleBackgroudView(
                    background: Assets.Colors.white,
                    iconColor: icon.iconColor,
                    width: 44,
                    image: icon.icon
                )
                .shadow(color: Assets.Colors.black.opacity(0.2), radius: 6, x: 2, y: 2) // radius : 그림자 흐림정도
//                .frame(maxWidth : .infinity)
//                .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
            }
            
        }
    }
}

