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

    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var wv: WKWebView!
    
    var mvo : MovieVO!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       // NSLog("linkurl = \(self.mvo.detail!), title=\(self.mvo.title!)")
        
        self.wv.navigationDelegate = self
        
        
        let navibar = self.navigationItem
        navibar.title = self.mvo.title
        /*
        let url = URL(string: self.mvo.detail!)
        let req = URLRequest(url: url!)
        
        self.wv.load(req)
        */
        if let url = self.mvo.detail{
            if let urlObj = URL(string: url){
                let req = URLRequest(url: urlObj)
                self.wv.load(req)
            //url형식 잘못되었을경우
            }else{
                let alert = UIAlertController(title: "오류", message: "잘못된 url", preferredStyle: .alert)
                let cancleAction = UIAlertAction(title: "확인", style: .cancel) { (_) in
                    //경고창 이전화면으로 되돌림
                    _ = self.navigationController?.popViewController(animated: true)
                    }
                    alert.addAction(cancleAction)
                    self.present(alert, animated: true)
                
            }
            
            
        //url값이 전달되지 않았을경우 예외처리
        }else{
            let alert = UIAlertController(title: "오류", message: "필수 파라미터 누락", preferredStyle: .alert)
            let cancleAction = UIAlertAction(title: "확인", style: .cancel) { (_) in
                _ = self.navigationController?.popViewController(animated: true)
            }
            alert.addAction(cancleAction)
            self.present(alert, animated: true)
        }
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
// MARK: - WKNavigationDelegate 프로토콜 구현
extension DetailViewController : WKNavigationDelegate{
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        self.spinner.startAnimating()
    }
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.spinner.stopAnimating()
    }
    //웹페이지 로딩에 실패하였을때 사용됨
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        self.spinner.stopAnimating()
        //extenstion으로 정의해놓은 함수사용
        self.alert("상세페이지를 읽어오지못했습니다.")
        //버튼클릭시 이전화면으로 되돌려보낸다
        _ = self.navigationController?.popViewController(animated: true)
        /*경고창띄우기
        let alert = UIAlertController(title: "오류", message: "페이지를 읽어오지 못함", preferredStyle: .alert)
        let cancleAction = UIAlertAction(title: "확인", style: .cancel) { (_) in
            _ = self.navigationController?.popViewController(animated: true)
        }
        alert.addAction(cancleAction)
        self.present(alert, animated: true)
        */
    }
    //네트워크나 Url오류시 사용됨
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        self.spinner.stopAnimating()
        self.alert("상세페이지를 읽어오지 못했습니다.")
        _ = self.navigationController?.popViewController(animated: true)
    }

}

//MARK:-심플한 경고창 함수 정의용 익스텐션
//Uiviewcontroller에 대한 확장이기때문에 이 클래스를 상속받는 모든 뷰 클래스에서 사용가느
extension UIViewController{
    func alert (_ message: String, onclick: (() -> Void)? = nil) {
        let controller = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        controller.addAction(UIAlertAction(title: "OK", style: .cancel) { (_) in
            onclick?()
        })
        DispatchQueue.main.async {
            self.present(controller, animated: true)
        }
    }
}
