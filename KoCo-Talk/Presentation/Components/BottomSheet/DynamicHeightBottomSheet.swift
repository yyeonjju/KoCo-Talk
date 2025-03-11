//
//  DynamicHeightBottomSheet.swift
//  KoCo-Talk
//
//  Created by 하연주 on 3/11/25.
//

import SwiftUI

/*
 // 사용 예시
 
 ZStack{
     Button {
         isBottomSheetShown.toggle()
     }label : {
         Text("0000")
     }
     
     if isBottomSheetShown{
         DynamicHeightBottomSheet(maxHeight: 600, minHeight: 50) {
             Text("DynamicHeightBottomSheet")
                 .frame(maxWidth : .infinity, maxHeight: .infinity)
                 .background(.brown)
         }
     }
 }
 */


/*
 
fileprivate enum Constants {
    static let radius: CGFloat = 12
    static let indicatorHeight: CGFloat = 6
    static let indicatorWidth: CGFloat = 60
    static let snapRatio: CGFloat = 0.25
//    static let minHeightRatio: CGFloat = 0.3
    
    // ✨ 중간 높이를 위한 상수 추가
    static let intermediateHeightRatio: CGFloat = 0.4
}

struct DynamicHeightBottomSheet<Content: View>: View {
//    @Binding var isOpen: Bool //isOpen==true 이면 max height, isOpen==false이면 height
    
    let maxHeight: CGFloat
    let minHeight: CGFloat
    let backgroundColor : Color
    let showIndicator : Bool
    let title : String?
    let isIgnoredSafeArea : Bool
    let allowDragGeture : Bool
    let content: Content
    
    // ✨ 현재 바텀 시트의 높이를 추적하는 상태 변수 추가
    @State private var currentHeight: CGFloat = 0
    @GestureState private var translation: CGFloat = 0
    
    
    // ✨ offset 계산 로직 변경 - isOpen이 아닌 현재 높이 기반으로 계산
    private var offset: CGFloat {
        return maxHeight - currentHeight
    }
    
    private var indicator: some View {
        RoundedRectangle(cornerRadius: Constants.radius)
            .fill(Color.secondary)
            .frame(
                width: Constants.indicatorWidth,
                height: Constants.indicatorHeight
            )
            .onTapGesture {
//                self.isOpen.toggle()
                
//                // ✨ 탭 동작 변경 - 상태에 따라 다음 높이로 순환
//                if currentHeight == maxHeight {
//                    currentHeight = minHeight
//                    isOpen = false
//                } else if currentHeight == minHeight {
//                    // 중간 높이가 있다면 중간 높이로, 아니면 최대 높이로
//                    currentHeight = maxHeight
//                    isOpen = true
//                } else {
//                    // 중간 상태에서는 최대 높이로
//                    currentHeight = maxHeight
//                    isOpen = true
//                }
            }
    }
    
    init(
//        isOpen: Binding<Bool>,
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
//        self._isOpen = isOpen
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
//                    let snapDistance = self.maxHeight * Constants.snapRatio
//                    guard abs(value.translation.height) > snapDistance else {
//                        return
//                    }
//                    
//                    self.isOpen = value.translation.height < 0
                    
                    // 현재 높이에 드래그 거리를 더해 새 높이 계산
                    var newHeight = currentHeight - value.translation.height
                    
                    // 최소/최대 범위 제한
                    newHeight = min(max(newHeight, minHeight), maxHeight)
                    
                    // ✨ 손가락을 뗐을 때 가장 가까운 높이에 스냅
                    let intermediateHeight = maxHeight * Constants.intermediateHeightRatio
                    
                    
                    // 각 높이 지점과의 거리 계산
                    let distanceToMin = abs(newHeight - minHeight)
                    let distanceToIntermediate = abs(newHeight - intermediateHeight)
                    let distanceToMax = abs(newHeight - maxHeight)
                    
                    // 가장 가까운 높이로 스냅
                    if distanceToMin <= distanceToIntermediate && distanceToMin <= distanceToMax {
                        newHeight = minHeight
//                        isOpen = false
                    } else if distanceToIntermediate <= distanceToMin && distanceToIntermediate <= distanceToMax {
                        newHeight = intermediateHeight
//                        isOpen = false // 중간 높이는 isOpen = false로 처리
                    } else {
                        newHeight = maxHeight
//                        isOpen = true
                    }
                    
                    currentHeight = newHeight
                    
                    
                    
                }
                ,including: self.allowDragGeture ? .all : .subviews //subviews : Enable all gestures in the subview hierarchy but disable the added gesture.
            )
        }
        .onAppear {
            // ✨ 초기 높이 설정
            currentHeight = maxHeight*Constants.intermediateHeightRatio
        }
        .edgesIgnoringSafeArea(offset == 0 ? .bottom : []) // offset==0 일 때, 즉, maxheight에 있을 때는 bottom safeArea 무시하도록
//        .edgesIgnoringSafeArea(isIgnoredSafeArea ? .all : .horizontal)
    }
    
}

*/
