//
//  ContentViewController.swift
//  duotingFM
//
//  Created by enoughpower on 16/6/18.
//  Copyright © 2016年 enoughpower. All rights reserved.
//

import UIKit

class ContentViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    private lazy var contentsArr: [ContentModel] = {
        return []
    }()
    private var headerHeight: CGFloat {
        return self.view.bounds.size.width * 3/5
    }
    var albuminfo: AlbumModel!
    private var tableView: UITableView!
    private var header: ContentHeader!
    private var scale: CGFloat!
  
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        let color = UIColor(255, green: 100, blue: 78)
        self.navigationController!.navigationBar.cnSetBackgroundColor(color.colorWithAlphaComponent(0))
//        self.navigationController!.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: .Default)
//        self.navigationController!.navigationBar.shadowImage = UIImage()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        self.tableView.registerClass(ContentCell.self, forCellReuseIdentifier: ContentReuseIdentifier)
        //设置cell的估计高度
        self.tableView.estimatedRowHeight = 44;
        //iOS以后这句话是默认的，所以可以省略这句话
        self.tableView.rowHeight = UITableViewAutomaticDimension;
        self.tableView.separatorStyle = .None;
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        initData()
    }
    
    func initUI() {
        let bounds = CGRectMake(0, 0, self.view.bounds.size.width, self.headerHeight);
        self.automaticallyAdjustsScrollViewInsets = false;
        self.navigationItem.title = albuminfo.name;
        tableView = UITableView(frame: self.view.bounds, style: .Plain)
        header = ContentHeader(frame: CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.width*3/5))
        header.albumInfo = albuminfo;
        header.layer.masksToBounds = true;
    
        tableView.backgroundColor = UIColor.whiteColor()
        self.view.addSubview(tableView)
        
        let headerView = UIView(frame: bounds)
        headerView.addSubview(self.header)
        tableView.tableHeaderView = headerView
    }
    
    func initData() {
        NetKit.requestWithAlbum(albuminfo.id, page: 1, response: { (success, dataArr) in
            if success {
                self.contentsArr = dataArr!
                dispatch_async(dispatch_get_main_queue(), {
                    self.tableView.reloadData()
                    self.addToMusicList(self.contentsArr)
                })
            } else {
                print("无网络")
            }
        })
    }
    // 获取音乐
    
    func addToMusicList(arrList: [ContentModel]) {
        let manager = LocalMusicPlayerTool.shareMusicPlay()
        var dataArray = [MusicInfoModel]()
//        if (self.currentIndex == 1) {
//            self.songsItem = 0;
//        }else {
//            self.songsItem = self.musicManager.currentItem;
//        }
        
        
        for info in arrList {
            if (info.url != "" && info.name != "") {
                var imageUrl = NSURL.init(string: self.albuminfo.img)
                if (info.img != "") {
                    imageUrl = NSURL.init(string: info.img)
                }
                var artist = self.albuminfo.user;
                if (info.user != "") {
                    artist = info.user;
                }
                let model = MusicInfoModel(fileName: info.name, songName: info.name, songArtist: artist, urlStr: NSURL.init(string: info.url), imageUrl: imageUrl)
                dataArray.append(model)
                
            }
        }
        if (dataArray.count > 0) {
            manager.MusicList = dataArray;
            manager.playWithIndex(0)
        }
    }
    // MARK: - tableViewDataSource
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(ContentReuseIdentifier, forIndexPath: indexPath) as! ContentCell
        let model: ContentModel = contentsArr[indexPath.row]
        cell.passInfo(model)
        return cell
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contentsArr.count
    }
    
    // MARK: -scrollViewDelegate
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if let vc = self.navigationController?.visibleViewController {
            if vc.isKindOfClass(ContentViewController.self) {
                
                let color = UIColor(255, green: 100, blue: 78)
                let offsetY = scrollView.contentOffset.y;
                if (offsetY >= 0) {
                    let alpha = min(1, b: offsetY/300)
                    self.navigationController!.navigationBar.cnSetBackgroundColor(color.colorWithAlphaComponent(alpha))
                } else {
                    self.navigationController!.navigationBar.cnSetBackgroundColor(color.colorWithAlphaComponent(0))
                    let add_topHeight = -offsetY
                    self.scale = (self.headerHeight+add_topHeight)/self.headerHeight;
                    //改变 frame
                    let contentView_frame = CGRectMake(0, -add_topHeight, self.view.frame.size.width, self.headerHeight+add_topHeight);
                    self.header.frame = contentView_frame;
                }
            }
        }
    }
    func min(a:CGFloat, b:CGFloat) -> CGFloat{
        return a > b ? b: a
    }
    
}
