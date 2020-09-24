//
//  MainViewController.swift
//  Talk
//
//  Created by 류진혁 on 2020/09/16.
//  Copyright © 2020 Jin-Hyuck. All rights reserved.
//

import UIKit
import SnapKit
import Firebase
import Kingfisher


class PeopleViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
   
    //userModel을 받아서 배열로 만듬
    var array : [UserModel] = []
    var tableView : UITableView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        //테이블뷰에 테이블뷰 셀을 등록
        tableView.register(PeopleViewTableCell.self, forCellReuseIdentifier: "Cell")
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (m) in
            m.top.equalTo(view)
            m.bottom.left.right.equalTo(view)
        }

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
                self.tableView.reloadData()
            }
            
        }
        
        
        // Do any additional setup after loading the view.
    }
    //테이블 생성
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return array.count
       }
       
    
       func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell",for: indexPath) as! PeopleViewTableCell
        let imageView = cell.imageview!

        imageView.snp.makeConstraints { (m) in
            m.centerY.equalTo(cell)
            m.left.equalTo(cell).offset(10)
            m.height.width.equalTo(50)
        }
        let url = URL(string: array[indexPath.row].profileImageUrl!)
        imageView.layer.cornerRadius = 50/2
        imageView.clipsToBounds = true
        imageView.kf.setImage(with: url)
       //프로필 이미지가 저장되어 있는 url주소를 받아서와 이미지 데이터로 보여줌
        /*
        URLSession.shared.dataTask(with:  URL(string: array[indexPath.row].profileImageUrl!)!) { (data, response, err) in
            DispatchQueue.main.async {
                imageView.image = UIImage(data: data!)
                imageView.layer.cornerRadius = imageView.frame.size.width/2
                imageView.clipsToBounds = true
            }
        } .resume()
 */
        let label = cell.label!
        //셀에 라벨추가

        //라벨 위치 설정
        label.snp.makeConstraints { (m) in
            m.centerY.equalTo(cell)
            m.left.equalTo(imageView.snp.right).offset(20)
            
        }
        //userName등록
        label.text = array[indexPath.row].userName
          return cell
       }
    
    //셀의 높이 설정
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    //테이블의 셀이 선택되면
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let view = self.storyboard?.instantiateViewController(identifier: "ChatViewController") as? ChatViewController
        //각 채팅대상의 셀을 선택하면 uid를 선택해서 정보를 뽑아냄
        //그리고 ChatviewContoller에 String이 담기게 됨
        view?.destinationUid = self.array[indexPath.row].uid
        self.navigationController?.pushViewController(view!, animated: true)
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

//셀을 재사용하여 메모리 낭비를 막음
class PeopleViewTableCell :UITableViewCell{
    
    var imageview :UIImageView! = UIImageView()
    var label :UILabel! = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.addSubview(imageview)
        self.addSubview(label)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
