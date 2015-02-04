//
//  FirstBViewController.swift
//  MultiStoryboard
//
//  Created by 秦 道平 on 15/2/2.
//  Copyright (c) 2015年 秦 道平. All rights reserved.
//

import UIKit

class FirstBViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onButtonPop(sender:UIButton!){
//        let main_storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let main_viewcontroller = main_storyboard.instantiateViewControllerWithIdentifier("main-tab") as MainViewController
//        main_viewcontroller.showPop()
        let main_viewcontroller = self.parentViewController!.parentViewController! as MainViewController
        main_viewcontroller.showPop()
    
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
