//
//  StoreInfoRegisterModel.swift
//  KoCo-Talk
//
//  Created by 하연주 on 3/20/25.
//

import Foundation

protocol StoreInfoRegisterModelStateProtocol {
//    var loginSuccess : Bool {get}
}

protocol StoreInfoRegisterModelActionProtocol : AnyObject {
//    func loginCompleted()
}

final class StoreInfoRegisterModel : StoreInfoRegisterModelStateProtocol, ObservableObject{
//    @Published var loginSuccess = false
}

extension StoreInfoRegisterModel : StoreInfoRegisterModelActionProtocol{

}
