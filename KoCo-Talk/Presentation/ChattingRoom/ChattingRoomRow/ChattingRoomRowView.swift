//
//  ChattingRoomRowView.swift
//  KoCo-Talk
//
//  Created by 하연주 on 1/31/25.
//

import SwiftUI

struct ChattingRoomRowView: View {
    let row : ChatRoomContentRow
    
    var body: some View {
        if row.isDateShown {
            Text(row.createdDate)
                .font(.system(size: 12))
                .foregroundStyle(Assets.Colors.white)
                .padding(.vertical,4)
                .padding(.horizontal,8)
                .background(Assets.Colors.black.opacity(0.3))
                .cornerRadius(16)
                .padding(.vertical)

        }
        
        HStack(alignment : .bottom){
            //채팅 시간
            if row.isMyChat {
                Text(row.createdTime)
                    .font(.system(size: 10))
                    .foregroundStyle(Assets.Colors.gray2)
            }
            
            //상대방 프로필 이미지
            if !row.isMyChat {
                VStack{
                    VStack{
                        
                    }
                    .frame(width: 40, height: 40)
                    .background(Assets.Colors.gray3)
                    .cornerRadius(20)
                }
                .frame(maxHeight : .infinity, alignment: .top)

            }
            
            VStack(alignment : row.isMyChat ? .trailing : .leading){
                ForEach(row.chats, id : \.chatId) { chat in
                    Text(chat.content)
                        .font(.system(size: 13))
                        .padding()
                        .background(
                            row.isMyChat
                            ? Assets.Colors.pointGreen2
                                .clipShape(
                                    RoundedCorner(radius: 18, corners: [.topLeft, .topRight , .bottomLeft])
                                )
                            : Assets.Colors.gray5
                                .clipShape(
                                    RoundedCorner(radius: 18, corners: [.topRight, .bottomLeft, .bottomRight])
                                )
                        )
                    
                }
                
            }
            
            //채팅 시간
            if !row.isMyChat {
                Text(row.createdTime)
                    .font(.system(size: 10))
                    .foregroundStyle(Assets.Colors.gray2)
            }
        }
        .frame(
            maxWidth : .infinity,
            alignment : row.isMyChat ? .trailing : .leading
        )
        .padding(.horizontal, 6)
        .padding(.vertical, 4)
        
    }
}
