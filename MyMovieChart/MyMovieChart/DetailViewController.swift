//
//  DetailViewController.swift
//  MyMovieChart
//
//  Created by 류진혁 on 2020/10/13.
//  Copyright © 2020 Jin-Hyuck. All rights reserved.
//

import UIKit
import WebKit



class DetailViewController: UIViewController {

    @IBOutlet weak var wv: WKWebView!
    
    var mvo : MovieVO!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NSLog("linkurl = \(self.mvo.detail!), title=\(self.mvo.title!)")
        
        let navibar = self.navigationItem
        navibar.title = self.mvo.title
        
        let url = URL(string: self.mvo.detail!)
        let req = URLRequest(url: url!)
        
        self.wv.load(req)

        // Do any additional setup after loading the view.
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
