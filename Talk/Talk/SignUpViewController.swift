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
import FirebaseStorage

class SignUpViewController: UIViewController,UINavigationControllerDelegate,UIImagePickerControllerDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    
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
        
        //이미지뷰가 클릭될때 실행될 메소드
        //info에 가서 사진을 권한을 받아야함
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(imagePicker)))
        
        
        // Do any additional setup after loading the view.
        signUp.backgroundColor = UIColor(hex: color)
        cancel.backgroundColor = UIColor(hex: color)
        
        signUp.addTarget(self, action: #selector(signUpEvent), for: .touchUpInside)
        cancel.addTarget(self, action: #selector(cancelEvent), for: .touchUpInside)
    }
    
    //선택된 이미지가 이미지 뷰에 담기게 됨
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        imageView.image = info[.originalImage] as? UIImage
        
        dismiss(animated: true, completion: nil)
    }
    //이 메소드가 실행되면 앨범이 열린다.
    @objc func imagePicker(){
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
        
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    //회원가입정보 firebase에 등록하는 메소드
    @objc  func signUpEvent(){
           Auth.auth().createUser(withEmail: email.text!, password: password.text!) { (user, err) in
            let uid = user?.user.uid
            
            //이미지를 firebase에 등록
             let image = self.imageView.image?.jpegData(compressionQuality: 0.1)

             let imageRef = Storage.storage().reference().child("userImages").child(uid!)

             imageRef.putData(image!, metadata: nil, completion: {(StorageMetadata, Error) in

                 imageRef.downloadURL(completion: { (url, err) in

                     Database.database().reference().child("users").child(uid!).setValue(["userName":self.name.text,"profileImageUrl":url?.absoluteString])
                    
                    self.dismiss(animated: true, completion: nil)

                 })

             })
               
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
