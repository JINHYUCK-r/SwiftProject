//
//  ChatRoomsViewController.swift
//  Talk
//
//  Created by 류진혁 on 2020/09/22.
//  Copyright © 2020 Jin-Hyuck. All rights reserved.
//

import UIKit
import Firebase


class ChatRoomsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    
    @IBOutlet weak var tableView: UITableView!
    var uid : String?
    var chatrooms : [ChatModel]! = []
    
    

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
                      self.chatrooms.append(chatModel!)
                  }
                  
              }
            self.tableView.reloadData()
              
              
          })
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
    //  테이블뷰 메서드
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.chatrooms.count

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell", for: indexPath) as! CustomCell
        var destinationUid : String?
        
        for item in chatrooms[indexPath.row].users{
            if(item.key != self.uid!){
                destinationUid = item.key
            }
        }
        //채팅방에서 상대방의 uid에 접근해서 상대방의 정보를 받아옴
        Database.database().reference().child("users").child(destinationUid!).observeSingleEvent(of: DataEventType.value, with: {
            (datasnapshot) in
            
            let userModel = UserModel()
            userModel.setValuesForKeys(datasnapshot.value as! [String:AnyObject])
            
            
            cell.lable_title.text = userModel.userName
            let url = URL(string:userModel.profileImageUrl!)
            URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, err) in
                
                DispatchQueue.main.sync {
                    cell.imageview.image = UIImage(data:data!)
                    cell.imageview.layer.cornerRadius = cell.imageview.frame.width/2
                    cell.imageview.layer.masksToBounds = true
                }
            }).resume()
            
            //sorted 오름차순일 경우 $0이 크게 아니면 반대로
            let lastMessagekey = self.chatrooms[indexPath.row].comments.keys.sorted(){$0>$1}
            cell.label_lastmessage.text = self.chatrooms[indexPath.row].comments[lastMessagekey[0]]?.message
            
            
            
        })
        
        return cell

    }

    //  dissappear될때마다 새로 로딩
    override func viewDidDisappear(_ animated: Bool) {
        viewDidLoad()
    }

}


class CustomCell : UITableViewCell{
    
    @IBOutlet weak var imageview: UIImageView!

    @IBOutlet weak var lable_title: UILabel!
    
    @IBOutlet weak var label_lastmessage: UILabel!
    
}
