//
//  ChattingRoomView.swift
//  KoCo-Talk
//
//  Created by 하연주 on 1/28/25.
//

import SwiftUI
import PhotosUI

struct ChattingRoomView: View {
    let roomId : String
    
    @StateObject var container : Container<ChattingRoomIntentProtocol, ChattingRoomModelStateProtocol>
    private var state : ChattingRoomModelStateProtocol {container.model}
    private var intent : ChattingRoomIntentProtocol {container.intent}
    
    @UserDefaultsWrapper(key : .portraitKeyboardHeight, defaultValue: 0.0) var portraitKeyboardHeight : CGFloat
    @UserDefaultsWrapper(key : .landscapeKeyboardHeight, defaultValue: 0.0) var landscapeKeyboardHeight : CGFloat
    @Orientation var orientation
    
    @FocusState private var textFieldFocused: Bool
    @State private var inputText = ""
    @State private var showTabBar : Bool = false
    @State private var moreOptionsButtonTapped = false {
        didSet{
            if !moreOptionsButtonTapped {
                albumButtonTapped = false
            }
        }
    }
    @State private var albumButtonTapped = false
    
    @State private var isPhotoPickerPresented = false
//    @State private var selectedPhotos: [UIImage] = []
    @State private var photoAssets: [PHAsset] = []
    @State private var seletedPhotos : [SelectedPhoto] = []

    
    var body: some View {
        VStack(spacing : 0){
            chatsScrollView
                .background(Assets.Colors.white)
                .onTapGesture {
                    textFieldFocused = false
                    withAnimation{
                        moreOptionsButtonTapped = false
                    }
                }
            Spacer()
            
            //            Text("\(orientation.rawValue)")
            textInputView
                .background(Assets.Colors.pointGreen3)
            
            ZStack{
                moreOptionsView
                    .frame(height:  moreOptionsButtonTapped ? returnMoreOptionsViewHeight() : 0 )
                    .frame(maxWidth : .infinity)
                    .opacity(moreOptionsButtonTapped ? 1 : 0)
                
                if moreOptionsButtonTapped&&albumButtonTapped{
                    photoSelectView
                        .frame(height:  moreOptionsButtonTapped&&albumButtonTapped ? returnMoreOptionsViewHeight() : 0 )
                }

                
            }
        }
        
        .background(Assets.Colors.pointGreen3)
        .onAppear{
            intent.fetchChatRoomContents(roomId: roomId, cursorDate: "")
        }
        //채팅방 들어왔을 때는 탭바 보이지 않고, .onDisappear 시점에는 (이전 페이지로 돌아갈 떄) 다시 탭바 뜰 수 있도록
        .toolbar(showTabBar ? .visible : .hidden, for: .tabBar)
        .onDisappear{
            showTabBar = true
            
            intent.stopDMReceive()
        }
    }
    
    func returnMoreOptionsViewHeight() -> CGFloat {
        let height : CGFloat
        
        //가로, 세로 방향에 따라 추가 옵션 뷰의 높이 설정
        if orientation.isPortrait {
            height = portraitKeyboardHeight > 0 ? portraitKeyboardHeight : 300
        }else {
            height = landscapeKeyboardHeight > 0 ? landscapeKeyboardHeight : 200
        }

        return height
    }
}


extension ChattingRoomView {
    static func build(roomId : String) -> ChattingRoomView{
        let model = ChattingRoomModel()
        let intent = ChattingRoomIntent(model: model) // model의 action 프로토콜 부분 전달
        let container = Container(
            intent: intent as ChattingRoomIntentProtocol,
            model: model as ChattingRoomModelStateProtocol,
            modelChangePublisher: model.objectWillChange
        )
        
        return ChattingRoomView(roomId: roomId, container: container)
    }
}


