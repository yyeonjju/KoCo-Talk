//
//  KeyboardModifier.swift
//  KoCo-Talk
//
//  Created by 하연주 on 3/3/25.
//

import SwiftUI
import Combine
/*
 // 키보드 관리를 위한 ViewModifier
 struct KeyboardAdaptive: ViewModifier {
     @Binding var keyboardHeight: CGFloat
     
     func body(content: Content) -> some View {
         content
             .onReceive(Publishers.keyboardHeight) {
                 self.keyboardHeight = $0
                 print("keyboardHeight 바뀜", keyboardHeight)
             }
     }
 }
 */

/*
 // 키보드 높이를 관찰하는 Publisher
 extension Publishers {
     static var keyboardHeight: AnyPublisher<CGFloat, Never> {
         
         @Orientation var orientation
         
         let willShow = NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)
             .map { notification -> CGFloat in
                 print("🌹키보드 보임 - isPortrait - 🌹", orientation.isPortrait)
                 return (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect)?.height ?? 0
             }
         
         let willHide = NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)
             .map { _ in
                 print("🌹🌹키보드 숨김 - isPortrait - 🌹🌹", orientation.isPortrait)
                 return CGFloat(0)
             }
         
         return MergeMany(willShow, willHide)
             .eraseToAnyPublisher()
     }
 }
 */


