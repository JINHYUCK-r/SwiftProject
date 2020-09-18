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
    
    
    public var destinationUid : String? // 나중에 내가 채팅할 대상의 uid
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        sendButton.addTarget(self, action: #selector(createRoom), for: .touchUpInside)

        // Do any additional setup after loading the view.
    }
    
    @objc func createRoom(){
        //uid는 나의 uid, destinationUid는 대화상대의 uid
        let createRoomInfo = [
            "uid" : Auth.auth().currentUser?.uid,
            "destinationUid" : destinationUid
        ]
        //데이터베이스에 채팅방정보를 등록
        Database.database().reference().child("chatrooms").childByAutoId().setValue(createRoomInfo)
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
