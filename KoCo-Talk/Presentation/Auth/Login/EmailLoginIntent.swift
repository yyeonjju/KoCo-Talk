//
//  EmailLoginIntent.swift
//  KoCo-Talk
//
//  Created by 하연주 on 3/20/25.
//

import Foundation

@MainActor
protocol EmailLoginIntentProtocol {
    func login(email : String, password : String)
}

final class EmailLoginIntent : EmailLoginIntentProtocol{
    @Injected private var defaultAuthRepository : AuthRepository
    
    private weak var model :  EmailLoginModelActionProtocol?
    private var tasks : [Task<Void, Never>] = []
    
    init(model:  EmailLoginModelActionProtocol) {
        self.model = model
    }
    
    func login(email : String, password : String){
        
        
        let task = Task {[weak self] in
            guard let self, let model else { return }
            
            do {
                let userInfo = try await defaultAuthRepository.login(email: email, password: password)

                model.loginCompleted()
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
