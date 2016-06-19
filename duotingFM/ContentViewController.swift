//
//  ContentViewController.swift
//  duotingFM
//
//  Created by enoughpower on 16/6/18.
//  Copyright © 2016年 enoughpower. All rights reserved.
//

import UIKit
import MJRefresh

class ContentViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource, LocalMusicPlayerToolDelegate {
    private lazy var contentsArr: [ContentModel] = {
        return []
    }()
    private lazy var musicManager: LocalMusicPlayerTool = {
        let manager = LocalMusicPlayerTool.shareMusicPlay()
        return manager
    }()
    
    private var currentPage: Int = 1
    private var currentIndex: Int = 0
    private var headerHeight: CGFloat {
        return self.view.bounds.size.width * 3/5
    }
    var albuminfo: AlbumModel!
    private var tableView: UITableView!
    private var header: ContentHeader!
    private var scale: CGFloat!
    private var alpha: CGFloat = 0
  
    deinit {
        self.musicManager.delegate = nil
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        let color = UIColor(255, green: 100, blue: 78)
        self.navigationController!.navigationBar.cnSetBackgroundColor(color.colorWithAlphaComponent(alpha))
        self.musicManager.delegate = self
        if (contentsArr.count > 0) {
            let indexPath = NSIndexPath(forRow: self.musicManager.currentItem, inSection: 0)
            self.tableView.selectRowAtIndexPath(indexPath, animated: true, scrollPosition: .None)
        }
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
    
    private func initUI() {
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
 
    private func initData() {
        self.networkManager.setReachabilityStatusChangeBlock { [unowned self] (status) in
            switch(status) {
            case .NotReachable, .Unknown:
                print("无网络")
                let alert = UIAlertController(title: "提示", message: "请检查网络是否连接", preferredStyle: .Alert)
                alert.addAction(UIAlertAction(title: "我知道了", style: .Cancel, handler: { (action) in
                    
                }))
                self.presentViewController(alert, animated: true, completion: nil)
            case .ReachableViaWiFi, .ReachableViaWWAN:
                print("有网络")
                let mjrefresh = MJRefreshAutoNormalFooter(refreshingBlock: {
                    self.currentPage += 1
                    self.loadDataWithIndex(index: self.currentPage)
                })
                self.tableView.mj_footer = mjrefresh;
                self.loadDataWithIndex(index: self.currentPage)
            }
        }
    }
    private func loadDataWithIndex(index index: Int) {
        NetKit.requestWithAlbum(albuminfo.id, page: index, response: { (success, dataArr) in
            if success {
                self.contentsArr += dataArr!
                dispatch_async(dispatch_get_main_queue(), {
                    self.tableView.reloadData()
                    self.addToMusicList(self.contentsArr)
                    if self.contentsArr.count < 10 {
                        self.tableView.mj_footer.hidden = true
                    }
                    if !self.contentsArr.isEmpty {
                        let app = UIApplication.sharedApplication().delegate as! AppDelegate
                        app.bottonBar.hidden = false
                    }
                    self.tableView.mj_footer.endRefreshing()
                })
            } else {
                print("无网络")
            }
        })
    }
    // 获取音乐
    private func addToMusicList(arrList: [ContentModel]) {
        var dataArray = [MusicInfoModel]()
        if (self.currentPage == 1) {
            self.currentIndex = 0;
        }else {
            self.currentIndex = self.musicManager.currentItem;
        }
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
            self.musicManager.MusicList = dataArray;
            if self.currentPage == 1 {
                self.musicManager.playWithIndex(self.currentIndex)
            }
        }
    }
    // MARK: - tableViewDataSource
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(ContentReuseIdentifier, forIndexPath: indexPath) as! ContentCell
        cell.selectionStyle = .None
        let model: ContentModel = contentsArr[indexPath.row]
        cell.passInfo(model)
        return cell
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contentsArr.count
    }
    //MARK: - tableviewDelegate
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        self.musicManager.playWithIndex(indexPath.row)

    }
    
    // MARK: -scrollViewDelegate
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if let vc = self.navigationController?.visibleViewController {
            if vc.isKindOfClass(ContentViewController.self) {
                
                let color = UIColor(255, green: 100, blue: 78)
                let offsetY = scrollView.contentOffset.y;
                if (offsetY >= 0) {
                    alpha = min(1, b: offsetY/300)
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
    private func min(a:CGFloat, b:CGFloat) -> CGFloat{
        return a > b ? b: a
    }
    //MARK: - musicPlayDelegate
    func musicDidChangeSong(itemIndex: Int, musicInfo info: MusicInfoModel!) {
        self.tableView.selectRowAtIndexPath(NSIndexPath.init(forRow: itemIndex, inSection: 0), animated: true, scrollPosition: .None)
        
        
    }
    
    
}
