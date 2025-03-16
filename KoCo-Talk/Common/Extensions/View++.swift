//
//  View++.swift
//  KoCo-Talk
//
//  Created by 하연주 on 3/3/25.
//

import SwiftUI

/*
 extension View {
     func asKeyboardAdaptive(keyboardHeight : Binding<CGFloat>) -> some View {
         ModifiedContent(content: self, modifier: KeyboardAdaptive(keyboardHeight : keyboardHeight))
     }
 }
 */

extension View {
    //shape
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
           clipShape( RoundedCorner(radius: radius, corners: corners) )
       }
    
    
    //keyboard
    func dismissKeyboardOnTap() -> some View {
        self.modifier(DismissableKeyboard())
    }
}


// MARK: - 하위뷰 높이를 측정하여 상위뷰에서 알기 위함
/*
 extension View {
     func readHeight(onChange: @escaping (CGFloat) -> Void) -> some View {
         background(
             GeometryReader { geometryProxy in
                 Color.clear
                     .preference(key: HeightPreferenceKey.self, value: geometryProxy.size.height)
             }
         )
         .onPreferenceChange(HeightPreferenceKey.self, perform: onChange)
     }
 }

 // 높이 정보를 위한 PreferenceKey 정의
 struct HeightPreferenceKey: PreferenceKey {
     static var defaultValue: CGFloat = 0
     
     static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
         value = nextValue()
     }
 }
 */

