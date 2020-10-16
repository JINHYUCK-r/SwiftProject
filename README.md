# SwiftProject

[**MyMovieChart**](https://github.com/JINHYUCK-r/SwiftProject/tree/master/MyMovieChart)
- ImagePicker 사용
*  버튼을 눌러 이미지 삽입


[**Talk**](https://github.com/JINHYUCK-r/SwiftProject/tree/master/Talk)
- Pod 설치 활용
 pod 'Firebase/RemoteConfig'
 pod 'TextFieldEffects'
 pod 'Firebase/Database'
 pod 'Firebase/Auth'
 pod 'Firebase/Storage'
 pod 'ObjectMapper', '~> 4.2'
 pod 'Kingfisher', '~> 5.15'
 pod 'BEMCheckBox'
 
- 로그인창
* Auth.auth().signIn 메소드를 사용하여 로그인정보확인(아이디와 패스워드 일치여부)

- 회원가입
* firebase에 회원가입 정보 등록
* imagePicker로 사진등록/ firebase에 이미지 주소 등록하여 불러와사용
 
 
- 탭바
* People
+ tablaview사용 
+ firebase에 등록된 회원정보를 가져와서 목록으로 보여줌
+ 사용자 목록이 선택되면 chatview로 이동(ChatViewController)
  - 여러명 선택시 단체채팅방 생성 view로 이동(SelectFriendViewController)
 * Chat
  - 나와 상대방의 uid를 활용하여 채팅방 데이터베이스를 firebase에 생성
  - 가장 최신의 메세지를 맨밑에 표시
  - 메세지 읽음표시
  - 메세지 길이에 따른 유동적인 셀크기 조정
  - toDayTime 메소드를 만들어서 메시지 보낸 시간 표시
 * Account
  - 상태메세지등록
