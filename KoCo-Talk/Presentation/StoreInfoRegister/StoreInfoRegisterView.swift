//
//  StoreInfoRegisterView.swift
//  KoCo-Talk
//
//  Created by 하연주 on 3/14/25.
//

import SwiftUI
import Combine

struct StoreInfoRegisterView: View {
    let category = APIKEY.category_value
    //"Koco_Talk_StoreInfo_test"
    //"Koco_Talk_StoreInfo_v2"
    let placeName = "논픽션 신사"
    let kakaoPlaceID = "1543939713"
    let address = "서울 강남구 신사동 524-33"
    let storeCategory = "화장품"
    let phone = "02-511-4098"
    let storeImages = [
        "http://imgnews.naver.net/image/5264/2023/08/04/0000616598_002_20230804090202481.jpg"
        
    ]
    let longitude : Double = 127.022056876491
    let latitude : Double = 37.5226435732714
    
    
    @StateObject private var vm = StoreInfoRegisterViewModel()
    @State private var showTabBar = false
    
    
    // 영업 시간
    @State private var openingTime = Date()
    @State private var closingTime = Date()
    
    // 응대 가능 언어
    @State private var languages: String = ""
    
    // 추천 제품, 인기 제품, 주요 제품 모델
    @State private var recommendedProducts: [ProductItem] = [ProductItem()]
    @State private var popularProducts: [ProductItem] = [ProductItem()]
    @State private var stockProducts: [ProductItem] = [ProductItem()]

    
    // 이미지 선택 관련
    @State private var isShowingImagePicker = false
    @State private var currentEditingProduct: ProductItemBinding? = nil
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 10) {
                    // 1. 영업 시간 섹션
                    sectionTitle("영업 시간")
                    
                    HStack {
                        DatePicker("시작 시간", selection: $openingTime, displayedComponents: .hourAndMinute)
                            .labelsHidden()
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(8)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                            )
                        
                        Text("-")
                            .font(.headline)
                            .padding(.horizontal, 5)
                        
                        DatePicker("마감 시간", selection: $closingTime, displayedComponents: .hourAndMinute)
                            .labelsHidden()
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(8)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                            )
                    }
                    
                    sectionDivider()
                    
