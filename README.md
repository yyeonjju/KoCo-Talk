# KoCo-Talk

![KoCoTalk_1](https://github.com/user-attachments/assets/b666bbf4-9fd7-4fd7-a2ce-43cdf3226deb) |![KoCoTalk_2](https://github.com/user-attachments/assets/1589f472-4cc1-49ed-a4a2-1f4c50eddb8d) |![KoCoTalk_3](https://github.com/user-attachments/assets/4f8843a5-273a-4c34-a279-78ef88fc51b2) |![KoCoTalk_4](https://github.com/user-attachments/assets/ed9f50b3-9d33-4ab3-b98a-8f4c3bf2079c) |![KoCoTalk_5](https://github.com/user-attachments/assets/76aadadc-aa60-4f7b-a82f-f5b30b90d486) |![KoCoTalk_6](https://github.com/user-attachments/assets/0512bb6f-1c0e-445f-96de-196080987bdf)
--- | --- | --- | --- | --- | --- |


<br/><br/>

## 🪗 KoCo-Talk
- 앱 소개 : 코스메틱/뷰티 매장이 등록한 매장별 정보 확인 및 제품에 대한 문의 사항 실시간 상담 앱
- 개발 인원 : iOS 1인, 서버 1인
- 개발 기간 : 약 4주
- 최소 버전 : 16.0


<br/><br/>

## 📎 기술 스택
- UI : SwiftUI
- Network : Alamofire
- Architecture : MVI
- Concurrency : Swift Concurrency(async/await)
- Dependency : Swinject
- Local DB : Realm
- ETC. : SocketIO, KeyChain, CoreLocation


<br/><br/>



## 📝 핵심 기능
- 매장 유저의 매장 정보 등록
- 소비자 유저의 현재 위치 기반 주변 매장 검색 및 매장 정보 확인
- 매장 유저와 실시간 채팅 및 상담


<br/><br/>


## ✅ 핵심 기술 구현 사항

- MVI 아키텍쳐를 통한 단방향 데이터 플로우를 구현함으로써 상태 관리의 예측 가능성 및 디버깅 용이성 향상
- SocketIO를 통해 채팅 기능을 위한 서버-클라이언트 간 양방향 통신 구현
- Realm을 사용해 확인한 메시지 데이터를 로컬에 저장함으로써 다량의 채팅 로드 시 네트워킹 시점의 부하 축소
- SocketIOManager를 구현하여 소켓 연결, 해제, 메시지 수신 이벤트 관리
- 기존 Combine 프레임워크 기반 비동기 데이터 흐름을 Swift Concurrency로 마이그레이션하여 async/await 문법을 활용한 직관적이고 가독성 높은 비동기 코드 구조 확립
- Swinject 라이브러리를 도입하여 애플리케이션 전체의 의존성 관리를 중앙화함으로써 코드 결합도를 낮추고 유지보수성 향상
- Assembler를 활용하여 도메인 및 기능별 Assembly를 모듈화하여 관리
- Custom PropertyWrapper @Injected를 구현하여 DI 컨테이너에서의 의존성 검색(resolve) 및 의존성 주입 과정을 추상화함으로써 보일러플레이트 최소화
- KeyChain 보안 스토리지를 활용하여 JWT 기반 Access/Refresh Tooken과 같은 민감한 인증 정보를 암호화된 형태로 저장
- Token 만료 시 자동 갱신 메커니즘을 구현하여 사용자 경험 저하 없이 지속적인 서비스 접근성 보장
