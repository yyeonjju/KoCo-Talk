//
//  PhotoGridItem.swift
//  KoCo-Talk
//
//  Created by 하연주 on 3/4/25.
//

import SwiftUI
import Photos

struct PhotoGridItem: View {
    let asset: PHAsset
    @Binding var seletedPhotos : [String]
    
    @State private var image: UIImage? = nil
    
    var body: some View {
        let isSelected = seletedPhotos.contains(asset.localIdentifier)
        
        ZStack{
            if let image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .overlay{
                        Assets.Colors.black.opacity(isSelected ? 0.4 : 0.0)
                    }
                    .border(isSelected ? Color.yellow : .clear, width: 4)
                    .overlay(alignment: .topTrailing) {
                        
                        if isSelected, let index = seletedPhotos.firstIndex(of: asset.localIdentifier)   {
                            
                                 // 선택된 경우 노란색 원과 숫자 표시
                                 ZStack {
                                     Circle()
                                         .fill(Color.yellow)
                                         .frame(width: 30, height: 30)
                                     
                                     Text("\(index+1)")
                                         .font(.custom("NanumSquareEB", size: 15))
                                         .foregroundColor(.black)
                                 }
                                 .padding(8)
                                 .onTapGesture {
                                     seletedPhotos.remove(at: index)
                                 }
                                
                             } else {
                                 // 선택되지 않은 경우 회색 원 표시
                                 Circle()
                                     .fill(Color.gray.opacity(0.7))
                                     .frame(width: 30, height: 30)
                                     .padding(8)
                                     .onTapGesture {
                                         seletedPhotos.append(asset.localIdentifier)
                                     }
                             }


                    }
            } else {
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .overlay(
                        ProgressView()
                    )

            }
        }
        .onAppear {
            loadImage()
        }


    }
    
    private func loadImage() {
        let manager = PHImageManager.default()
        let option = PHImageRequestOptions()
        option.isSynchronous = false // false로 설정하여 비동기적으로 이미지 로드 (UI 블로킹 방지)
        option.deliveryMode = .opportunistic // .opportunistic: 빠른 저품질 이미지를 먼저 제공하고 나중에 고품질 이미지 제공
        option.resizeMode = .exact // .exact: 요청한 targetSize에 정확히 맞는 이미지 반환
        
        manager.requestImage(
            for: asset,
            targetSize: CGSize(width: 300, height: 300),
            contentMode: .aspectFill,
            options: option
        ) { result, _ in
            if let image = result {
                DispatchQueue.main.async {
                    self.image = image
                }
            }
        }
    }
}
