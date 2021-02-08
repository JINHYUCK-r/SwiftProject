//
//  CSLogButton.swift
//  MyMemo
//
//  Created by 류진혁 on 2021/02/08.
//  Copyright © 2021 Jin-Hyuck. All rights reserved.
//

import UIKit
//CSButton 클래스를 사용하는 개발자가 필요한 로그 타입을 선택할수 하기 위함
public enum CSLogType : Int{
    case basic //기본 로그타입
    case title // 버튼의 타이틀을 출력
    case tag //버튼의 태그값을 출력
}

public class CSLogButton : UIButton{
    //로그 출력 타입
    public var logType : CSLogType = CSLogType.basic
    
    //스토리보드 방식으로 버튼의 인스턴스를 생성할때 초기화 메소드
    //CSLogButton 타입의 버튼을 사용하면 실행시 우리가 정의한 버튼 스타일이 적용됨
    public required init?(coder aDecoder : NSCoder) {
        super.init(coder : aDecoder)
        self.setBackgroundImage(UIImage(named: "button-bg"), for: .normal)
        self.tintColor = .white
        
        self.addTarget(self, action: #selector(logging(_:)), for: .touchUpInside)
    }
    //로그를 출력하는 메소드
    @objc func logging(_ sender : UIButton){
        switch self.logType {
        case .basic:
            NSLog("버튼이 클릭되었습니다.")
        case .title:
            //nil 병합연산자 : 연산자 앞쪽에 옵셔널 타입의 값이 nil일 경우 뒤쪽에 있는 값을 사용 
            let btnTitle = sender.titleLabel?.text ?? "타이틀 없는"
        case .tag:
            NSLog("\(sender.tag)버튼이 클릭되었습니다.")
        }
    }
    
}
