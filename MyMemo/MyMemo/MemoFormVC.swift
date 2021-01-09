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
        
        //내용을 입력하지않으면 경고창
        guard self.content.text?.isEmpty == false else{
            let alert = UIAlertController(title: nil, message: "내용을 입력해주세요", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
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
    
    
    
}
