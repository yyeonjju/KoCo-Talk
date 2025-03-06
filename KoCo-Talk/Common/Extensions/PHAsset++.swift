//
//  PHAsset++.swift
//  KoCo-Talk
//
//  Created by 하연주 on 3/6/25.
//

import UIKit
import Photos

extension PHAsset {
    func convertPHAssetToUIImage(completion : @escaping ((UIImage) -> Void)) {
        let manager = PHImageManager.default()
        let option = PHImageRequestOptions()
        option.isSynchronous = false // false로 설정하여 비동기적으로 이미지 로드 (UI 블로킹 방지)
        option.deliveryMode = .opportunistic // .opportunistic: 빠른 저품질 이미지를 먼저 제공하고 나중에 고품질 이미지 제공
        option.resizeMode = .exact // .exact: 요청한 targetSize에 정확히 맞는 이미지 반환
        
        manager.requestImage(
            for: self,
            targetSize: CGSize(width: 300, height: 300),
            contentMode: .aspectFill,
            options: option
        ) { result, _ in
            if let image = result {
                completion(image)
            }
        }
    }
}
