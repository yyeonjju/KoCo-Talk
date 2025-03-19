//
//  ImageLoader.swift
//  KoCo-Talk
//
//  Created by 하연주 on 3/8/25.
//

import UIKit

@MainActor
final class ImageLoader : ObservableObject {
    private var tasks : [Task<Void, Never>] = []
    
    @Published var image : UIImage? = nil
    @Published var isLoading : Bool = false
    @Published var error : FetchError? = nil
    
    
    func loadImage(urlString : String){
        
        let task = Task {
            do {
                let result = try await NetworkManager2.downloadFiles(url: urlString)
                print("💕💕💕 이미지 다운로드 완료!!", result)
                image = UIImage(data: result)
                isLoading = false
             
            } catch let error as FetchError {
                // FetchError 처리
                print("🚨error", error)
                isLoading = false
                self.error = error
            } catch {
                // 에러 처리
                print("🚨error", error)

            }
        }
        
        tasks.append(task)
    }
    
    func cancelTasks() {
        tasks.forEach{$0.cancel()}
        tasks.removeAll()
    }
}


/*
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
*/
