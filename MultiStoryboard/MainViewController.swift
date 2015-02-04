//
//  MainViewController.swift
//  MultiStoryboard
//
//  Created by 秦 道平 on 15/2/2.
//  Copyright (c) 2015年 秦 道平. All rights reserved.
//

import UIKit

class MainViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        /// 获取两个Tab对应的 Storyboard
        let story_first = UIStoryboard(name: "First", bundle: nil)
        let story_second = UIStoryboard(name: "Second", bundle: nil)
        /// 获取Tab 对应的第一个 ViewController
        let first_nav_viewcontroller = story_first.instantiateViewControllerWithIdentifier("first-nav") as UINavigationController
        let second_a_viewcontroller = story_second.instantiateViewControllerWithIdentifier("second-a") as SecondAViewController
        /// 设置 tabBar 内容
        first_nav_viewcontroller.tabBarItem = UITabBarItem(title: "First", image: nil, tag: 0)
        second_a_viewcontroller.tabBarItem = UITabBarItem(title: "Second", image: nil, tag: 1)
        /// 为我们的 UITabBarController 设置对应的两个ViewController
        self.viewControllers = [first_nav_viewcontroller, second_a_viewcontroller]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
//        self.showPop()
    }
    func showPop(){
        self.performSegueWithIdentifier("segue-main-pop", sender: nil)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
