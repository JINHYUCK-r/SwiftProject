//
//  ChatViewController.swift
//  Talk
//
//  Created by 류진혁 on 2020/09/18.
//  Copyright © 2020 Jin-Hyuck. All rights reserved.
//

import UIKit
import Firebase

class ChatViewController: UIViewController {
    
    
    @IBOutlet weak var sendButton: UIButton!
    
    @IBOutlet weak var textField_message: UITextField!
    
    public var destinationUid : String? // 나중에 내가 채팅할 대상의 uid
    
    var uid : String?
    var chatRoomUid : String?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        uid = Auth.auth().currentUser?.uid
        sendButton.addTarget(self, action: #selector(createRoom), for: .touchUpInside)
        checkChatRoom()
        // Do any additional setup after loading the view.
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
            //데이터베이스에 채팅방정보를 등록, 방 생성
             Database.database().reference().child("chatrooms").childByAutoId().setValue(createRoomInfo)
        }else{
            let value :Dictionary<String,Any> = [
                "comments":[
                    "uid" : uid!,
                    "message" : textField_message.text!
                ]
            ]
            
            Database.database().reference().child("chatrooms").child(chatRoomUid!).child("comments").childByAutoId().setValue(value)
        }
       
    }
    
    //대화를 전송할때마다 중복으로 방이 만들어 지는것을 방지
    func checkChatRoom(){
           
          Database.database().reference().child("chatrooms").queryOrdered(byChild: "users/"+uid!).queryEqual(toValue: true).observeSingleEvent(of: DataEventType.value,with: { (datasnapshot) in
           for item in datasnapshot.children.allObjects as! [DataSnapshot]{
              self.chatRoomUid = item.key
                   
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

}
