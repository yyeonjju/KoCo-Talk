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
    @Binding var seletedPhotos : [SelectedPhoto]
    
    @State private var image: UIImage? = nil
    
    var body: some View {
        let isSelected = seletedPhotos.map{$0.id}.contains(asset.localIdentifier)
        
        ZStack{
            if let image {
                Image(uiImage: image)
                    .resizable()
//                    .scaledToFill()
//                    .scaledToFit()
//                    .aspectRatio(contentMode: .fill)
                    .overlay{
                        Assets.Colors.black.opacity(isSelected ? 0.4 : 0.0)
                    }
                    .border(isSelected ? Color.yellow : .clear, width: 4)
                    .overlay(alignment: .topTrailing) {
                        
                        if isSelected, let index = seletedPhotos.firstIndex(where:{$0.id == asset.localIdentifier})   {
                            
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
                                         seletedPhotos.append(SelectedPhoto(id: asset.localIdentifier, image: image))
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
            asset.convertPHAssetToUIImage{ uiimage in
                DispatchQueue.main.async {
                    self.image = uiimage
                }
            }
        }


    }
}
