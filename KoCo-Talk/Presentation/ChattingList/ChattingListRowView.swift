//
//  ChattingListRowView.swift
//  KoCo-Talk
//
//  Created by 하연주 on 1/29/25.
//

import SwiftUI

struct ChattingListRowView  : View {
    var body: some View {
        HStack {
            VStack {
                
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
                    Text("상대방 이름")
                        .font(.custom("NanumSquareEB", size: 13))
                        .foregroundStyle(Assets.Colors.gray1)
                    
                    Spacer()
                    
                    Text("오전 11:10")
                        .font(.custom("NanumSquareB", size: 11))
                        .foregroundStyle(Assets.Colors.gray1)
                }
                .padding(.bottom,4)

                Text("최근 톡 내용입니다. 하하하하하하 이런건 어때 이런 톡내용은 어디까지 해야 줄이 넘어갈까. 하하하하하하 이런건 어때 이런 톡내용은 어디까지 해야 줄이 넘어갈까. ")
                    .multilineTextAlignment(.leading)
                    .lineLimit(2)
                    .font(.custom("NanumSquareB", size: 11))
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
