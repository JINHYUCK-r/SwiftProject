//
//  GroupChatRoomViewController.swift
//  Talk
//
//  Created by 류진혁 on 2020/09/25.
//  Copyright © 2020 Jin-Hyuck. All rights reserved.
//

import UIKit
import Firebase

class GroupChatRoomViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var button_send: UIButton!
    
    @IBOutlet weak var textfield_message: UITextField!
    
    @IBOutlet weak var tableview: UITableView!
    var destinationRoom : String?
    var uid : String?
    var users : [String:AnyObject]?
    var peopleCount : Int?
    
    var databaseRef : DatabaseReference?
    var observe : UInt?
    var comments : [ChatModel.Comment] = []
    
       override func viewDidLoad() {
            super.viewDidLoad()
            uid = Auth.auth().currentUser?.uid
            Database.database().reference().child("users").observeSingleEvent(of: DataEventType.value, with: {(datasnapshot) in
                self.users = datasnapshot.value as! [String:AnyObject]
                
            })
            button_send.addTarget(self, action: #selector(sendMessage), for: .touchUpInside)
            // Do any additional setup after loading the view.
            getMessageList()
            
        }
        @objc func sendMessage(){
            
            let value : Dictionary<String,Any> = [
                "uid": uid!,
                "message": textfield_message.text!,
                "timestamp" : ServerValue.timestamp()
            ]
            Database.database().reference().child("chatrooms").child(destinationRoom!).child("comments").childByAutoId().setValue(value) { (err, ref) in
                
                Database.database().reference().child("chatrooms").child(self.destinationRoom!).child("users").observeSingleEvent(of: DataEventType.value, with: { (datasnapshot) in
                    let dic = datasnapshot.value as! [String:Any]
                    
                    for item in dic.keys{
                        if(item == self.uid){
                            continue
                        }
                        
                    }
                    self.textfield_message.text = ""
                })
            }
            
        }
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return comments.count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
              if(self.comments[indexPath.row].uid == uid){
                      let view = tableView.dequeueReusableCell(withIdentifier: "MyMessageCell", for: indexPath) as! MyMessageCell
                      view.label_message.text = self.comments[indexPath.row].message
                      view.label_message.numberOfLines = 0
                      
                      if let time = self.comments[indexPath.row].timestamp{
                          view.label_timestamp.text = time.toDayTime
                      }
                      
                      
                      setReadCount(label: view.label_read_counter, position: indexPath.row)
                      
                      return view
                      
                  }else{
                      let destinationUser = users![self.comments[indexPath.row].uid!]
                      let view = tableView.dequeueReusableCell(withIdentifier: "DestinationMessageCell", for: indexPath) as! DestinationMessageCell
                      view.label_name.text = destinationUser!["userName"] as! String
                      view.label_message.text = self.comments[indexPath.row].message
                      view.label_message.numberOfLines = 0;
                      let imageUrl = destinationUser!["profileImageUrl"] as! String
                      let url = URL(string:(imageUrl))
                      view.imageview_profile.layer.cornerRadius = view.imageview_profile.frame.width/2
                      view.imageview_profile.clipsToBounds = true
                      view.imageview_profile.kf.setImage(with: url)
                      
                      if let time = self.comments[indexPath.row].timestamp{
                          view.label_timestamp.text = time.toDayTime
                      }
                      
                      
                      setReadCount(label: view.label_read_counter, position: indexPath.row)
                      return view
                      
                  }
                  
                  
                  
                  
                  
                  return UITableViewCell()
                  
              }
 

    
    //챗뷰컨트롤러에서 사용한것 재사용
        func getMessageList(){
            databaseRef = Database.database().reference().child("chatrooms").child(self.destinationRoom!).child("comments")
            observe = databaseRef?.observe(DataEventType.value, with: { (datasnapshot) in
                self.comments.removeAll()
                var readUserDic : Dictionary<String,AnyObject> = [:]
                for item in datasnapshot.children.allObjects as! [DataSnapshot]{
                    let key = item.key as String
                    let comment = ChatModel.Comment(JSON: item.value as! [String:AnyObject])
                    let comment_motify = ChatModel.Comment(JSON: item.value as! [String:AnyObject])
                    comment_motify?.readUsers[self.uid!] = true
                    readUserDic[key] = comment_motify?.toJSON() as! NSDictionary
                    self.comments.append(comment!)
                }
                
                let nsDic = readUserDic as NSDictionary
                
                if(self.comments.last?.readUsers.keys == nil){
                    return
                }
                
                if(!(self.comments.last?.readUsers.keys.contains(self.uid!))!){
                    
                    
                    datasnapshot.ref.updateChildValues(nsDic as! [AnyHashable : Any], withCompletionBlock: { (err, ref) in
                        
                        self.tableview.reloadData()
                        
                        if self.comments.count > 0{
                            self.tableview.scrollToRow(at: IndexPath(item:self.comments.count - 1,section:0), at: UITableView.ScrollPosition.bottom, animated: true)
                            
                        }
                        
                    })
                    
                }else{
                    self.tableview.reloadData()
                    
                    if self.comments.count > 0{
                        self.tableview.scrollToRow(at: IndexPath(item:self.comments.count - 1,section:0), at: UITableView.ScrollPosition.bottom, animated: false)
                        
                    }
                }
                
                
                
                
                
            })
            
        }
    
    func setReadCount(label:UILabel?, position: Int?){
        let readCount = self.comments[position!].readUsers.count
        if(peopleCount == nil){
            
        
        Database.database().reference().child("chatrooms").child(destinationRoom!).child("users").observeSingleEvent(of: DataEventType.value, with:     {(DataSnapshot) in
            
            let dic = DataSnapshot.value as! [String:Any]
            self.peopleCount = dic.count
            let noReadCount = self.peopleCount! - readCount
            if(noReadCount > 0){
                           label?.isHidden = false
                           label?.text = String(noReadCount)
                       }else{
                           label?.isHidden = true
                       }
            
           
        })
        }else{
            let noReadCount = self.peopleCount! - readCount
            if(noReadCount > 0){
                label?.isHidden = false
                label?.text = String(noReadCount)
            }else{
                label?.isHidden = true
            }
            
        }
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
