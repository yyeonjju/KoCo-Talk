//
//  StoreInfoHeaderView.swift
//  KoCo-Talk
//
//  Created by 하연주 on 3/11/25.
//

import SwiftUI

struct StoreInfoHeaderView: View {
    var isExpanded : Bool
//    var screenWidth : CGFloat
    var imageUrl : String
    var title: String
    var subtitle: String
    

    
    var body: some View {
//        let imageWidth : CGFloat = screenWidth/7
//        let iconWidth : CGFloat = screenWidth/9
        
        HStack {
            BaisicAsyncImage(url: imageUrl, width: 52, height: 52)
//            .frame(width: imageWidth, height: imageWidth)
            .background(Assets.Colors.pointGreen1)
            .clipShape(Circle())
            
            // 중앙 텍스트
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .lineLimit(1)
                    .customFont(fontName: .NanumSquareB, size: 14)
                    .foregroundColor(Assets.Colors.gray1)
                
                Text(subtitle)
                    .lineLimit(2)
                    .customFont(fontName: .NanumSquareR, size: 12)
                    .foregroundColor(Assets.Colors.gray3)
            }
            .padding(.leading, 8)
            
            Spacer()
            
            // 오른쪽 전화 버튼
            IconCircleBackgroudView(
                background: Assets.Colors.gray4,
                iconColor: Assets.Colors.white,
                width: 36,
                image: Assets.SystemImages.phoneFill,
                imageScale: .small
            )
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 10)
        .background(
            RoundedRectangle(cornerRadius: isExpanded ? 60 : 20)
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
        )
    }
}


