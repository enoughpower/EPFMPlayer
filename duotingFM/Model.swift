//
//  Model.swift
//  duotingFM
//
//  Created by enoughpower on 16/6/16.
//  Copyright © 2016年 enoughpower. All rights reserved.
//

import UIKit

class CategoryModel: NSObject {
    var id = 0
    var image_url = ""
    var title = ""
    
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        
    }

}
class AlbumModel: NSObject {
    var id = 0
    var name = ""
    var category = ""
    var subCategory = ""
    var contentCount = 0
    var img = ""
    var Description = ""
    var user = ""
    var createDate = ""
    var updateDate = ""
    var playCount = 0
    var tags = [AnyObject]()
    
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
    }
    override func setValue(value: AnyObject?, forKeyPath keyPath: String) {
        if keyPath == "description" {
            Description =  "\(value)"
        }
    }
}

class ContentModel: NSObject {
    var id = 0
    var name = ""
    var category = ""
    var subCategory = ""
    var contentCount = 0
    var img = ""
    var Description = ""
    var user = ""
    var createDate = ""
    var updateDate = ""
    var playCount = 0
    var tags = [AnyObject]()
    var isStar = ""
    var duration = 0
    var size = 0
    var url = ""
    override func setValue(value: AnyObject?, forKeyPath keyPath: String) {
        if keyPath == "description" {
            Description =  "\(value)"
        }
    }
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
    }
}








