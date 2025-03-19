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
        
        static let pointDarkGreen1 = Color("pointDarkGreen1")
        
        static let pointRed = Color("pointRed")
        
        static let black = Color("black")
        static let gray1 = Color("gray1")
        static let gray2 = Color("gray2")
        static let gray3 = Color("gray3")
        static let gray4 = Color("gray4")
        static let gray5 = Color("gray5")
        
        static let chatMessageBackgroundGray = Color("chatMessageBackgroundGray")
        
        static let white = Color("white")
    }
    
    enum SystemImages {
        //가능언어 icon : "person.wave.2", "network", "abc", "speaker", "message"
        static let personWave = Image(systemName: "person.wave.2")
        static let personWave2Fill = Image(systemName: "person.wave.2.fill")
        //추천제품 icon : 화장품 "basket", "giftcard", "heart"
        static let giftcard = Image(systemName: "giftcard")
        static let giftcardFill = Image(systemName: "giftcard.fill")
        //인기상품 icon : "hand.thumbsup"
        static let handThumbsup = Image(systemName: "hand.thumbsup")
        static let handThumbsupFill = Image(systemName: "hand.thumbsup.fill")
        //영업시간 icon : "clock", "calendar.badge.clock"
        static let calendarBadgeClock = Image(systemName: "calendar.badge.clock")
        
        //재고
        static let shippingboxFill = Image(systemName: "shippingbox.fill")
        
        static let listClipboardFill = Image(systemName: "list.clipboard.fill")
        static let phoneFill = Image(systemName: "phone.fill")
        static let photo = Image(systemName: "photo")
        static let mapFill = Image(systemName: "map.fill")
        static let messageFill = Image(systemName: "message.fill")
        static let gearshapeFill = Image(systemName: "gearshape.fill")
        static let plus = Image(systemName: "plus")
        static let arrowUp = Image(systemName: "arrow.up")
        static let arrowClockwise = Image(systemName: "arrow.clockwise")
        static let clockFill = Image(systemName: "clock.fill")
        static let minusCircleFill = Image(systemName : "minus.circle.fill")
        
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



// MARK: - Map Constants
enum MapInfo {
    static let viewName = "kokoTalk-mapview"
    static let viewInfoName = "map"
    
    enum Poi {
        //화장품 매장에 표시에 대한 layer
        static let storeLayerID = "storeLayer"
        static let basicPoiPinStyleID = "basicPoiPinStyle"
        static let tappedPoiPinStyleID = "tappedPoiPinStyle"
        
        //현재 위치 표시에 대한 layer
        static let currentPointlayerID = "currentPointlayer"
        static let currentPointPoiPinStyleID = "currentPointPoiPinStyle"
    }
}
