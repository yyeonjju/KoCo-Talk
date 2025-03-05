//
//  BottomSheetView.swift
//  KoCo-Talk
//
//  Created by 하연주 on 3/5/25.
//

import Foundation
import SwiftUI

fileprivate enum Constants {
    static let radius: CGFloat = 12
    static let indicatorHeight: CGFloat = 6
    static let indicatorWidth: CGFloat = 60
    static let snapRatio: CGFloat = 0.25
//    static let minHeightRatio: CGFloat = 0.3
}

struct BottomSheetView<Content: View>: View {
    @Binding var isOpen: Bool //isOpen==true 이면 max height, isOpen==false이면 height
    
    let maxHeight: CGFloat
    let minHeight: CGFloat
    let backgroundColor : Color
    let showIndicator : Bool
    let title : String?
    let isIgnoredSafeArea : Bool
    let allowDragGeture : Bool
    let content: Content
    
    @GestureState private var translation: CGFloat = 0
    
    private var offset: CGFloat {
        return isOpen ? 0 : maxHeight - minHeight
    }
    
    private var indicator: some View {
        RoundedRectangle(cornerRadius: Constants.radius)
            .fill(Color.secondary)
            .frame(
                width: Constants.indicatorWidth,
                height: Constants.indicatorHeight
            )
            .onTapGesture {
                self.isOpen.toggle()
            }
    }
    
    init(
        isOpen: Binding<Bool>,
        maxHeight: CGFloat,
        backgroundColor : Color = .white,
        showIndicator : Bool = true,
        title : String? = nil,
        isIgnoredSafeArea : Bool = true,
        allowDragGeture : Bool = true,
        minHeight : CGFloat? = nil,
        minHeightRatio : CGFloat = 0,
        @ViewBuilder content: () -> Content
    ) {
        self.minHeight = minHeight ?? maxHeight * minHeightRatio
        self.maxHeight = maxHeight
        self.backgroundColor = backgroundColor
        self.content = content()
        self.showIndicator = showIndicator
        self.title = title
        self.isIgnoredSafeArea = isIgnoredSafeArea
        self.allowDragGeture = allowDragGeture
        self._isOpen = isOpen
    }
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                if(showIndicator){
                    self.indicator
                        .padding(6)
                }
                if(title != nil){
                    HStack(spacing: 0){
                        Text(title ?? "")
                            .font(.system(size:20, weight:.bold))
                            .padding(20)
                        Spacer()
                    }

                }
                self.content
            }
            .frame(width: geometry.size.width, height: self.maxHeight, alignment: .top)
            .background(backgroundColor)
            .cornerRadius(Constants.radius, corners: .topLeft)
            .cornerRadius(Constants.radius, corners: .topRight)
            .frame(height: geometry.size.height, alignment: .bottom)
            .offset(y: max(self.offset + self.translation, 0))
            .animation(.interactiveSpring())
            .gesture(
                DragGesture().updating(self.$translation) { value, state, _ in
                    state = value.translation.height
                }.onEnded { value in
                    let snapDistance = self.maxHeight * Constants.snapRatio
                    guard abs(value.translation.height) > snapDistance else {
                        return
                    }
                    
                    self.isOpen = value.translation.height < 0
                }
                ,including: self.allowDragGeture ? .all : .subviews //subviews : Enable all gestures in the subview hierarchy but disable the added gesture.
            )
        }
        .edgesIgnoringSafeArea(offset == 0 ? .bottom : .top) // offset==0 일 때, 즉, maxheight에 있을 때는 bottom safeArea 무시하도록
//        .edgesIgnoringSafeArea(isIgnoredSafeArea ? .all : .horizontal)
    }
    
}

