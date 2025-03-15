//
//  StoreDetailInformantionlView.swift
//  KoCo-Talk
//
//  Created by 하연주 on 3/13/25.
//

import SwiftUI


enum StoreInfoContentType {
    case textOnly
    case photoTitleSubtitle
}
enum StoreInfoContentTitle : String{
    case openingHours = "영업 시간"
    case phoneNumber = "전화번호"
    case availableLanguage = "응대 가능 언어"
    
    case recommendationProduct = "추천 제품"
    case poplarProduct = "인기 제품"
    case productStock = "주요 제품 재고"
}

struct StoreInfoContent : Identifiable {
    let id  = UUID()
    var icon : Image
    var title : StoreInfoContentTitle
    
    var type : StoreInfoContentType
    var textData : String
    var storeInfoMetadata : [StoreInfoMetaData]
    
    init(icon: Image, title: StoreInfoContentTitle, type: StoreInfoContentType, textData: String   = "-", storeInfoMetadata : [StoreInfoMetaData] = [StoreInfoMetaData(imageUrl: "-", title: "제품 이름", subTitle: "제품 설명부분 제품 설명부분 제품 설명부분 제품 설명부분 제품 설명부분 제품 설명부분")]) {
        self.icon = icon
        self.title = title
        self.type = type
        self.textData = textData
        self.storeInfoMetadata = storeInfoMetadata
    }
}

struct StoreInfoMetaData : Identifiable {
    let id = UUID()
    let imageUrl : String
    let title : String
    let subTitle : String
}

struct StoreDetailInformantionlView : View {
    var data : PostContentData
    private var infoContents : [StoreInfoContent] = []
    
    init(data: PostContentData) {
        self.data = data
        self.infoContents = [
            StoreInfoContent(icon: Assets.SystemImages.clockFill, title: .openingHours, type: .textOnly, textData : "10:00 - 19:00"),
            StoreInfoContent(icon: Assets.SystemImages.phoneFill, title: .phoneNumber, type: .textOnly, textData : data.storeData?.phone ?? "" ),
            StoreInfoContent(icon: Assets.SystemImages.personWave2Fill, title: .availableLanguage, type: .textOnly, textData : "한국어 영어 중국어 일본어"),
            
            
            //TODO: 아래에 metadata 정의해서 넣어야함
            StoreInfoContent(icon: Assets.SystemImages.giftcardFill, title: .recommendationProduct, type: .photoTitleSubtitle),
            StoreInfoContent(icon: Assets.SystemImages.handThumbsupFill, title: .poplarProduct, type: .photoTitleSubtitle),
            StoreInfoContent(icon: Assets.SystemImages.shippingboxFill, title: .productStock, type: .photoTitleSubtitle),
        ]
    }
    
    
    var body: some View {
        VStack(alignment: .leading, spacing : 24){
            
            ForEach(infoContents){ content in
                
                switch content.type {
                    
                case .textOnly:
                    HStack{
                        content.icon
                            .imageScale(.small)
                            .foregroundStyle(Assets.Colors.gray3)
                        Text(content.title.rawValue)
                            .foregroundStyle(Assets.Colors.gray1)
                            .customFont(fontName: .NanumSquareEB, size: 14)
                        Text(content.textData)
                            .customFont(fontName: .NanumSquareR, size: 14)
                        Spacer()
                    }
                    
                case .photoTitleSubtitle:
                    VStack(alignment : .leading){
                        HStack{
                            content.icon
                                .imageScale(.small)
                                .foregroundStyle(Assets.Colors.gray3)
                            Text(content.title.rawValue)
                                .foregroundStyle(Assets.Colors.gray1)
                                .customFont(fontName: .NanumSquareEB, size: 14)
                        }
                        
                        ScrollView(.horizontal){
                            HStack{
                                ForEach (content.storeInfoMetadata){ data in
                                    VStack(alignment : .leading, spacing: 4){
                                        HeaderAsyncImage(url: data.imageUrl, width: 100, height: 60)
                                        Text(data.title)
                                            .customFont(fontName: .NanumSquareB, size: 12)
                                            .foregroundStyle(Assets.Colors.gray1)
                                            .frame(alignment: .leading)
                                        Text(data.subTitle)
                                            .frame(alignment: .leading)
                                            .customFont(fontName: .NanumSquareR, size: 11)
                                            .foregroundStyle(Assets.Colors.gray1)
                                            .lineLimit(3)
                                            
                                    }
                                    .frame(width : 110)
//                                    .padding(.trailing, 12)
                                }
                                
                            }
                        }
                        
                        
                    }
                }
                
            }
            
            
        }
        .padding(.bottom, 300)
    }
}
