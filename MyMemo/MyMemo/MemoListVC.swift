//
//  MemoListVC.swift
//  MyMemo
//
//  Created by 류진혁 on 2021/01/09.
//  Copyright © 2021 Jin-Hyuck. All rights reserved.
//

import UIKit

class MemoListVC: UITableViewController {
    
    let appdelegate = UIApplication.shared.delegate as! AppDelegate

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let revealVC = self.revealViewController(){
            let btn = UIBarButtonItem()
            btn.image = UIImage(named: "sidemenu.png")
            btn.target = revealVC
            btn.action = #selector(revealVC.revealToggle(_:))
            self.view.addGestureRecognizer(revealVC.panGestureRecognizer())
            self.navigationItem.leftBarButtonItem = btn
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tableView.reloadData()
        
    }

    // MARK: - Table view data source

    //테이블뷰의 셀 개수를 결정
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = self.appdelegate.memolist.count
        return count
    }
    //테이블뷰 개별행을 어떻게 구성할것인가 
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //memolist 배열에서 주어진 행에 맞는 데이터를 꺼낸다 
        let row = self.appdelegate.memolist[indexPath.row]
        //이미지 유무에 따라 셀아이디를 지정
        let cellId = row.image == nil ? "memoCell" : "memoCellWithImage"
        //재사용 큐
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId) as! MemoCell
        cell.subject?.text = row.title
        cell.content?.text = row.contents
        cell.img?.image = row.image
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        cell.regdate.text = formatter.string(from: row.regdate!)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       let row = self.appdelegate.memolist[indexPath.row]
       
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "MemoRead") as? MemoReadVC else {
            return
        }
        vc.param = row
        self.navigationController?.pushViewController(vc, animated: true)
    }


}
