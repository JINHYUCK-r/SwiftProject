//
//  SignUpViewController.swift
//  Talk
//
//  Created by 류진혁 on 2020/09/15.
//  Copyright © 2020 Jin-Hyuck. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var email: UITextField!
    
    @IBOutlet weak var name: UITextField!
    
    @IBOutlet weak var password: UITextField!
    
    @IBOutlet weak var signUp: UIButton!
    
    @IBOutlet weak var cancel: UIButton!
    
    let remoteConfig = RemoteConfig.remoteConfig()
    var color : String!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 맨위에 상태창 추가
               let statusBar = UIView()
               self.view.addSubview(statusBar)
               statusBar.snp.makeConstraints { (m) in
                   m.right.top.left.equalTo(self.view)
                   m.height.equalTo(20)
               }
               //파이어베이스에 올라와 있는 색상값을 입력해 회원가입 색상 변경
               color = remoteConfig["splash_background"].stringValue
        statusBar.backgroundColor = UIColor(hex: color)
        // Do any additional setup after loading the view.
        signUp.backgroundColor = UIColor(hex: color)
        cancel.backgroundColor = UIColor(hex: color)
        
        signUp.addTarget(self, action: #selector(signUpEvent), for: .touchUpInside)
        cancel.addTarget(self, action: #selector(cancelEvent), for: .touchUpInside)
    }
    
    @objc func signUpEvent(){
        Auth.auth().createUser(withEmail: email.text!, password: password.text!) { (user, err)  in
            let uid = user?.user.uid
            Database.database().reference().child("users").child(uid!).setValue(["name":self.name.text!])
            print("에러",err!)
        }
    }
    @objc func cancelEvent(){
        self.dismiss(animated: true, completion: nil)
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
