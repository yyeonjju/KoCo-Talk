//
//  CustomFontModifier.swift
//  KoCo-Talk
//
//  Created by 하연주 on 3/12/25.
//

import SwiftUI

enum FontName : String {
    case NanumSquareL
    case NanumSquareR
    case NanumSquareB
    case NanumSquareEB
}

struct CustomFontModifier : ViewModifier {
    var fontName : FontName
    var size : CGFloat
    
    func body (content : Content) -> some View {
        content
            .font(.custom(fontName.rawValue, size: size))
    }
}

extension View {
    func customFont(fontName : FontName, size : CGFloat = 16) -> some View {
        modifier(CustomFontModifier(fontName: fontName, size: size))
    }
}
