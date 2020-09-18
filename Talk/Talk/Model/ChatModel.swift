//
//  ChatModel.swift
//  Talk
//
//  Created by 류진혁 on 2020/09/18.
//  Copyright © 2020 Jin-Hyuck. All rights reserved.
//

import UIKit

class ChatModel: NSObject {
    /* 1:1 채팅 모델
    @objc var uid : String?
    @objc var destinationUid : String?
     */
    
    //1대 다의 채팅 모델
    public var users : Dictionary<String,Bool> = [:] //채팅방에 참여한 사람들
    public var comments : Dictionary<String,Comment> = [:] // 채팅방의 대화 내용
    
    public class Comment{
        @objc public var uid : String?
        @objc public var message : String?
    }
}
