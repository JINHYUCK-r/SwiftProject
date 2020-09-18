//
//  ChatViewController.swift
//  Talk
//
//  Created by 류진혁 on 2020/09/18.
//  Copyright © 2020 Jin-Hyuck. All rights reserved.
//

import UIKit
import Firebase

class ChatViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let view = tableView.dequeueReusableCell(withIdentifier: "MessageCell", for: indexPath)
        view.textLabel?.text = self.comments[indexPath.row].message
        
        return view
    }
    
    
    
    @IBOutlet weak var sendButton: UIButton!
    
    @IBOutlet weak var textField_message: UITextField!
    
    @IBOutlet weak var tableView: UITableView!
    public var destinationUid : String? // 나중에 내가 채팅할 대상의 uid
    
    var uid : String?
    var chatRoomUid : String?
    var comments : [ChatModel.Comment] = []
    

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
                    "message" : textField_message.text!
            ]
            
            Database.database().reference().child("chatrooms").child(chatRoomUid!).child("comments").childByAutoId().setValue(value)
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
                    self.getMassgeList()
                }
            }
             
                   
               }
           })
           
       }
    func getMassgeList(){
        Database.database().reference().child("chatrooms").child(self.chatRoomUid!).child("comments").observe(DataEventType.value, with:  { (datasnapshot) in
            //데이터가 누적되는것을 방지
            self.comments.removeAll()
            
            for item in datasnapshot.children.allObjects as! [DataSnapshot]{
                let comment  = ChatModel.Comment(JSON: item.value as! [String: AnyObject])
                self.comments.append(comment!)
            }
            
            self.tableView.reloadData()
            
            
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
