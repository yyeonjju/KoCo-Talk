//
//  IconCircleBackgroudView.swift
//  KoCo-Talk
//
//  Created by 하연주 on 3/11/25.
//

import SwiftUI

struct IconCircleBackgroudView : View {
    var background : Color
    var iconColor : Color
    var width : CGFloat
    var image : Image
    var imageScale : Image.Scale = .medium
    
    
    var body: some View {
        // 오른쪽 전화 버튼
        Circle()
            .fill(background)
            .frame(width: width, height: width)
            .overlay(
                image
                    .foregroundColor(iconColor)
                    .imageScale(imageScale)
            )
    }
}
