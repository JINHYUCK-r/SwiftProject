//
//  ChatModel.swift
//  Talk
//
//  Created by 류진혁 on 2020/09/18.
//  Copyright © 2020 Jin-Hyuck. All rights reserved.
//

import ObjectMapper

class ChatModel: Mappable {
    /* 1:1 채팅 모델
    @objc var uid : String?
    @objc var destinationUid : String?
     */
    
    //1대 다의 채팅 모델
        

        public var users :Dictionary<String,Bool> = [:] //채팅방에 참여한 사람들
        public var comments :Dictionary<String,Comment> = [:] //채팅방의 대화내용
        required init?(map: Map) {
            
        }
         func mapping(map: Map) {
            users <- map["users"]
            comments <- map["comments"]
        }
        public class Comment :Mappable{
            @objc public var uid : String?
            @objc public var message : String?
            public var timestamp : Int?
            public required init?(map: Map) {
                
            }
            public  func mapping(map: Map) {
               uid <- map["uid"]
               message <- map["message"]
               timestamp <- map["timestamp"]
            }
        }
        
    }
