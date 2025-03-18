//
//  UserProfileView.swift
//  KoCo-Talk
//
//  Created by 하연주 on 3/17/25.
//

import SwiftUI
import Combine

enum Operation {
    case create
    case edit
    
    case read
}

struct UserProfileView : View {
    @StateObject private var vm = UserProfileViewModel()
    @UserDefaultsWrapper(key : .userInfo, defaultValue : nil) var userInfo : LoginResponse?
    
    @State private var operation : Operation = .edit
    @State private var profileImage : UIImage? = nil
    @State private var isShowingImagePicker = false

    var body : some View {
        let _ = print("🧡userInfo?.profileImage🧡", userInfo?.profileImage)
        VStack{
            HeaderAsyncImage(url: userInfo?.profileImage, width: 100, height: 100, radius: 5)
            
            
            if operation == .edit {
                // 이미지 선택 영역
                Button(action: {

                    self.isShowingImagePicker = true
                }) {
                    if let uiImage = profileImage {
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 100, height: 100)
                            .clipShape(RoundedRectangle(cornerRadius: 5))
                    } else {

                        VStack {
                            Image(systemName: "plus")
                                .font(.title)
                                .foregroundColor(.gray)
                            
                            Text("사진 등록")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                        .frame(width: 100, height: 100)
                        .background(Color.gray.opacity(0.1))
                        .overlay(
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(Assets.Colors.gray3.opacity(0.5), style: StrokeStyle(lineWidth: 1, dash: [5]))
                        )
                    }
                }
                
                Button {
                    if let profileImage{
                        let imageData = profileImage.jpegData(compressionQuality: 0.5) ?? Data()
                        print("🌸이미지 데이터", imageData)
                        vm.updateProfile(imageData: imageData)
                        
                    }
                    
                } label : {
                    Text("저장")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Assets.Colors.pointGreen1)
                        .cornerRadius(10)
                }
                .padding(.horizontal)
            }
            

        }
        .sheet(isPresented: $isShowingImagePicker) {
            ImagePicker(selectedImage: Binding<UIImage?>(
                get: { profileImage },
                set: { profileImage = $0 }
            ))
        }
    }
    

}

class UserProfileViewModel : ObservableObject {
    private var cancellables = Set<AnyCancellable>()
    @UserDefaultsWrapper(key : .userInfo, defaultValue : nil) var userInfo : LoginResponse?
    
    func updateProfile(imageData : Data){
        
        let body = UpdateProfileRequestBody(nick: nil, profile: imageData)

        NetworkManager.updateProfile(body : body)
            .sink(receiveCompletion: {[weak self] completion in
                guard let self else { return }
                switch completion {
                case .failure(let error):
                    print("⭐️🚨receiveCompletion - failure", error)
                case .finished:
                    break
                }
                
            }, receiveValue: {[weak self]  result in
                guard let self else { return }
                print("⭐️⭐️⭐️⭐️⭐️result", result)
                userInfo?.profileImage = result.profileImage
                
                print("⭐️⭐️⭐️⭐️⭐️profileImage 바뀐 후 userInfo", userInfo)
                
            })
            .store(in: &cancellables)
    }
    
}


