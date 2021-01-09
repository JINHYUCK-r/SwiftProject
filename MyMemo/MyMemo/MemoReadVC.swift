//
//  MemoReadVC.swift
//  MyMemo
//
//  Created by 류진혁 on 2021/01/09.
//  Copyright © 2021 Jin-Hyuck. All rights reserved.
//

import UIKit

class MemoReadVC: UIViewController {

    //콘텐츠 데이터를 저장하는 변수
    var param : MemoData?
    
    @IBOutlet weak var subject: UILabel!
    
    @IBOutlet weak var content: UILabel!
    
    @IBOutlet weak var img: UIImageView!
   
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.subject.text = param?.title
        self.content.text = param?.contents
        self.img.image = param?.image
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd일 HH:mm분에 작성됨"
        let dateString = formatter.string(from: (param?.regdate)!)
        
        self.navigationItem.title = dateString
    }
    


}