//
                    
                    
                    // 3. 응대가능 언어 섹션
                    sectionTitle("응대가능 언어")
                    
                    TextField("응대가능 언어를 입력하세요 (예: 한국어 영어 중국어 일본어)", text: $languages)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                        )
                    
                    sectionDivider()
                    
                    // 4. 추천제품 섹션
                    productSection(
                        title: "추천제품",
                        products: $recommendedProducts
                    )
                    
                    sectionDivider()
                    
                    // 5. 인기제품 섹션
                    productSection(
                        title: "인기제품",
                        products: $popularProducts
                    )
                    
                    sectionDivider()
                    
                    // 6. 주요제품 재고 섹션
                    productSection(
                        title: "주요제품 재고",
                        products: $stockProducts
                    )
                    
                    // 저장 및 취소 버튼
                    Button(action: saveData) {
                        Text("저장하기")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Assets.Colors.pointGreen1)
                            .cornerRadius(10)
                    }
                    .padding(.top, 20)
                    
                    Button(action: cancel) {
                        Text("취소하기")
                            .font(.headline)
                            .foregroundColor(.gray)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                            )
                    }
                    .padding(.bottom, 30)
                }
                .padding()
                .padding(.bottom, 100)
                .background(Assets.Colors.pointGreen3)
            }
            .navigationBarTitle("매장 정보 등록", displayMode: .inline)
            .navigationBarItems(trailing: Button(action: saveData) {
                Image(systemName: "checkmark")
                    .foregroundColor(.black)
            })
            .onAppear{
                showTabBar = false
            }
            .onDisappear{
                showTabBar = true
            }
            .toolbar(showTabBar ? .visible : .hidden, for: .tabBar)
            .background(.white)
            .edgesIgnoringSafeArea(.bottom)
            .sheet(isPresented: $isShowingImagePicker) {
                ImagePicker(selectedImage: Binding<UIImage?>(
                    get: { self.currentEditingProduct?.image.wrappedValue },
                    set: { newImage in
                        if let newImage = newImage, let currentEditingProduct =  self.currentEditingProduct {
                            currentEditingProduct.image.wrappedValue = newImage
                            
                            let imageData = newImage.jpegData(compressionQuality: 0.7) ?? Data()
                            vm.uploadFiles(
                                imageData: imageData,
                                bindingImageString: Binding(get: {
                                    currentEditingProduct.imageUrl.wrappedValue
                                }, set: {
                                    currentEditingProduct.imageUrl.wrappedValue = $0
                                })
                            )
                        }
                    }
                ))
            }
        }
    }
    
    // 섹션 제목 컴포넌트
    private func sectionTitle(_ title: String) -> some View {
        Text(title)
            .font(.headline)
            .fontWeight(.bold)
            .foregroundColor(Color.gray.opacity(0.8))
            .padding(.top, 5)
    }
    
    // 섹션 구분선 컴포넌트
    private func sectionDivider() -> some View {
        Divider()
            .background(Assets.Colors.gray2)
            .padding(.vertical, 10)
    }
    
    // 제품 섹션 컴포넌트
    private func productSection(title: String, products: Binding<[ProductItem]>) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            sectionTitle(title)
            
            ForEach(products.indices, id: \.self) { index in
                productItemView(product: products[index], products: products, index: index)
            }
            
            Button(action: {
                withAnimation {
                    products.wrappedValue.append(ProductItem())
                }
            }) {
                HStack {
                    Spacer()
                    Text("추가 +")
                        .foregroundColor(.white)
                    Spacer()
                }
                .padding(4)
                .background(Assets.Colors.gray2)
                .cornerRadius(20)
            }
            .padding(.vertical, 10)
        }
    }
    
    // 제품 아이템 컴포넌트
    private func productItemView(product: Binding<ProductItem>, products: Binding<[ProductItem]>, index: Int) -> some View {
        VStack {
            HStack {
                Spacer()
                
                // 삭제 버튼
                Button(action: {
                    if products.count > 1 {
                        products.wrappedValue.remove(at: index)
                    }
                }) {
                    Image(systemName: "minus.circle.fill")
                        .foregroundColor(.red)
                        .font(.title2)
                }
                .padding(.trailing, 10)
                .padding(.top, 10)
            }
            
            HStack(alignment: .top, spacing: 15) {
                // 이미지 선택 영역
                Button(action: {
                    self.currentEditingProduct = ProductItemBinding(
                        image: product.image,
                        imageUrl: product.imageUrl,
                        name: product.name,
                        description: product.description
                    )
                    self.isShowingImagePicker = true
                }) {
                    if let uiImage = product.image.wrappedValue {
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 120, height: 120)
                            .clipShape(RoundedRectangle(cornerRadius: 5))
                    } else {
                        VStack {
                            Image(systemName: "plus")
                                .font(.largeTitle)
                                .foregroundColor(.gray)
                            
                            Text("사진 등록")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                        .frame(width: 120, height: 120)
                        .background(Color.gray.opacity(0.1))
                        .overlay(
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(Color.gray.opacity(0.3), style: StrokeStyle(lineWidth: 1, dash: [5]))
                        )
                    }
                }
                
                VStack(spacing: 10) {
                    // 제품 이름 입력
                    TextField("제품 이름", text: product.name)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(5)
                        .overlay(
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                        )
                    
                    // 제품 설명 입력
                    TextEditor(text: product.description)
                        .frame(height: 60)
                        .padding(5)
                        .background(Color.white)
                        .cornerRadius(5)
                        .overlay(
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                        )
                }
            }
            .padding()
        }
        .background(Color.white)
        .cornerRadius(8)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color.gray.opacity(0.5), lineWidth: 1)
        )
    }
    
    // 저장 기능
    private func saveData() {
        
        let formatter = DateFormatter.getKRLocaleDateFormatter(format: .storeOperatingTimeFormat)
        let openingTimeString = formatter.string(from: openingTime)
        let closingTimeString = formatter.string(from: closingTime)
        
        print("💕💕💕recommendedProducts💕💕💕", recommendedProducts)
        print("💕💕💕popularProducts💕💕💕", popularProducts)
        print("💕💕💕stockProducts💕💕💕", stockProducts)
        
        let recommended = recommendedProducts.map{
            StoreProductContent(imageUrl: $0.imageUrl, title: $0.name, description: $0.description)
        }
        let popular = popularProducts.map{
            StoreProductContent(imageUrl: $0.imageUrl, title: $0.name, description: $0.description)
        }
        let stock = stockProducts.map{
            StoreProductContent(imageUrl: $0.imageUrl, title: $0.name, description: $0.description)
        }
        
        
        let storeInfo = StoreData(
            placeName: placeName,
            kakaoPlaceID: kakaoPlaceID,
            address: address,
            storeCategory: storeCategory,
            phone: phone,
            storeImages: storeImages,
            
            operatingTime : "\(openingTimeString) - \(closingTimeString)",
            availableLanguages: languages,
            recommendProducts: recommended,
            bestSellingProducts: popular,
            productStock: stock
        )
        
        print("❤️❤️매장데이터❤️❤️", storeInfo)
        
        //먼저 데이터 형태로 인코딩
        let encodedData = try? JSONEncoder().encode(storeInfo)
        guard let encodedData else{
            return
        }
        //string형태로 변환
        let stringFormStoreData = String(decoding: encodedData, as: UTF8.self)
        
        let postBody = StoreInfoPostBody(
            category: category,
            title: placeName,
            price: 100,
            content: stringFormStoreData,
            content1: "",
            content2: "",
            content3: "",
            content4: "",
            content5: "",
            files: [],
            longitude: longitude,
            latitude: latitude
        )
        
        vm.post(postBody: postBody)
    }
    
    // 취소 기능
    private func cancel() {
        // 여기에 취소 기능 구현
        print("등록 취소")
    }
}

