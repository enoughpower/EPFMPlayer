//
//  AppDelegate.swift
//  duotingFM
//
//  Created by enoughpower on 16/6/16.
//  Copyright © 2016年 enoughpower. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    lazy var viewControllers:[AnyObject]! = {
        return [
        MainViewController.self,
        CategoryViewController.self
        ]
    }()
    lazy var titles:[AnyObject]! = {
        return [
            "主页",
            "分类"
        ]
    }()
    lazy var mainController:WMPageController! = {
        var indexVC = WMPageController(viewControllerClasses: self.viewControllers, andTheirTitles: self.titles)
        indexVC.pageAnimatable = true
        indexVC.menuItemWidth = 85
        indexVC.postNotification = true
        indexVC.bounces = true
        indexVC.menuViewStyle = WMMenuViewStyleLine
        indexVC.titleSizeSelected = 15
        indexVC.titleColorSelected = UIColor(255, green: 100, blue: 78)
        indexVC.progressColor = UIColor(255, green: 100, blue: 78)
        indexVC.menuBGColor = UIColor.clearColor()
        indexVC.menuHeight = 44
        return indexVC
    }()
    lazy var musicManager: LocalMusicPlayerTool! = {
        return LocalMusicPlayerTool.shareMusicPlay()
    }()
    

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        window = UIWindow.init(frame: UIScreen.mainScreen().bounds)
        window?.backgroundColor = UIColor.whiteColor()
        window?.makeKeyAndVisible()
        setNavgationUI()
        let main = self.mainController
        let nav = BaseNavigationController(rootViewController: main)
        window?.rootViewController = nav
        main.title = "多听FM"
        //启用远程控制事件接收
        UIApplication.sharedApplication().beginReceivingRemoteControlEvents()
        
         let bottonBar = MusicBottomView(frame: CGRectMake(0, self.window!.bounds.size.height - 60, self.window!.bounds.size.width, 60))
        self.window!.addSubview(bottonBar)
        self.window!.bringSubviewToFront(bottonBar)
        // Override point for customization after application launch.
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    func setNavgationUI() {
        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.LightContent
        let apperence = UINavigationBar.appearance()
        let barTintColor = UIColor(255, green: 100, blue: 78)
        apperence.cnSetBackgroundColor(barTintColor.colorWithAlphaComponent(1))
        apperence.tintColor = UIColor.whiteColor()
        apperence.titleTextAttributes = [
            NSForegroundColorAttributeName:UIColor.whiteColor(),
            NSFontAttributeName:UIFont.systemFontOfSize(20)
        ];
    }
    override func remoteControlReceivedWithEvent(event: UIEvent?) {
        if event?.type == .RemoteControl {
            switch (event!.subtype) {
            case .RemoteControlPlay:
                if (self.musicManager.currentMusicInfo != nil) {
                    self.musicManager.musicPlay()
                }else {
                    self.musicManager.playWithIndex(0)
                }
                break;
            case .RemoteControlPause:
                fallthrough
            case .RemoteControlStop:
                self.musicManager.musicPause()
            case .RemoteControlTogglePlayPause:
                if (self.musicManager.MusicList.count>0) {
                    if (self.musicManager.player.rate != 0) {
                        self.musicManager.musicPause()
                    }else{
                        if (self.musicManager.currentMusicInfo != nil) {
                            self.musicManager.musicPlay()
                        }else {
                            self.musicManager.playWithIndex(0)
                        }
                    }
                }
                break;
            case .RemoteControlNextTrack:
                self.musicManager.next()
                break;
            case .RemoteControlPreviousTrack:
                self.musicManager.previous()
                break;
            case .RemoteControlBeginSeekingForward:
                print("Begin seek forward...");
                break;
            case .RemoteControlEndSeekingForward:
                print("End seek forward...");
                break;
            case .RemoteControlBeginSeekingBackward:
                print("Begin seek backward...");
                break;
            case .RemoteControlEndSeekingBackward:
                print("End seek backward...");
                break;
            default:
                break;
            }
        }
    }
    


}

