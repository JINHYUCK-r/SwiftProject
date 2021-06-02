//
//  SideBarVC.swift
//  MyMemo
//
//  Created by 류진혁 on 2021/05/31.
//  Copyright © 2021 Jin-Hyuck. All rights reserved.
//

import UIKit

class SideBarVC : UITableViewController{
    let titles = ["새글 작성하기" ,"친구 새글","달력으로 보기","공지사항","통계","계정 관리"]
    
    let icons = [UIImage(named: "icon01.png"),UIImage(named: "icon02.png"),UIImage(named: "icon03.png"),UIImage(named: "icon04.png"),UIImage(named: "icon05.png"),UIImage(named: "icon06.png")]
    
    let nameLabel = UILabel()
    let emailLabel = UILabel()
    let profileImage = UIImageView()
    
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.titles.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let id = "menucell"
        let cell = tableView.dequeueReusableCell(withIdentifier: id) ?? UITableViewCell(style: .default, reuseIdentifier: id)
        cell.textLabel?.text = self.titles[indexPath.row]
        cell.imageView?.image = self.icons[indexPath.row]
        
        cell.textLabel?.font = UIFont.systemFont(ofSize: 14)
        return cell
    }
    
    override func viewDidLoad() {
        let headerview = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 70))
        headerview.backgroundColor = .brown
        self.tableView.tableHeaderView = headerview
        
        self.nameLabel.frame = CGRect(x: 70, y: 15, width: 100, height: 30)
        self.nameLabel.text = "이름이름"
        self.nameLabel.textColor = .white
        self.nameLabel.font = UIFont.boldSystemFont(ofSize: 15)
        self.nameLabel.backgroundColor = .clear
        headerview.addSubview(self.nameLabel)
        
        self.emailLabel.frame = CGRect(x: 70, y: 30, width: 100, height: 30)
        self.emailLabel.text = "email@email.com"
        self.emailLabel.textColor = .white
        self.emailLabel.font = UIFont.boldSystemFont(ofSize: 11)
        self.emailLabel.backgroundColor = .clear
        headerview.addSubview(self.emailLabel)
        
        let defaulImage = UIImage(named: "account.jpg")
        self.profileImage.image = defaulImage
        self.profileImage.frame = CGRect(x: 10, y: 10, width: 50, height: 50)
        
        self.profileImage.layer.cornerRadius = (self.profileImage.frame.width/2)
        self.profileImage.layer.borderWidth = 0
        self.profileImage.layer.masksToBounds = true // 기존의 이미지위에 덧씌워서 일부를 가리는 역할을 하는 레리어
        
        headerview.addSubview(self.profileImage)
    }
    
}
