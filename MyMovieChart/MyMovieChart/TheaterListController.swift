//
//  TheaterListController.swift
//  MyMovieChart
//
//  Created by 류진혁 on 2020/10/15.
//  Copyright © 2020 Jin-Hyuck. All rights reserved.
//

import UIKit

class TheaterListController : UITableViewController{
    
    //API에서 불러온 데이터를 저장할 배열, 저장할 객체타입은 NSDictionary
    var list = [NSDictionary]()
    
    var startPoint = 0
    
    @IBAction func more(_ sender: Any) {
        //self.startPoint += 20
        self.callTheaterAPI()
        self.tableView.reloadData()
        
    }
    
    override func viewDidLoad(){
        self.callTheaterAPI()
    }

    //영화관 정보 불러오는 API
    func callTheaterAPI(){
        let requestURI = "http://swiftapi.rubypaper.co.kr:2029/theater/list" //API
        let sList = 100 // 불러올 데이터 개수
        let type = "json" //데이터 형식
        
        let uriObj = URL(string: "\(requestURI)?s_page=\(self.startPoint)&s_list=\(sList)&type=\(type)")
        do{
            //euc-kr로 인코딩되어있는 API데이터를 인코딩하기 위한 과정, string형식으로 반환
            //0x80_000_422 는 euc-kr의 인코딩에 해당하는 16진수
            let stringdata = try! NSString(contentsOf: uriObj!, encoding: 0x80_000_422)
            //stringdata는 문자열 형태로 반환되기때문에 data타입으로 다시 바꾸어줌
            let encdata = stringdata.data(using: String.Encoding.utf8.rawValue)
            
            do{
                let apiArray = try JSONSerialization.jsonObject(with: encdata!, options: []) as? NSArray
                
                for obj in apiArray!{
                    self.list.append(obj as! NSDictionary)
                }
            } catch {
                let alert = UIAlertController(title: "실패", message: "데이터분석에 실패", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "확인", style: .cancel))
                    self.present(alert, animated: false)
            }
            self.startPoint += sList
        }catch{
            let alert = UIAlertController(title: "실패", message: "데이터불러오기 실패", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "확인", style: .cancel))
                self.present(alert, animated: false)
        }
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.list.count
       }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let obj = self.list[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "tCell") as! TheaterCell
        cell.name.text = obj["상영관명"] as? String
        cell.tel.text = obj["연락처"] as? String
        cell.addr.text = obj["소재지도로명주소"] as? String
        
        return cell
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "segue_map"){
            let path = self.tableView.indexPath(for: sender as! UITableViewCell)
            
            let data = self.list[path!.row]
            (segue.destination as? TheaterViewController)?.param = data
        }
    }
   
    
    
}


