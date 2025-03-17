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
    
    init(icon: Image, title: StoreInfoContentTitle, type: StoreInfoContentType, textData: String   = "-", storeInfoMetadata : [StoreInfoMetaData] = [StoreInfoMetaData(imageUrl: "-", title: "제품 이름", description: "제품 설명부분 제품 설명부분 제품 설명부분 제품 설명부분 제품 설명부분 제품 설명부분")]) {
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
    let description : String
}

struct StoreDetailInformantionlView : View {
    var data : PostContentData
    private var infoContents : [StoreInfoContent] = []
    
    init(data: PostContentData) {
        self.data = data
        
        guard let storeData = data.storeData else{
            self.infoContents = []
            return
        }
        
        let recommendedProductsMetadata = storeData.recommendProducts.map{
            StoreInfoMetaData(imageUrl: $0.imageUrl ?? "-", title: $0.title ?? "-", description: $0.description ?? "-")
        }
        let bestSellingProductsMetadata = storeData.bestSellingProducts.map{
            StoreInfoMetaData(imageUrl: $0.imageUrl ?? "-", title: $0.title ?? "-", description: $0.description ?? "-")
        }
        let productStockMetadata = storeData.productStock.map{
            StoreInfoMetaData(imageUrl: $0.imageUrl ?? "-", title: $0.title ?? "-", description: $0.description ?? "-")
        }
        
        
        self.infoContents = [
            StoreInfoContent(icon: Assets.SystemImages.clockFill, title: .openingHours, type: .textOnly, textData : storeData.operatingTime),
            StoreInfoContent(icon: Assets.SystemImages.phoneFill, title: .phoneNumber, type: .textOnly, textData : storeData.phone),
            StoreInfoContent(icon: Assets.SystemImages.personWave2Fill, title: .availableLanguage, type: .textOnly, textData : storeData.availableLanguages),
            
            StoreInfoContent(icon: Assets.SystemImages.giftcardFill, title: .recommendationProduct, type: .photoTitleSubtitle, storeInfoMetadata : recommendedProductsMetadata),
            StoreInfoContent(icon: Assets.SystemImages.handThumbsupFill, title: .poplarProduct, type: .photoTitleSubtitle, storeInfoMetadata : bestSellingProductsMetadata),
            StoreInfoContent(icon: Assets.SystemImages.shippingboxFill, title: .productStock, type: .photoTitleSubtitle, storeInfoMetadata : productStockMetadata),
        ]
    }
    
    
    var body: some View {
        VStack(alignment: .leading, spacing : 20){
            ForEach(infoContents){ content in
                switch content.type {
                case .textOnly:
                    textOnlyStoreInfo(content: content)
                        .padding(.horizontal, 28)
                case .photoTitleSubtitle:
                    photoTitleSubtitle(content: content)
                }
            }
        }
        .padding(.bottom, 300)
    }
}



extension StoreDetailInformantionlView {
    private func textOnlyStoreInfo(content : StoreInfoContent) -> some View {
        HStack{
            content.icon
                .imageScale(.small)
                .foregroundStyle(Assets.Colors.gray3)
            Text(content.title.rawValue)
                .foregroundStyle(Assets.Colors.gray1)
                .customFont(fontName: .NanumSquareB, size: 13)
            Text(content.textData)
                .customFont(fontName: .NanumSquareR, size: 12)
            Spacer()
        }
    }
    private func photoTitleSubtitle(content : StoreInfoContent) -> some View {
        VStack(alignment : .leading){
            HStack{
                content.icon
                    .imageScale(.small)
                    .foregroundStyle(Assets.Colors.gray3)
                Text(content.title.rawValue)
                    .foregroundStyle(Assets.Colors.gray1)
                    .customFont(fontName: .NanumSquareB, size: 13)
            }
            .padding(.leading, 28)

            ScrollView(.horizontal, showsIndicators: false){
                HStack(alignment : .top){
                    ForEach (content.storeInfoMetadata){ (data : StoreInfoMetaData) in
                        VStack(alignment : .leading, spacing: 4){
                            HeaderAsyncImage(
                                url: data.imageUrl,
                                width: 140,
                                height: 120,
                                radius: 6
                            )
                            Text(data.title)
                                .customFont(fontName: .NanumSquareB, size: 12)
                                .foregroundStyle(Assets.Colors.gray1)
                                .tracking(1)
                                .lineSpacing(4)
                                .frame(alignment: .leading)
                                .lineLimit(1)
                            Text(data.description)
                                .frame(alignment: .leading)
                                .customFont(fontName: .NanumSquareR, size: 11)
                                .tracking(0.5)
                                .lineSpacing(4)
                                .foregroundStyle(Assets.Colors.gray2)
                                .lineLimit(3)
                            
                        }
                        .frame(width : 140)
                        .padding(.leading, content.storeInfoMetadata.first?.id == data.id ? 28 : 0)
                        .padding(.trailing, content.storeInfoMetadata.last?.id == data.id ? 28 : 0) // 마지막 요소에서만 trailing padding
                        // .padding(.trailing, 12)
                    }
                    
                }
            }
            
            
        }
    }
}
