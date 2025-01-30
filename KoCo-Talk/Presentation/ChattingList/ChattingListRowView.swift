//
//  ChattingListRowView.swift
//  KoCo-Talk
//
//  Created by 하연주 on 1/29/25.
//

import SwiftUI

struct ChattingListRowView  : View {
    let chatRoom : ChatRoom
    
    var body: some View {
        HStack {
            VStack {
                if let imageString = chatRoom.opponentProfileImage {
                    
                }else {
                    Assets.Images.defaultProfile
                        .resizable()
                }
            }
            .frame(width: 48, height: 48)
            .background(Assets.Colors.gray3)
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Assets.Colors.pointGreen1, lineWidth: 2)
            )
            
            VStack(alignment : .leading){
                HStack {
                    Text(chatRoom.opponentNickname)
                        .font(.custom("NanumSquareEB", size: 14))
                        .foregroundStyle(Assets.Colors.gray1)
                    
                    Spacer()
                    
                    Text(chatRoom.updatedAt)
                        .font(.custom("NanumSquareB", size: 11))
                        .foregroundStyle(Assets.Colors.gray1)
                }
                .padding(.bottom,4)

                Text(chatRoom.lastChatText)
                    .multilineTextAlignment(.leading)
                    .lineLimit(2)
                    .font(.custom("NanumSquareB", size: 12))
                    .foregroundStyle(Assets.Colors.gray2)
                    
                
            }
            
        }
        .padding(.horizontal,8)
        .padding(.vertical,16)
        .background(Assets.Colors.gray5)
        .cornerRadius(10)
        .shadow(color: Assets.Colors.black.opacity(0.2), radius: 6, x: 2, y: 2) // radius : 그림자 흐림정도
    }
}
