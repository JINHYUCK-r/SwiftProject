//
//  AccountViewController.swift
//  Talk
//
//  Created by 류진혁 on 2020/09/24.
//  Copyright © 2020 Jin-Hyuck. All rights reserved.
//

import UIKit
import Firebase

class AccountViewController: UIViewController {

    @IBOutlet weak var conditionsCommentButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        conditionsCommentButton.addTarget(self, action: #selector(showAlert), for: .touchUpInside)

        // Do any additional setup after loading the view.
    }
    
    @objc func showAlert(){
        let alertController = UIAlertController(title: "상태 메세지", message: nil, preferredStyle: UIAlertController.Style.alert)
        alertController.addTextField { (textfield) in
            textfield.placeholder = "상태메세지를 입력새주세요"
        }
        alertController.addAction(UIAlertAction(title: "확인", style: .default, handler: { (action) in
            if let textfield = alertController.textFields?.first{
                let dic = ["comment":textfield.text!]
                let uid = Auth.auth().currentUser?.uid
                Database.database().reference().child("users").child(uid!).updateChildValues(dic)
                
            }
            
        }))
        alertController.addAction(UIAlertAction(title: "취소", style: .cancel, handler: { (action) in
            
        }))
        self.present(alertController, animated: true, completion: nil)
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
