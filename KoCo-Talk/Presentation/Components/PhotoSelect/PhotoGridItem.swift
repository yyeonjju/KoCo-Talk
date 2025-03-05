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
    @State private var image: UIImage? = nil
    
    
//    @Binding var selectedItems: [String: Int]  // 선택된 아이템과 순서를 저장하는 딕셔너리
//    let itemId: String  // 고유 식별자 (PHAsset의 localIdentifier 사용)
    
    
    var body: some View {
        let _ = print("🌹🌹PhotoGridItem🌹🌹", asset.localIdentifier)
        ZStack{
            if let image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
//                    .overlay(alignment: .topTrailing) {
//                        if let orderNumber = selectedItems[itemId] {
//                             // 선택된 경우 노란색 원과 숫자 표시
//                             ZStack {
//                                 Circle()
//                                     .fill(Color.yellow)
//                                     .frame(width: 30, height: 30)
//                                 
//                                 Text("\(orderNumber)")
//                                     .font(.system(size: 16, weight: .bold))
//                                     .foregroundColor(.black)
//                             }
//                             .padding(8)
//                            
//                         } else {
//                             // 선택되지 않은 경우 회색 원 표시
//                             Circle()
//                                 .fill(Color.gray.opacity(0.7))
//                                 .frame(width: 30, height: 30)
//                                 .padding(8)
//                         }
//                    }
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
        option.isSynchronous = false
        option.deliveryMode = .opportunistic
        option.resizeMode = .exact
        
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
