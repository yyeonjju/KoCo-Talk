//
//  StoreInfoView.swift
//  KoCo-Talk
//
//  Created by 하연주 on 3/11/25.
//

import SwiftUI

struct StoreInfoView: View {
    @Binding var isExpanded : Bool
    var tappedPostData : PostContentData
    var chatWithStoreButtonTapped : (() -> Void)

    @State private var headerViewHeight: CGFloat = 0
    
    var body: some View {
        GeometryReader{ geometry in
            let screenWidth = geometry.size.width
            
            //TODO: isExpanded == true 일 경우에만 스크롤 동작하도록
            //https://phillip5094.tistory.com/143
            ScrollView{
                VStack(spacing : 0){
                    if isExpanded{
                        
                        //TODO: isExpanded == true 될 때마다 다시 그려지면서 로드되기 때문에 캐싱되는 이미지 관리 구조체로 바꿔주기?
                        //아니면 그냥 if isExpanded 조건부 제외하고 frame으로 조절하면 재로드 방지?
                        //.framd(height : isExpanded ? screenWidth*0.8 : 0)
                        BaisicAsyncImage(url: tappedPostData.storeData?.storeImages.first ?? "-", width: screenWidth, height: screenWidth*0.8)
                    }
                    
                    StoreInfoHeaderView(
                        isExpanded : isExpanded,
                        //                    screenWidth : screenWidth,
                        
                        imageUrl: tappedPostData.storeData?.storeImages.first ?? "-",
                        title: tappedPostData.title,
                        subtitle: tappedPostData.storeData?.address ?? "-"
                    )
                    .padding(.horizontal, isExpanded ? 40 : 20)
                    .padding(.top, isExpanded ? 0 : 16)
                    .offset(y:isExpanded ? -36 : 0)
                    
                    StoreInfoTypeIconsView()
                        .padding(.top, isExpanded ? 0 : 20)
                    
                    StoreInfoButtonsView(
                        isExpanded : $isExpanded,
                        chatWithStoreButtonTapped : chatWithStoreButtonTapped
                    )
                        .padding(.top, 20)
                        .padding(.horizontal, isExpanded ? 50 : 30)
                    
                    if isExpanded{
                        StoreDetailInformantionlView(data : tappedPostData)
                            .padding(.top, 30)
                            .padding(.horizontal, 28)
                            .frame(maxWidth : .infinity)
                        
                        
                    }
                }
            }
            
        }
    }
}
