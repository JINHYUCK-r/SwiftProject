//
//  UserModel.swift
//  Talk
//
//  Created by 류진혁 on 2020/09/17.
//  Copyright © 2020 Jin-Hyuck. All rights reserved.
//

import UIKit

//데이터베이스에 담겨있는 정보를 담아내기위함
class UserModel: NSObject {

    @objc var profileImageUrl : String?
    @objc var userName : String?
    //채팅방을 사용할때 사용될 uid
    @objc var uid : String?
    
    
}
