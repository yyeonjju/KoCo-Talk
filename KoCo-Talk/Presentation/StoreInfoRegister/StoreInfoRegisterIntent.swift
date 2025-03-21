//
//  StoreInfoRegisterIntent.swift
//  KoCo-Talk
//
//  Created by 하연주 on 3/20/25.
//

import Foundation
import SwiftUI

@MainActor
protocol StoreInfoRegisterIntentProtocol {
    func post(postBody : StoreInfoPostBody)
    func uploadFiles(imageData : Data, bindingImageString : Binding<String>)
    func cancelTasks()
}

final class StoreInfoRegisterIntent : StoreInfoRegisterIntentProtocol {
    @Injected private var defaultStoreInfoRegisterRepository : StoreInfoRegisterRepository
    
    private weak var model :  StoreInfoRegisterModelActionProtocol?
    private var tasks : [Task<Void, Never>] = []
    
    init(model:  StoreInfoRegisterModelActionProtocol) {
        self.model = model
    }
    
    func post(postBody : StoreInfoPostBody) {
        print("❤️❤️최종 post body❤️❤️", postBody)
         
        let task = Task {
            do {
                let postId = try await defaultStoreInfoRegisterRepository.post(postBody: postBody)
                print("❤️Post 완료❤️", postId)
            } catch {
                // 에러 처리
                print("🚨error", error)
            }
        }
        
        tasks.append(task)
    }
    
    func uploadFiles(imageData : Data, bindingImageString : Binding<String>) {
        
        let task = Task {
            do {
                let imageUrl = try await defaultStoreInfoRegisterRepository.uploadFiles(imageData: imageData)
                
                print("⭐️⭐️⭐️⭐️⭐️imageUrl", imageUrl)
                bindingImageString.wrappedValue = imageUrl
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
