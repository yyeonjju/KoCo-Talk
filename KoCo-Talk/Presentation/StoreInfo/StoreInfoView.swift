//
//  StoreInfoView.swift
//  KoCo-Talk
//
//  Created by 하연주 on 3/11/25.
//

import SwiftUI

struct StoreInfoView: View {
    @Binding var isExpanded : Bool
    
    let imageUrl = "https://cdn.eyesmag.com/content/uploads/sliderImages/2022/03/07/diptyque-flagship-store-in-korea-01-b9978b8e-e2f8-42ce-9378-cceda0af3f59.jpg"
//    "http://imgnews.naver.net/image/5575/2022/03/23/0000273480_001_20220323142010478.jpg"
    
    @State private var headerViewHeight: CGFloat = 0
    
    var body: some View {
        GeometryReader{ geometry in
            let screenWidth = geometry.size.width
            
            VStack(spacing : 0){
                if isExpanded{
                    BaisicAsyncImage(url: imageUrl, width: screenWidth, height: screenWidth*0.8)
                }
                
                StoreInfoHeaderView(
                    isExpanded : isExpanded,
                    screenWidth : screenWidth,
                    
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

            }
        }


    }
}
