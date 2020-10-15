//
//  TheaterViewController.swift
//  MyMovieChart
//
//  Created by 류진혁 on 2020/10/15.
//  Copyright © 2020 Jin-Hyuck. All rights reserved.
//

import UIKit
import MapKit

class TheaterViewController: UIViewController {
    //영화관 목록에서 사용자가 선택한 값을 전달받을 변수
    var param : NSDictionary!

    @IBOutlet weak var map: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = self.param["상영관명"] as? String
        // Do any additional setup after loading the view.
        //param에서 위도와 경도 정보를 추출하여 double로 캐스팅, NSString객체는 doubleValue속성이있음
        let lat = (param?["위도"] as! NSString).doubleValue
        let lng = (param?["경도"] as! NSString).doubleValue
        //위도경도로 위치정보객체정의
        let location = CLLocationCoordinate2D(latitude: lat, longitude: lng)
        //지도에 표현될 거리, 축척의 역할 1:100의비율, 값이클수록 축척이 작아지고 더 넓은 범위표시
        let regionRadius : CLLocationDistance = 100
        //거리를 반영한 지역정보데이터, 경도위도를 통한 중심위치와 축척을통한 지도 객체 객성
        let cordinateRegion = MKCoordinateRegion(center: location, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        //지도표시
        self.map.setRegion(cordinateRegion, animated: true)
        
        let point = MKPointAnnotation()
        point.coordinate = location
        self.map.addAnnotation(point)
        
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