// 제품 데이터 모델
struct ProductItem {
    var image: UIImage? = nil
    var imageUrl : String = ""
    var name: String = ""
    var description: String = ""
}

// 이미지 피커에 바인딩하기 위한 래퍼 구조체
struct ProductItemBinding {
    var image: Binding<UIImage?>
    var imageUrl : Binding<String>
    var name: Binding<String>
    var description: Binding<String>
}

// 이미지 피커 뷰
struct ImagePicker: UIViewControllerRepresentable {
    @Environment(\.presentationMode) var presentationMode
    @Binding var selectedImage: UIImage?
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.allowsEditing = true
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let editedImage = info[.editedImage] as? UIImage {
                parent.selectedImage = editedImage
            } else if let originalImage = info[.originalImage] as? UIImage {
                parent.selectedImage = originalImage
            }
            
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}




class StoreInfoRegisterViewModel : ObservableObject {
    private var cancellables = Set<AnyCancellable>()
    
    func post(postBody : StoreInfoPostBody) {
        print("❤️❤️최종 post body❤️❤️", postBody)
        
        NetworkManager.postStoreData(body : postBody)
            .sink(receiveCompletion: { [weak self] completion in
                guard let self else { return }
                switch completion {
                case .failure(let error):
                    print("⭐️receiveCompletion - failure", error)
                case .finished:
                    break
                }
                
            }, receiveValue: {[weak self] result in
                guard let self else { return }
                
                print("❤️Post 완료❤️", result)
                
            })
            .store(in: &cancellables)
    }
    
    func uploadFiles(imageData : Data, bindingImageString : Binding<String>) {
        print("❤️❤️❤️imageData❤️❤️", imageData)
        NetworkManager.uploadFiles(fileDatas: [imageData])
            .sink(receiveCompletion: {[weak self] completion in
                guard let self else { return }
                switch completion {
                case .failure(let error):
                    print("⭐️receiveCompletion - failure", error)
                case .finished:
                    break
                }
                
            }, receiveValue: {[weak self]  result in
                guard let self else { return }
                print("⭐️⭐️⭐️⭐️⭐️result", result)
                let imageUrl = result.files.first ?? "-"
                print("⭐️⭐️⭐️⭐️⭐️imageUrl", imageUrl)
                bindingImageString.wrappedValue = imageUrl

            })
            .store(in: &cancellables)
        

//        NetworkManager.updateProfileImage(fileDatas: [imageData])
//            .sink(receiveCompletion: {[weak self] completion in
//                guard let self else { return }
//                switch completion {
//                case .failure(let error):
//                    print("⭐️🚨receiveCompletion - failure", error)
//                case .finished:
//                    break
//                }
//
//            }, receiveValue: {[weak self]  result in
//                guard let self else { return }
//                print("⭐️⭐️⭐️⭐️⭐️result", result)
//                let imageUrl = result.profileImage ?? "-"
//                print("⭐️⭐️⭐️⭐️⭐️imageUrl", imageUrl)
//                bindingImageString.wrappedValue = imageUrl
//
//            })
//            .store(in: &cancellables)
    }
}
