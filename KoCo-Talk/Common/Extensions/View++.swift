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
}

