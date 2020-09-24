//
//  ChatViewController.swift
//  Talk
//
//  Created by 류진혁 on 2020/09/18.
//  Copyright © 2020 Jin-Hyuck. All rights reserved.
//

import UIKit
import Firebase
import Kingfisher

class ChatViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    
    
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    
    @IBOutlet weak var sendButton: UIButton!
    
    @IBOutlet weak var textField_message: UITextField!
    
    @IBOutlet weak var tableView: UITableView!
    
    public var destinationUid : String? // 나중에 내가 채팅할 대상의 uid
    var uid : String?
    var chatRoomUid : String?
    var comments : [ChatModel.Comment] = []
    var userModel : UserModel?
    

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        uid = Auth.auth().currentUser?.uid
        sendButton.addTarget(self, action: #selector(createRoom), for: .touchUpInside)
        checkChatRoom()
        //채팅방뷰에 나타날때 탭바를 숨김
        self.tabBarController?.tabBar.isHidden = true
        // Do any additional setup after loading the view.
        
        //화면 밖을 탭하면 키보드가 사라짐
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    //화면시작
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
       }
    //채팅방에서 나갈때( 종료될때)
    override func viewWillDisappear(_ animated: Bool) {NotificationCenter.default.removeObserver(self)
        //탭바가 사라지는것을 다시 취소, 다시 띄움
        self.tabBarController?.tabBar.isHidden = false
    }
    //키보드가 보여지는 메서드
    @objc func keyboardWillShow(notification : Notification){
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue{
            self.bottomConstraint.constant = keyboardSize.height
        }
        UIView.animate(withDuration: 0, animations: {self.view.layoutIfNeeded()}, completion: {
            (complete) in
            //키보드가 나타날때 테이블뷰를 맨밑으로 보여줌
            if self.comments.count>0{
                self.tableView.scrollToRow(at: IndexPath(item: self.comments.count-1, section: 0), at: UITableView.ScrollPosition.bottom, animated: true)
            }
        })
    }
    
    @objc func keyboardWillHide(notification:Notification){
        self.bottomConstraint.constant = 0
        self.view.layoutIfNeeded()
    }
    
    @objc func dismissKeyboard(){
        self.view.endEditing(true)
    }
    
    @objc func createRoom(){
        //uid는 나의 uid, destinationUid는 대화상대의 uid
        //ChatMoel에서 만들어 놓은 형태
        let createRoomInfo : Dictionary<String,Any> = [ "users" : [
                   uid!: true,
                   destinationUid! :true
                   ]
               ]
        
        if(chatRoomUid == nil){
            //버튼이 한번눌리면 방이 생성될때 다시 눌려서 또 방이 생성되지 않게 하기위해서 false로 만들어줌
            self.sendButton.isEnabled = false
            
            //데이터베이스에 채팅방정보를 등록, 방 생성
             Database.database().reference().child("chatrooms").childByAutoId().setValue(createRoomInfo, withCompletionBlock: { (err, ref) in
                           if(err == nil){
                            self.checkChatRoom()
                           }
                       })
            
        }else{
            //이미 채팅방이 존재하면 메시지를 추가 등록
            let value :Dictionary<String,Any> = [

                    "uid" : uid!,
                    "message" : textField_message.text!,
                    "timestamp" : ServerValue.timestamp()
            ]
            
            Database.database().reference().child("chatrooms").child(chatRoomUid!).child("comments").childByAutoId().setValue(value) { (err, ref) in
                self.textField_message.text! = ""
            }
        }
       
    }
    
    //대화를 전송할때마다 중복으로 방이 만들어 지는것을 방지
    func checkChatRoom(){
           
          Database.database().reference().child("chatrooms").queryOrdered(byChild: "users/"+uid!).queryEqual(toValue: true).observeSingleEvent(of: DataEventType.value,with: { (datasnapshot) in
           for item in datasnapshot.children.allObjects as! [DataSnapshot]{
            if let chatRoomdic = item.value as? [String:AnyObject]{
                let chatModel = ChatModel(JSON: chatRoomdic)
                if(chatModel?.users[self.destinationUid!] == true){
                     self.chatRoomUid = item.key
                    //꺼놓았던 버튼을 다시 실행시켜줌
                    self.sendButton.isEnabled = true
                    self.getDestinationInfo()
                }
            }
             
                   
               }
           })
           
       }
    //대화 상대의 정보를 가져옴
    func getDestinationInfo(){
        Database.database().reference().child("users").child(self.destinationUid!).observeSingleEvent(of: DataEventType.value, with: { (datasnapshot) in
            self.userModel = UserModel()
            self.userModel?.setValuesForKeys(datasnapshot.value as! [String : Any])
            self.getMassgeList()
        })
    }
    //메세지를 받을때
    func getMassgeList(){
        Database.database().reference().child("chatrooms").child(self.chatRoomUid!).child("comments").observe(DataEventType.value, with:  { (datasnapshot) in
            //데이터가 누적되는것을 방지
            self.comments.removeAll()
            
           for item in datasnapshot.children.allObjects as! [DataSnapshot]{
                let comment = ChatModel.Comment(JSON: item.value as! [String:AnyObject])
                self.comments.append(comment!)
            }
            self.tableView.reloadData()
            //테이블뷰의 맨끝으로 이동하게 되는 메소드
            if self.comments.count > 0{
                self.tableView.scrollToRow(at: IndexPath(item: self.comments.count-1, section: 0), at: UITableView.ScrollPosition.bottom, animated: true)
                
            }
            
           
            })
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        comments.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
          //uid를 확인하여 나의 메세지셀에 보여주거나 상대방의 메세지 셀을 보여줌
          //내가 보낸 메세지
          if(self.comments[indexPath.row].uid == uid){
              let view = tableView.dequeueReusableCell(withIdentifier: "MyMessageCell", for: indexPath) as! MyMessageCell
              view.label_message.text = self.comments[indexPath.row].message
              view.label_message.numberOfLines = 0
              
             //내가 보낸 시간을 찍어주는 코드
               if let time = self.comments[indexPath.row].timestamp{
                view.lable_timestamp.text = time.toDayTime
              }
              
              return view
              
          }else{
              //상대방이 보내준 메세지
              let view = tableView.dequeueReusableCell(withIdentifier: "DestinationMessageCell", for: indexPath) as! DestinationMessageCell
              view.label_name.text = userModel?.userName
              view.label_message.text = self.comments[indexPath.row].message
              view.label_message.numberOfLines = 0;
            
            //상대가 보낸 시간을 찍어주는 코드
            if let time = self.comments[indexPath.row].timestamp{
                                                view.label_timestamp.text = time.toDayTime
                                            }
              
              let url = URL(string:(self.userModel?.profileImageUrl)!)
            //이미지를 동그랗게 만들어주는 코드
            view.imageview_profile.layer.cornerRadius = view.imageview_profile.frame.width/2
            view.imageview_profile.clipsToBounds = true
            view.imageview_profile.kf.setImage(with: url)
            
              return view
              
          }
          return UITableViewCell()
      }
    
    //테이블뷰의유동적인 셀 높이 조정
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

}


extension Int{
    
    var toDayTime :String{
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.dateFormat = "yyyy.MM.dd HH:mm"
        let date = Date(timeIntervalSince1970: Double(self)/1000)
        return dateFormatter.string(from: date)
        
    }
    
}//chat뷰에서 셀을 받는 클래스
class MyMessageCell : UITableViewCell{
    
    @IBOutlet weak var lable_timestamp: UILabel!
    @IBOutlet weak var label_message: UILabel!
}
class DestinationMessageCell:UITableViewCell{
    
    @IBOutlet weak var label_message: UILabel!

    @IBOutlet weak var imageview_profile: UIImageView!
    
    @IBOutlet weak var label_name: UILabel!
    @IBOutlet weak var label_timestamp: UILabel!
    
    
    
}
