//
//  MediaRequest.swift
//  TechresOrder
//
//  Created by macmini_techres_03 on 03/02/2023.
//

import UIKit
import ObjectMapper

class MediaRequest: Mappable {
    var name : String?
    var type : Int?
    var size : Int?
    var width : Int?
    var height : Int?
    var media_id : String?
    var image : UIImage?
    var data : Data?
    var video_path: URL?
    var video_thumbnail : String?
    
    init?() {
    }
    
    required init?(map: Map) {
    }

    func mapping(map: Map) {
        name <- map["name"]
        type <- map["type"]
        size <- map["size"]
        width <- map["width"]
        height <- map["height"]
        media_id <- map["media_id"]
        image <- map["file"]
        video_path <- map["video_path"]
        video_thumbnail <- map["video_thumbnail"]
    }
    
}
struct mediass : Mappable{
    var content = ""
    var media_id = ""
    
    init?(map: Map) {
    }
    init?() {
    }
    
    mutating func mapping(map: Map) {
        content <- map["content"]
        media_id <- map["media_id"]
       
        
    }
}
