//
//  EmailLoginView.swift
//  KoCo-Talk
//
//  Created by 하연주 on 2/2/25.
//

import SwiftUI
import Combine

struct EmailLoginView: View {    
    @StateObject private var vm = EmailLoginViewModel()
    
//    @State private var email = "testuser@testuser.com"
//    @State private var password = "testuser"
  
    
    //⭐️test
//    @State private var email = "kocoTalk-user1@ kocoTalk.com"
//    @State private var password = "kocoTalk-user1"
//    @State private var email = "kocoTalk1@ kocoTalk.com"
//    @State private var password = "kocoTalk1"
    
    
    
    @State private var email = "heidi_1@KoCoTalk.com"
    @State private var password = "heidi_1"
//    @State private var email = "TAMBURINS_1@TAMBURINS.com"
//    @State private var password = "TAMBURINS_1"
    
    var body: some View {
        VStack{
            TextField("이메일", text : $email)
                .padding(10)
                .frame(maxWidth : .infinity)
                .background(.gray)
                .padding(.horizontal, 30)
            
            SecureField("비밀번호", text : $password)
                .padding(10)
                .frame(maxWidth : .infinity)
                .background(.gray)
                .padding(.horizontal, 30)
            
            Button {
                vm.action(action: .login(body: LoginBody(email: email, password: password)))
                
            } label: {
                Text("로그인하기")
                    .padding()
                    .background(.blue)
                    .foregroundStyle(.white)
            }
        }
        .onChange(of: vm.output.loginSuccess) { loginSuccess in
            if loginSuccess {
                AuthManager.shared.status = .authorized
            }
        }

    }
}


class EmailLoginViewModel : ObservableObject {
    @UserDefaultsWrapper(key : .userInfo, defaultValue : nil) var userInfo : LoginResponse?
    var cancellables = Set<AnyCancellable>()
    var input = Input()
    @Published var output = Output()
    
    init() {
        transfer(input: input)
    }
    
    func transfer(input : Input){
        input.login
            .flatMap{ body in
                print("🍀", body)
                return NetworkManager.login(body: body)
            }
            .sink(receiveCompletion: {[weak self] completion in
                guard let self else { return }
                switch completion {
                case .failure(let error):
                    print("⭐️receiveCompletion - failure", error)
                    
                case .finished:
                    break
                }
                
            }, receiveValue: {[weak self]  result in
                guard let self else { return }
                print("❤️ 로그인 했다!, -> ", result.toDomain())
                userInfo = result.toDomain()
                output.loginSuccess = true

            })
            .store(in: &cancellables)
    }
    
    struct Input {
        let login = PassthroughSubject<LoginBody, Never>()
    }
    struct Output {
        var loginSuccess : Bool = false
    }
    
    enum Action {
        case login(body:LoginBody)
    }
    
    func action (action : Action) {
        switch action{
        case .login(let body) :
            input.login.send(body)
        }
    }
}
