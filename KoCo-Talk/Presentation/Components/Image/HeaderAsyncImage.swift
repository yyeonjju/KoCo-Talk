//
//  HeaderAsyncImage.swift
//  KoCo-Talk
//
//  Created by 하연주 on 3/8/25.
//

import SwiftUI

struct HeaderAsyncImage : View {
    var url : String?
    var width : CGFloat = 80
    var height : CGFloat = 80
    var radius : CGFloat = 4
    
    @StateObject private var imageLoader  = ImageLoader()
    
    var body: some View{
        VStack {
            if let image = imageLoader.image {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                
            } else if imageLoader.isLoading {
                ProgressView() // 로딩 중 표시
                
            } else if imageLoader.error != nil {
                defaultContent // 에러 표시
            }
            else {
                defaultContent // 기본 콘텐츠
            }
        }
        .frame(width: width, height: height)
        .background(Assets.Colors.gray4)
        .cornerRadius(radius)
        .scaledToFit()
        .onAppear {
            imageLoader.isLoading = true
            if let url = url {
                imageLoader.loadImage(urlString: url)
            }
        }
        .onDisappear{
            imageLoader.cancelTasks()
        }
    }
    
    private var defaultContent : some View {
        Color.gray5
            .overlay {
                Assets.SystemImages.photo
                    .foregroundStyle(Assets.Colors.gray3)
            }
    }
}
