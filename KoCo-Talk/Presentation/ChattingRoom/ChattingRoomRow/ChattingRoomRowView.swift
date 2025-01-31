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
            if row.isMyChat {
                Text(row.createdTime)
                    .font(.system(size: 10))
                    .foregroundStyle(.gray)
            }
            
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
                            ? Color.green
                                .clipShape(
                                    RoundedCorner(radius: 18, corners: [.topLeft, .topRight , .bottomLeft])
                                )
                            : Color.yellow
                                .clipShape(
                                    RoundedCorner(radius: 18, corners: [.topRight, .bottomLeft, .bottomRight])
                                )
                        )
                    
                }
                
            }
            
            if !row.isMyChat {
                Text(row.createdTime)
                    .font(.system(size: 10))
                    .foregroundStyle(.gray)
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
