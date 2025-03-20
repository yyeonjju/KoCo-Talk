//
//  EmailLoginView.swift
//  KoCo-Talk
//
//  Created by 하연주 on 2/2/25.
//

import SwiftUI

struct EmailLoginView: View {    
    @StateObject var container : Container<EmailLoginIntentProtocol, EmailLoginModelStateProtocol>
    private var state : EmailLoginModelStateProtocol {container.model}
    private var intent : EmailLoginIntentProtocol {container.intent}
    
//    @StateObject private var vm = EmailLoginViewModel()
    
//    @State private var email = "testuser@testuser.com"
//    @State private var password = "testuser"
  
    
    //⭐️test
//    @State private var email = "kocoTalk-user1@ kocoTalk.com"
//    @State private var password = "kocoTalk-user1"
//    @State private var email = "kocoTalk1@ kocoTalk.com"
//    @State private var password = "kocoTalk1"
    
    
    //북 37.51823°, 동 127.02331°
    @State private var email = "heidi_1@KoCoTalk.com"
    @State private var password = "heidi_1"
//    @State private var email = "TAMBURINS_1@TAMBURINS.com"
//    @State private var password = "TAMBURINS_1"
//    @State private var email = "DIPTYQUE_1@DIPTYQUE.com"
//    @State private var password = "DIPTYQUE_1"
//    @State private var email = "Aesop_1@Aesop.com"
//    @State private var password = "Aesop_1"
    
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
                intent.login(email: email, password: password)
            } label: {
                Text("로그인하기")
                    .padding()
                    .background(.blue)
                    .foregroundStyle(.white)
            }
        }
        .onChange(of: state.loginSuccess) { loginSuccess in
            if loginSuccess {
                AuthManager.shared.status = .authorized
            }
        }

    }
}

extension EmailLoginView {
    static func build() -> EmailLoginView{
        let model = EmailLoginModel()
        let intent = EmailLoginIntent(model: model) // model의 action 프로토콜 부분 전달
        let container = Container(
            intent: intent as EmailLoginIntentProtocol,
            model: model as EmailLoginModelStateProtocol,
            modelChangePublisher: model.objectWillChange
        )
        
        return EmailLoginView(container: container)
    }
}

