//
//  PhotoSelectView.swift
//  KoCo-Talk
//
//  Created by 하연주 on 3/4/25.
//

import SwiftUI
import Photos

// MARK: - Grid 형태로 최신 사진부터 띄워주는 사진 셀렉터

struct PhotoSelectView : View {
    var columnAmount : Int
    var progressYOffset : CGFloat = 0
    @Binding var photoAssets: [PHAsset]
    
    @State private var isLoading : Bool = false
    
    
    private var columns: [GridItem] {
        Array(repeating: GridItem(.flexible()), count: columnAmount)
    }
    
    var body: some View {
        VStack{
            if isLoading {
                ProgressView()
                    .offset(y : progressYOffset)
            } else {
                // 사진 그리드
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 2) {
                        ForEach(photoAssets, id: \.localIdentifier) { asset in
                            //                        Text(asset.localIdentifier)
                            PhotoGridItem(asset: asset)
                                .aspectRatio(1, contentMode: .fill)
                                .clipped()
                        }
                    }
                    .padding(.horizontal, 2)
                }
            }
        }
        .frame(maxWidth : .infinity)
        .onAppear {
            isLoading  = true
            checkPhotoLibraryPermission()
        }
    }
    
    
}


extension PhotoSelectView {
    //사진 접근 권한 확인
    private func checkPhotoLibraryPermission() {
        let status = PHPhotoLibrary.authorizationStatus()
        
        print("status", status.rawValue)
        
        switch status {
        case .authorized, .limited:
            print("authorized, limited")
            DispatchQueue.global().async {
                self.loadPhotos()
            }

        case .notDetermined:
            print("notDetermined")
            PHPhotoLibrary.requestAuthorization { newStatus in
                if newStatus == .authorized || newStatus == .limited {
                    DispatchQueue.global().async{
                        self.loadPhotos()
                    }
                }
            }
        case .denied, .restricted:
            // 권한 거부됨 알림
            break
        @unknown default:
            break
        }
    }
    
    //최신 사진부터 가져오기
    private func loadPhotos() {
        // 최근 사진 순으로 가져오기 위한 옵션 설정
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        fetchOptions.fetchLimit = 20
        
        // 사진 가져오기
        let fetchResult = PHAsset.fetchAssets(with: .image, options: fetchOptions)
        
        var assets: [PHAsset] = []
        fetchResult.enumerateObjects { asset, _, _ in
            assets.append(asset)
        }
        
        DispatchQueue.main.async {
            self.photoAssets = assets
            self.isLoading = false
        }
    }
}

