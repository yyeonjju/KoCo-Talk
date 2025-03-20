//
//  EmailLoginModel.swift
//  KoCo-Talk
//
//  Created by 하연주 on 3/20/25.
//

import Foundation

protocol EmailLoginModelStateProtocol {
    var loginSuccess : Bool {get}
}

protocol EmailLoginModelActionProtocol : AnyObject {
    func loginCompleted()
}

final class EmailLoginModel : EmailLoginModelStateProtocol, ObservableObject{
    @Published var loginSuccess = false
}

extension EmailLoginModel : EmailLoginModelActionProtocol{
    func loginCompleted() {
        loginSuccess = true
    }
}
