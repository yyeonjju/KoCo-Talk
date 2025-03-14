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
    
    let imageUrl = "https://cdn.eyesmag.com/content/uploads/sliderImages/2022/03/07/diptyque-flagship-store-in-korea-01-b9978b8e-e2f8-42ce-9378-cceda0af3f59.jpg"
    //    "http://imgnews.naver.net/image/5575/2022/03/23/0000273480_001_20220323142010478.jpg"
    
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
                        BaisicAsyncImage(url: imageUrl, width: screenWidth, height: screenWidth*0.8)
                    }
                    
                    StoreInfoHeaderView(
                        isExpanded : isExpanded,
                        //                    screenWidth : screenWidth,
                        
                        imageUrl: imageUrl,
                        title: "화장품 매장 화장품 매장 화장품 매장",
                        subtitle: "매장 주소오 매장 주소오 매장 주소오 "
                    )
                    .padding(.horizontal, isExpanded ? 40 : 20)
                    .padding(.top, isExpanded ? 0 : 16)
                    .offset(y:isExpanded ? -36 : 0)
                    
                    StoreInfoTypeIconsView()
                        .padding(.top, isExpanded ? 0 : 20)
                    
                    StoreInfoButtonsView(isExpanded : $isExpanded)
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
