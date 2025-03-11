//
//  Namespace.swift
//  KoCo-Talk
//
//  Created by 하연주 on 1/29/25.
//

import SwiftUI

enum Assets {
    enum Colors {
        static let pointGreen1 = Color("pointGreen1")
        static let pointGreen2 = Color("pointGreen2")
        static let pointGreen3 = Color("pointGreen3")
        
        static let black = Color("black")
        static let gray1 = Color("gray1")
        static let gray2 = Color("gray2")
        static let gray3 = Color("gray3")
        static let gray4 = Color("gray4")
        static let gray5 = Color("gray5")
        static let white = Color("white")
    }
    
    enum SystemImages {
        static let photo = Image(systemName: "photo")
        static let mapFill = Image(systemName: "map.fill")
        static let messageFill = Image(systemName: "message.fill")
        static let gearshapeFill = Image(systemName: "gearshape.fill")
        static let plus = Image(systemName: "plus")
        static let arrowUp = Image(systemName: "arrow.up")
    }
    
    enum Images {
        static let defaultProfile = Image("defaultProfile")
    }
}

enum ScreenSize {
    static var width : CGFloat {
        guard let window = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return UIScreen.main.bounds.width}
        return window.screen.bounds.width
    }
    
    static var height : CGFloat {
        guard let window = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return UIScreen.main.bounds.height}
        return window.screen.bounds.height
    }
    
    static var statusBarHeight : CGFloat {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first else{
            return 0.0
        }
        return window.safeAreaInsets.top
    }
    
}
