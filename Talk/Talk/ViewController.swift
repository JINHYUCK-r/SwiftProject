//
//  ViewController.swift
//  Talk
//
//  Created by 류진혁 on 2020/09/14.
//  Copyright © 2020 Jin-Hyuck. All rights reserved.
//

import UIKit
import SnapKit
import Firebase

class ViewController: UIViewController {
    
    var box = UIImageView()
    var remoteConfig : RemoteConfig!

    override func viewDidLoad() {
        super.viewDidLoad()
        //https://firebase.google.com/docs/remote-config/use-config-ios
        //싱글톤 원격 구성 객체
        remoteConfig = RemoteConfig.remoteConfig()
        let settings = RemoteConfigSettings()
        settings.minimumFetchInterval = 0
        remoteConfig.configSettings = settings
        
        //서버랑 연결이 안될경우 사용됨
        remoteConfig.setDefaults(fromPlist: "RemoteConfigDefaults")
        //서버값 받는부분
        remoteConfig.fetch() { (status, error) -> Void in
          if status == .success {
            print("Config fetched!")
            self.remoteConfig.activate() { (changed, error) in
              // ...
            }
          } else {
            print("Config not fetched")
            print("Error: \(error?.localizedDescription ?? "No error available.")")
          }
          self.displayWelcome()
        }

        
       
        
        self.view.addSubview(box)
        box.snp.makeConstraints { (make) in
            make.center.equalTo(self.view)
        }
        box.image = #imageLiteral(resourceName: "loading_icon")
        //self.view.backgroundColor = UIColor(hex: "#000000")
        
    }

    func displayWelcome(){
        //파이어베이스에 설정해놓은 값을 받음
        let color = remoteConfig["splash_background"].stringValue //#031CA6
        let caps = remoteConfig["splash_message_caps"].boolValue //false
        let message = remoteConfig["splash_message"].stringValue //서버점검중
        
        //firebase에서 caps의 기본값이 true면 앱이 꺼지는 if 문이 실행되어버림
        if(caps){
            let alert = UIAlertController(title: "금지사항", message: message, preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "확인", style: UIAlertAction.Style.default, handler: { (action) in
                exit(0)
                //경고창을 확인 누르면 앱이 꺼지게 됨
            }))
            self.present(alert, animated: true, completion: nil)
        }else{
            //연결하고자하는 컨트롤러뷰의 아이텐셜 아이값을 입력하면 모달형식으로 화면이 뜬다
            let loginVC = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
            self.present(loginVC, animated: false, completion: nil)
        }
        self.view.backgroundColor = UIColor(hex: color!)
           }
}

//https://rushndash.tistory.com/90
//컬러를 hex코드로 쓰기위함
extension UIColor {
    convenience init(hex: String) {
        let scanner = Scanner(string: hex)
        //1로 준 이유는 컬러코드를 입력했을때 #을 제외하고 그다음부터 읽기위함
        scanner.scanLocation = 1
        
        var rgbValue: UInt64 = 0
        
        scanner.scanHexInt64(&rgbValue)
        
        //비트연산자
        let r = (rgbValue & 0xff0000) >> 16
        let g = (rgbValue & 0xff00) >> 8
        let b = rgbValue & 0xff
        
        self.init(
            red: CGFloat(r) / 0xff,
            green: CGFloat(g) / 0xff,
            blue: CGFloat(b) / 0xff, alpha: 1
        )
    }
}

