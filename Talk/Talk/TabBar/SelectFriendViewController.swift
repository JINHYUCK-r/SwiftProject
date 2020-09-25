//
//  SelectFriendViewController.swift
//  Talk
//
//  Created by 류진혁 on 2020/09/25.
//  Copyright © 2020 Jin-Hyuck. All rights reserved.
//

import UIKit
import Firebase
import BEMCheckBox

class SelectFriendViewController: UIViewController, UITableViewDelegate, UITableViewDataSource,BEMCheckBoxDelegate {
    
    var array : [UserModel] = []
    var users = Dictionary<String,Bool>()
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var tableview: UITableView!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return array.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let view = tableView.dequeueReusableCell(withIdentifier: "SelectFriendCell", for: indexPath) as! SelectFriendCell
        view.labelName.text = array[indexPath.row].userName
        view.imageviewProfile.kf.setImage(with: URL(string: array[indexPath.row].profileImageUrl!))
        view.checkbox.delegate = self
        view.checkbox.tag = indexPath.row

    
    return view
    }
    
    //체크박스를 클릭했을때 어떤이벤트를 발생시킬지 정함
    func didTap(_ checkBox: BEMCheckBox) {
        //체크박스가 체크되었을때
        if(checkBox.on){
            users[self.array[checkBox.tag].uid!] = true
            
          //체크박스의 체크가 해제되었을때
        }else{
            //체크가 해제되면 users의 목록에서 제거
            users.removeValue(forKey: self.array[checkBox.tag].uid!)
            
        }
    }
    
    @objc func createRoom(){
        var myUid = Auth.auth().currentUser?.uid
        users[myUid!] = true
        let nsDic = users as NSDictionary
        Database.database().reference().child("chatrooms").childByAutoId().child("users").setValue(nsDic)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //유저정보를 받아오는 코드. peopledviewcontroller에서 사용했던것을 사용
        Database.database().reference().child("users").observe(DataEventType.value) { (snapshot) in
            
            //중복되는것을 제거하는코드
            self.array.removeAll()
            
            //나의 uid를 받음
            let myUid = Auth.auth().currentUser?.uid
            
            //반복문으로 데이터베이스에 등록되어있는 값을 출력해냄
            for child in snapshot.children{
                let fchild = child as! DataSnapshot
                let userModel = UserModel()
                userModel.setValuesForKeys(fchild.value as! [String : Any])
                
                //나를 채팅목록에서 뜨지않게 하기 위함
                if(userModel.uid == myUid){
                    continue
                }
                
                self.array.append(userModel)
            }
            DispatchQueue.main.async {
                self.tableview.reloadData()
            }
            
        }

        button.addTarget(self, action: #selector(createRoom), for: .touchUpInside)

        // Do any additional setup after loading the view.
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

class SelectFriendCell : UITableViewCell {
    
    @IBOutlet weak var labelName: UILabel!
    
    @IBOutlet weak var imageviewProfile: UIImageView!
    
    @IBOutlet weak var checkbox: BEMCheckBox!
}
