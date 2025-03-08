//
//  ImageLoader.swift
//  KoCo-Talk
//
//  Created by 하연주 on 3/8/25.
//

import UIKit
import Combine

final class ImageLoader : ObservableObject {
    private var cancellables = Set<AnyCancellable>()
    
    @Published var image : UIImage? = nil
    @Published var isLoading : Bool = false
    @Published var error : FetchError? = nil
    
    
    func loadImage(urlString : String){
        NetworkManager.downloadFiles(url: urlString)
            .sink(receiveCompletion: {[weak self] completion in
                guard let self else { return }
                switch completion {
                case .failure(let error):
                    print("⭐️receiveCompletion - failure", error)
                    isLoading = false
                    self.error = error
                case .finished:
                    break
                }
                
            }, receiveValue: {[weak self]  imageData in
                guard let self else { return }
                print("💕💕💕 이미지 다운로드 완료!!", imageData)
                image = UIImage(data: imageData)
                isLoading = false
                
            })
            .store(in: &cancellables)
    }
}
