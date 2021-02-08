//
//  MemoFormVC.swift
//  MyMemo
//
//  Created by 류진혁 on 2021/01/09.
//  Copyright © 2021 Jin-Hyuck. All rights reserved.
//

import UIKit

class MemoFormVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate,UITextViewDelegate {
    
    var subject : String!

    @IBOutlet weak var content: UITextView!
    
    @IBOutlet weak var preview: UIImageView!
    
    
    @IBAction func save(_ sender: Any) {
        //경고창에 넣을 이미지생성
        let alertV = UIViewController()
        let iconImage = UIImage(named: "warning-icon-60.png")
        alertV.view = UIImageView(image: iconImage)
        alertV.preferredContentSize = iconImage?.size ?? CGSize.zero
        
        
        //내용을 입력하지않으면 경고창
        guard self.content.text?.isEmpty == false else{
            let alert = UIAlertController(title: nil, message: "내용을 입력해주세요", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            //경고창에 이미지 추가
            alert.setValue(alertV, forKey: "contentViewController")
            self.present(alert, animated: true)
            return
        }
        
        //MemoData객체를 생성하고 내용을 담음
        let data = MemoData()
        
        data.title = self.subject
        data.contents = self.content.text
        data.image = self.preview.image
        data.regdate = Date()
        
        //앱딜리게이트 객체를 불러와서 memolist에 data에 적힌 내용을 담음
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.memolist.append(data)
        
        //이전 화면으로 되돌아감
        _ = self.navigationController?.popViewController(animated: true)
        
    }
    
    @IBAction func pick(_ sender: Any) {
        
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        
        self.present(picker, animated: false)
        
    }
    override func viewDidLoad() {
        self.content.delegate = self
        
        let bgImage = UIImage(named: "memo-background.png")!
        self.view.backgroundColor = UIColor(patternImage: bgImage)
        
        self.content.layer.borderWidth = 0
        //uicolor.clear = 색상이 없는 빈공간 만들기
        self.content.layer.borderColor = UIColor.clear.cgColor
        self.content.backgroundColor = UIColor.clear
        
        let style = NSMutableParagraphStyle()
        //줄 간격 설정
        style.lineSpacing = 9
        //paragraphStyle : 문단 스타일 정의
        self.content.attributedText = NSAttributedString(string: "", attributes: [.paragraphStyle : style])
    }
    
    //사용자가 이미지를 선택하면 메소드가 호출됨
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        //선택된 이미지를 미리보기에 추가
        self.preview.image = info[.editedImage] as? UIImage
        //이미지 피커 컨트롤러 닫기
        picker.dismiss(animated: false)
    }
    
    //텍스트뷰의 내용이 변경되면 호출되는 함수
    func textViewDidChange(_ textView: UITextView) {
        let contents = textView.text as NSString
        //최대 15글자 까지 읽어와서 내용을 담음
        let length = ((contents.length > 15) ? 15 : contents.length)
        self.subject = contents.substring(with: NSRange(location: 0, length: length))
        
        self.navigationItem.title = self.subject
    }
    
    //화면을 터치시 네비게이션바가 사라졌다가 나타났다가 함. 단, 텍스트뷰를 선택시에는 안사라짐
    //스토리보드의 네비게이션컨트롤러의 hide bars를 통해서도 구현할수 있음. 단 효과를 넣거나 할수는 없음
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let bar = self.navigationController?.navigationBar
        let ts = TimeInterval(0.3)
        UIView.animate(withDuration: ts){
            bar?.alpha = (bar?.alpha == 0 ? 1 : 0)
        }
    }
    
}
