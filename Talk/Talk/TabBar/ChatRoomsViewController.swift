//
//  ChatRoomsViewController.swift
//  Talk
//
//  Created by 류진혁 on 2020/09/22.
//  Copyright © 2020 Jin-Hyuck. All rights reserved.
//

import UIKit
import Firebase
import Kingfisher

class ChatRoomsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    
    @IBOutlet weak var tableview: UITableView!
    var uid : String?
    var chatrooms : [ChatModel]! = []
    var destinationRoom : String?
    var destinationUsers : [String] = []
    var keys : [String] = []
    
    

      override func viewDidLoad() {
            super.viewDidLoad()
            
            self.uid = Auth.auth().currentUser?.uid
            self.getChatroomsList()
            // Do any additional setup after loading the view.
        }
     //database의 chatrooms안에서 나의 uid와 같은 방의 데이터를 가지고 옮
   
        func getChatroomsList(){
          Database.database().reference().child("chatrooms").queryOrdered(byChild: "users/"+uid!).queryEqual(toValue: true).observeSingleEvent(of: DataEventType.value, with: {(datasnapshot) in
                    
            //데이터가 새로 불러와질때 중복해서 쌓이지않도록 해줌
            self.chatrooms.removeAll()
                    for item in datasnapshot.children.allObjects as! [DataSnapshot]{
                        if let chatroomdic = item.value as? [String:AnyObject]{
                            let chatModel = ChatModel(JSON: chatroomdic)
                            self.keys.append(item.key)
                            self.chatrooms.append(chatModel!)
                        }
                        
                        
                    }
                    self.tableview.reloadData()
                    
                    
                })
                
                
                
            }

        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return self.chatrooms.count
        }
        
       func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell", for:indexPath) as! CustomCell
                  
                  var destinationUid :String?
            
                        for item in chatrooms[indexPath.row].users{
                            if(item.key != self.uid){
                                destinationUid = item.key
                                destinationUsers.append(destinationUid!)
                            }
                        }
        //채팅방에서 상대방의 uid에 접근해서 상대방의 정보를 받아옴
              Database.database().reference().child("users").child(destinationUid!).observeSingleEvent(of: DataEventType.value, with: {
                          (datasnapshot) in
                          
                          let userModel = UserModel()
                          userModel.setValuesForKeys(datasnapshot.value as! [String:AnyObject])
                          
                          
                          cell.label_title.text = userModel.userName
                          let url = URL(string:userModel.profileImageUrl!)
                          
                          cell.imageview.layer.cornerRadius = cell.imageview.frame.width/2
                          cell.imageview.layer.masksToBounds = true
                          cell.imageview.kf.setImage(with: url)
                          if(self.chatrooms[indexPath.row].comments.keys.count == 0){
                              return
                          }
                          
                          let lastMessagekey = self.chatrooms[indexPath.row].comments.keys.sorted(){$0>$1}
                          cell.label_lastmessage.text = self.chatrooms[indexPath.row].comments[lastMessagekey[0]]?.message
                          let unixTime = self.chatrooms[indexPath.row].comments[lastMessagekey[0]]?.timestamp
                          cell.label_timestamp.text = unixTime?.toDayTime
                          
                          
                          
                      })
                      
                      
                      
                      
                      return cell
                      
                      
                  }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if(self.destinationUsers[indexPath.row].count > 2){
            
           //let destinationUid = self.destinationUsers[indexPath.row]
            let view = self.storyboard?.instantiateViewController(withIdentifier: "GroupChatRoomViewController") as! GroupChatRoomViewController
            view.destinationRoom = self.keys[indexPath.row]
            self.navigationController?.pushViewController(view, animated: true)
            
        }else{
            
            let destinationUid = self.destinationUsers[indexPath.row]
            let view = self.storyboard?.instantiateViewController(withIdentifier: "ChatViewController") as! ChatViewController
            view.destinationUid = destinationUid
            self.navigationController?.pushViewController(view, animated: true)
        }
        
        
        
    }
          //  didappear될때마다 새로 로딩
        override func viewDidAppear(_ animated: Bool) {
            viewDidLoad()
        }
    override func viewDidDisappear(_ animated: Bool) {
        viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
        viewDidLoad()
    }

        override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
            // Dispose of any resources that can be recreated.
        }
        

        /*
        // MARK: - Navigation
        // In a storyboard-based application, you will often want to do a little preparation before navigation
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            // Get the new view controller using segue.destinationViewController.
            // Pass the selected object to the new view controller.
        }
        */

    }

class CustomCell : UITableViewCell{
    
    @IBOutlet weak var imageview: UIImageView!

    @IBOutlet weak var label_title: UILabel!
    
    @IBOutlet weak var label_lastmessage: UILabel!
    
    @IBOutlet weak var label_timestamp: UILabel!
}
