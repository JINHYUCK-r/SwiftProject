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
        let color = remoteConfig["splash_background"].stringValue
        let caps = remoteConfig["splash_message_caps"].boolValue
        let message = remoteConfig["splash_message"].stringValue
        
        if(caps){
            let alert = UIAlertController(title: "금지사항", message: message, preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "확인", style: UIAlertAction.Style.default, handler: { (action) in
                exit(0)
                //경고창을 확인 누르면 앱이 꺼지게 됨
            }))
            self.present(alert, animated: true, completion: nil)
        }
        self.view.backgroundColor = UIColor(hex: color!)
           }
}

//컬러를 hex코드로 쓰기위함
extension UIColor {
    convenience init(hex: String) {
        let scanner = Scanner(string: hex)
        //1로 준 이유는 컬러코드를 입력했을때 #을 제외하고 그다음부터 읽기위함
        scanner.scanLocation = 1
        
        var rgbValue: UInt64 = 0
        
        scanner.scanHexInt64(&rgbValue)
        
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

