//
//  MVIContainer.swift
//  KoCo-Talk
//
//  Created by 하연주 on 1/29/25.
//

import Foundation
import Combine

final class Container<Intent, Model> : ObservableObject {
    let intent : Intent
    let model : Model
    
    var cancellable = Set<AnyCancellable>()
    
    init(intent: Intent, 
         model: Model,
         modelChangePublisher : ObjectWillChangePublisher) {
        self.intent = intent
        self.model = model
        
        //모델이 변경되었을 때 container에서도 객체 변경 알림
        modelChangePublisher
            .receive(on: RunLoop.main) //모델의 변경사항이 메인 스레드에서 실행될 수 있도록
            .sink { _ in
                self.objectWillChange.send()
            }
            .store(in: &cancellable)
    }
    
}