extension ChattingRoomView {
    var chatsScrollView : some View {
        ScrollViewReader { proxy in
            ScrollView {
                LazyVStack{
                    ForEach(state.chatRoomRows, id : \.chats) { row in
                        ChattingRoomRowView(row: row)
                            .id(row.chats.last?.chatId)
                    }
                }
            }
            .onChange(of: state.chatRoomRows) { _ in
                print("🌸 scroll to bottom 🌸")
                if let lastRow = state.chatRoomRows.last, let lastChatId = lastRow.chats.last?.chatId{
                    proxy.scrollTo(lastChatId, anchor: .bottom)
                }
            }
        }
    }
    var textInputView : some View {
        HStack(alignment : .center) {
            Button {
                withAnimation{
                    moreOptionsButtonTapped.toggle()
                    textFieldFocused = !moreOptionsButtonTapped

                }
            } label : {
                Assets.SystemImages.plus
                    .font(.system(size: 14, weight: .regular))
                    .foregroundStyle(Assets.Colors.gray1)
                    .padding(8)
                    .background(Assets.Colors.gray5)
                    .clipShape(Circle())
                    .rotationEffect(.degrees(moreOptionsButtonTapped ? 45: 0))
                
            }
            
            if albumButtonTapped {
                Text("앨범")
                    .font(.custom("NanumSquareEB", size: 14))
                    .frame(maxWidth : .infinity)
                
            } else {
                TextField(
                    "메시지 입력",
                    text: $inputText,
                    axis: .vertical
                )
                .font(.system(size: 14, weight: .regular))
                .padding(10)
                .frame(maxWidth : .infinity)
                .background(Assets.Colors.gray5)
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .focused($textFieldFocused)
                .lineLimit(6)
                .onTapGesture {
                    if moreOptionsButtonTapped {
                        moreOptionsButtonTapped.toggle()
                    }
                }
            }
            
            Button {
                if albumButtonTapped{
                    /*
                     let datas : [Data] = seletedPhotos.map {
                     var uiimage : UIImage = UIImage()
                     $0.convertPHAssetToUIImage{image in
                     uiimage = image
                     }
                     return uiimage.jpegData(compressionQuality: 1.0)
                     }.compactMap{$0}
                     
                     intent.uploadFiles(roomId : roomId, fileDatas: datas)
                     */
                    
                    let datas : [Data] = seletedPhotos.map {
                        $0.image.jpegData(compressionQuality: 1.0)
                    }.compactMap{$0}
                    
                    intent.uploadFiles(roomId : roomId, fileDatas: datas)
                }else {
                    intent.submitMessage(roomId: roomId, text: inputText, files : [])
                    inputText = ""
                }

            } label: {
                Assets.SystemImages.arrowUp
                    .font(.system(size: 14, weight: .regular))
                    .foregroundStyle(Assets.Colors.gray1)
                    .padding(8)
                    .background(Assets.Colors.pointGreen2)
                    .clipShape(Circle())
            }

        }
        .padding(6)
    }
    
    var moreOptionsView : some View {
        //TODO: Grid 형태로 바꾸기
        VStack{
            Button{
                withAnimation{
                    albumButtonTapped.toggle()
                }
            } label : {
                Assets.SystemImages.photo
                    .imageScale(.large)
                    .foregroundStyle(Assets.Colors.pointGreen1)
                    .frame(width: 60, height: 60)
                    .background(Assets.Colors.white)
                    .clipShape(Circle())
                
            }
        }
    }
    
    var photoSelectView : some View {
        //moreOptionsButtonTapped&&albumButtonTapped 일 때
        BottomSheetView(
            isOpen: $isPhotoPickerPresented,
            maxHeight: (UIScreen.main.bounds.height*0.8),
            backgroundColor : Assets.Colors.white,
            showIndicator: true,
            minHeight : returnMoreOptionsViewHeight()
        ) {
            
            //TODO: maxHeight이 아닐 때는 scroll 하단 끝까지 안보이기 떄문에 예외처리 필요
            
            PhotoSelectView(
                columnAmount : orientation.isPortrait ? 3 : 5,
                progressYOffset : returnMoreOptionsViewHeight()/2,
                photoAssets: $photoAssets,
                seletedPhotos: $seletedPhotos
            )
        }
    }

}



