//
//  LoginViewController.swift
//  Talk
//
//  Created by 류진혁 on 2020/09/15.
//  Copyright © 2020 Jin-Hyuck. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {

    @IBOutlet weak var signUp: UIButton!
    @IBOutlet weak var loginButton: UIButton!
   
    @IBOutlet weak var email: UITextField!
    
    @IBOutlet weak var password: UITextField!
    
    //원격으로 리모트해서 색을 가져옴
    let remoteConfig = RemoteConfig.remoteConfig()
    var color : String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //로그아웃 시키는 코드
        try! Auth.auth().signOut()
        
        // 맨위에 상태창 추가
        let statusBar = UIView()
        self.view.addSubview(statusBar)
        statusBar.snp.makeConstraints { (m) in
            m.right.top.left.equalTo(self.view)
            m.height.equalTo(20)
        }
        //파이어베이스에 올라와 있는 색상값을 입력해 로그인화면 색상 변경
        color = remoteConfig["splash_background"].stringValue
        
        statusBar.backgroundColor = UIColor(hex: color)
        loginButton.backgroundColor = UIColor(hex: color)
        signUp.backgroundColor = UIColor(hex: color)
        
        //로그인 버튼이 클릭되면 실행되는 메소드
        loginButton.addTarget(self, action: #selector(loginEvent), for: .touchUpInside)
        
        //사용자값이 있다면 화면을 이동하게 됨
        Auth.auth().addStateDidChangeListener { (auth, user) in
            if(user != nil){
                let view = self.storyboard?.instantiateViewController(identifier: "MainViewController") as! MainViewController
                self.present(view, animated: true, completion: nil)
            }
        }
        
        
        //signUp 버튼이 클릭되면 함수가 실행되는데 실행되는 함수는 스토리보드를 띄우는 함수, 모달로 뜨게된다
        signUp.addTarget(self, action: #selector(presentSignUp), for: .touchUpInside)
        // Do any additional setup after loading the view.
    }
    
    @objc func presentSignUp(){
        let view = self.storyboard?.instantiateViewController(withIdentifier: "SignUpViewController") as! SignUpViewController
        
        self.present(view, animated: true, completion: nil)
    }
    //로그인정보확인
    @objc func loginEvent(){
        Auth.auth().signIn(withEmail: email.text!, password: password.text!) { (user, err) in
            
            if(err != nil){
                let alert = UIAlertController(title: "에러", message: err.debugDescription, preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "확인", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
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
