//
//  StoreInfoButtonsView.swift
//  KoCo-Talk
//
//  Created by 하연주 on 3/12/25.
//

import SwiftUI

struct StoreInfoButtonsView : View {
    @Binding var isExpanded : Bool
    
    var body : some View {
        HStack(spacing : 20) {
            if !isExpanded {
                Button {
                    isExpanded = true
                } label : {
                    RoundedConerWithIconAndText(text: "상세 매장 정보", image: Assets.SystemImages.listClipboardFill, imageScale: .small)
                }
            }
            
            Button {
                
            } label : {
                RoundedConerWithIconAndText(text: "매장 실시간 상담", image: Assets.SystemImages.messageFill, imageScale: .small)
                
            }
            
        }
    }
}

struct RoundedConerWithIconAndText : View {
    var text : String
    var image : Image
    var imageScale : Image.Scale
    var withShadow : Bool = true
    
    var body: some View {
        HStack{
            image
                .foregroundStyle(Assets.Colors.pointGreen1)
                .imageScale(imageScale)
            
            Text(text)
                .lineLimit(1)
                .foregroundStyle(Assets.Colors.pointGreen1)
                .customFont(fontName: .NanumSquareB, size: 13)

        }
        .frame(height : 32)
        .frame(maxWidth : .infinity)
        .background(Assets.Colors.white)
        .cornerRadius(8, corners: .allCorners)
        .shadow(color: Assets.Colors.black.opacity(withShadow ? 0.4 : 0), radius: 4, x: 2, y: 2)
    }
}
