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
                    let _ = print("🚨🚨🚨🚨chat🚨🚨🚨🚨", chat)
                    VStack{
                        if chat.files.isEmpty {
                            //텍스트
                            textContentView(text: chat.content)
                        }else {
                            //파일(사진)
                            filesContentView(files: chat.files)
                        }
                        
//                        filesContentView(files:["", "", "", "", "", "", "", "", "", ""])
                    }
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

extension ChattingRoomRowView {
    func textContentView(text : String) -> some View {
        Text(text)
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
    
    func filesContentView(files : [String]) -> some View {
        let rowAmount : Int = files.count/3 //몫
        let remainderAmount : Int = files.count%3 //나머지
        
        let singlePhotoWidth : CGFloat = 150
        
        return VStack(spacing: 2){
 
            if files.count == 1 {
                singleImageView(urlString : files.first ?? "", width: singlePhotoWidth, imageUrl: files[0])
                
            } else if files.count == 2 {
                twoItemsInRow(isSquare : true, urls: Array(files[0...1]))
                
            } else if files.count == 4 {
                twoItemsInRow(isSquare : true, urls: Array(files[0...1]))
                twoItemsInRow(isSquare : true, urls: Array(files[2...3]))
                
            }else if remainderAmount == 0 {
                ForEach(0..<rowAmount){ el in
                    threeItemsInRow(urls: Array(files[el*3..<(el+1)*3]))
                }
                
            } else if remainderAmount == 1 {
                //3개씩하고 나머지 1개 (X)
                //3개씩 하고 나머지 4개를 2개씩 (O)
                ForEach(0..<rowAmount-1){ el in
                    threeItemsInRow(urls: Array(files[el*3..<(el+1)*3]))
                }
                twoItemsInRow(urls: Array(files[files.count-4...files.count-3]))
                twoItemsInRow(urls: Array(files[files.count-2...files.count-1]))
                
            } else if remainderAmount == 2 {
                ForEach(0..<rowAmount){ el in
                    threeItemsInRow(urls: Array(files[el*3..<(el+1)*3]))
                }
                twoItemsInRow(urls: Array(files[files.count-2...files.count-1]))
            }
            
        }
        .clipShape(
            RoundedRectangle(cornerRadius: 12)
        )
    }
    
    func twoItemsInRow(isSquare : Bool? = false, width : CGFloat? = 240, urls : [String]) -> some View {
        HStack(spacing: 2){
            ForEach(urls, id : \.self){ url in
                singleImageView(urlString : url, width: width!/2, height: isSquare == true ? width!/2 : width!/3, imageUrl: "")
            }
        }
    }
    func threeItemsInRow(width : CGFloat? = 240, urls : [String]) -> some View {
        HStack(spacing: 2){
            ForEach(urls, id : \.self){ url in
                singleImageView(urlString : url, width: width!/3, imageUrl : "")
                
            }
        }
    }
    
    func singleImageView(urlString : String, width : CGFloat, height : CGFloat? = nil , imageUrl : String) -> some View {
        
        HeaderAsyncImage(url: urlString, width: width, height: height ?? width)
//            .frame(width: width, height: height ?? width)
            .background(Assets.Colors.gray1)
            .cornerRadius(4)
    }
}
