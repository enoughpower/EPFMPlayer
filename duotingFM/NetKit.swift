//
//  NetKit.swift
//  duotingFM
//
//  Created by enoughpower on 16/6/16.
//  Copyright © 2016年 enoughpower. All rights reserved.
//

import UIKit
import AFNetworking

//一级分类接口
private let mainCategoryUrl: String = "http://api.duotin.com/category"
//主页接口
private let mainUrl: String = "http://api.duotin.com/outRecommend/album"
//专辑接口
private let albumUrl: String = "http://api.duotin.com/outRecommend/content"


class NetKit: NSObject {
    /**一级分类 */
    static func requestWithMainCategory(response: (success:Bool, dataArr:[CategoryModel]?) -> Void) {
        let dic = [
            "device_key": getUUID()!+"-duotinfm",
            "package": "360ertonggushi",
            "platform": "iOS",
            "version": "2.9.1"
        ]
        requestWithUrl(mainCategoryUrl, param: dic) { (success, dataDic) in
            if success {
                let array = dataDic!["data"] as! [AnyObject]
                var dataList:[CategoryModel] = []
                for value in array{
                    let categoryModel : CategoryModel = CategoryModel()
                    categoryModel.setValuesForKeysWithDictionary(value as! [String : AnyObject])
                    dataList.append(categoryModel)
                }
                response(success: true, dataArr: dataList)
            }else {
                response(success: false, dataArr: nil)
            }
        }
    }
    
    /**主页*/
    static func requestWithMain(page: Int, response: (success:Bool, dataArr:[AlbumModel]?) -> Void) {
        let dic = [
            "page": "\(page)",
            "pageSize": "24",
        ]
        requestWithUrl(mainUrl, param: dic) { (success, dataDic) in
            if success {
                let dic = dataDic!["data"] as! [String:AnyObject]
                let arr = dic["albums"] as! [AnyObject]
                var dataList:[AlbumModel] = []
                for value in arr{
                    let albumModel : AlbumModel = AlbumModel()
                    albumModel.setValuesForKeysWithDictionary(value as! [String : AnyObject])
                    dataList.append(albumModel)
                }
                response(success: true, dataArr: dataList)
            }else {
                response(success: false, dataArr: nil)
            }
        }
    }
    /**专辑*/
    static func requestWithAlbum(id: Int, page: Int, response: (success:Bool, dataArr:[ContentModel]?) -> Void) {
        let dic = [
            "page": "\(page)",
            "pageSize": "20",
            "albumId": "\(id)"
            ]
        requestWithUrl(albumUrl, param: dic) { (success, dataDic) in
            if success {
                let dic = dataDic!["data"] as! [String:AnyObject]
                let arr = dic["contents"] as! [AnyObject]
                var dataList:[ContentModel] = []
                for value in arr{
                    let contentModel : ContentModel = ContentModel()
                    contentModel.setValuesForKeysWithDictionary(value as! [String : AnyObject])
                    dataList.append(contentModel)
                }
                response(success: true, dataArr: dataList)
            }else {
                response(success: false, dataArr: nil)
            }
        }
    }
    
    
    
    
    // MARK: - Tools
    private static func getUUID() ->String?{
        let string = UIDevice.currentDevice().identifierForVendor?.UUIDString
        return string
    }
    private static func requestWithUrl(url: String,param: [String: String]?, response: (success:Bool, dataDic:[String: AnyObject]?) -> Void) {
        let httpManager = AFHTTPSessionManager()
        httpManager.GET(url, parameters: param, progress: nil, success: { (_, data) in
            let mainDic = data as! [String:AnyObject]
            response(success: true, dataDic: mainDic)
        }) { (_, error) in
            response(success: false, dataDic: nil)
            print(error)
        }
        
    }
}
