//
//  ListViewController.swift
//  MyMovieChart
//
//  Created by 류진혁 on 2020/10/05.
//  Copyright © 2020 Jin-Hyuck. All rights reserved.
//

import UIKit

class ListViewController: UITableViewController {
    
    var page = 1
    
    /*
    var dataset = [
        ("다크 나이트","영웅물","2008-09-04",8.95,"darknight.jpg"),
        ("호우시절","때가 좋은 비","2009-10-08",7.31,"rain.jpg"),
        ("말할수 없는 비밀","여기서 너까지 다섯걸음","2015-05-07",9.19,"secret.jpg")
        ]
 */

    lazy var list : [MovieVO] = {
        
        var datalist = [MovieVO]()
        /*
        for(title, desc, opendate, rating, thumnail) in self.dataset{
            let mvo = MovieVO()
            mvo.title = title
            mvo.description = desc
            mvo.opendate = opendate
            mvo.rating = rating
            mvo.thumnail = thumnail
            
            datalist.append(mvo)
        }
         */
        return datalist
    }()
 
    @IBOutlet weak var moreBtn: UIButton!
    
    @IBAction func more(_ sender: Any) {
        self.page += 1
        
        self.callMovieAPI()
        self.tableView.reloadData()

        
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.list.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let row = self.list[indexPath.row]
        
        /*
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListCell")!
        let title = cell.viewWithTag(101) as? UILabel
        let desc = cell.viewWithTag(102) as? UILabel
        let opendate = cell.viewWithTag(103) as? UILabel
        let rating = cell.viewWithTag(104) as? UILabel
        title?.text = row.title
        desc?.text = row.description
        opendate?.text = row.opendate
        rating?.text = "\(row.rating!)"
        */
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListCell") as! MovieCell
        cell.title.text = row.title
        cell.desc.text = row.description
        cell.opendate.text = row.opendate
        cell.rating.text = "\(row.rating!)"
        /*
        let url :URL! = URL(string: row.thumnail!)
        let imageData = try! Data(contentsOf: url)
        cell.thumnail.image = UIImage(data: imageData)
        */
        //위에것을 한줄로 적은것
        cell.thumnail.image = UIImage(data: try! Data(contentsOf: URL(string: row.thumnail!)!))
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        NSLog("선택된 행은 \(indexPath.row)입니다.")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.callMovieAPI()
        
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    func callMovieAPI(){
        
        //url을 읽어올때 오류가 발생할수도 있음.  ATS규칙때문임. info.list에서 sourcecode를 열어서 코드추가 필요
        let url = "http://swiftapi.rubypaper.co.kr:2029/hoppin/movies?version=1&page=\(self.page)&count=10&genreId=&order=releasedateasc"
        let apiURI : URL! = URL(string: url)
        
        let apidata = try! Data(contentsOf: apiURI)
        
        /*
        //데이터 전송결과를 로그에 출력(프로그램 실행과는 관련없음)
        let log = NSString(data: apidata, encoding: String.Encoding.utf8.rawValue) ?? ""
        NSLog("API result = \(log)")
        // Do any additional setup after loading the view.
        */
        
        do{
            let apiDictionary = try JSONSerialization.jsonObject(with: apidata, options: []) as! NSDictionary
            
            let hoppin = apiDictionary["hoppin"] as! NSDictionary
            let movies = hoppin["movies"] as! NSDictionary
            let movie = movies["movie"] as! NSArray
           
            
            for row in movie {
                let r = row as! NSDictionary
                let mvo = MovieVO()
                mvo.title = r["title"] as? String
                mvo.description = r["genreNames"] as? String
                mvo.thumnail = r["thumbnailImage"] as? String
                mvo.detail = r["linkUrl"] as? String
                mvo.rating = ((r["ratingAverage"] as? NSString)?.doubleValue)
                
                self.list.append(mvo)
            }
            //총 데이터 갯수를 불어옴
            let totalCount = (hoppin["totalCount"] as? NSString)!.integerValue
            //갯수가 데이터 갯수보다 크거나 같으면 버튼을 숨긴다.
                if(self.list.count >= totalCount){
                    self.moreBtn.isHidden = true
                }
        }catch{
            NSLog("Parse Error!")
        }
    }
    
    
}
