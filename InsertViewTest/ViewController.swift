//
//  ViewController.swift
//  InsertViewTest
//
//  Created by 张立鑫 on 16/2/18.
//  Copyright © 2016年 zhang. All rights reserved.
//

import UIKit

class ViewController: UIViewController,MenuDelegate {

    var menu:MenuView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.createMenu()
    }
    
    func didCloseMenu(menu: MenuView) {
        self.navigationItem.leftBarButtonItem?.title = "菜单"
    }
    
    func didShowMenu(menu: MenuView) {
        self.navigationItem.leftBarButtonItem?.title = "隐藏"
    }
    
    func menuClick(btn:UIButton){
        self.navigationItem.leftBarButtonItem?.title = "菜单"
        print(btn.tag)
    }
    
    func createMenu(){
        
        var arr:[MenuItemView] = [MenuItemView]()
        for(var i = 0 ; i < 6; i++){
            let item = MenuItemView(title: String("\(i)"), img: UIImage(named:String("\(i).png"))!, num: i)
            arr.append(item)
        }
        
        let height = self.navigationController!.navigationBar.frame.size.height + UIApplication.sharedApplication().statusBarFrame.height
        
        menu = MenuView(con:self.navigationController! ,items: arr,frame: CGRectMake(0, height, self.view.frame.size.width, 200), rowNum: 2, columnNum: 3)
        
        menu!.delegate = self
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "菜单", style: .Done, target: menu, action: "openMenu:")
        self.navigationController?.navigationBar.barStyle = .Black
        self.navigationController?.navigationBar.barTintColor = UIColor.darkGrayColor()
        self.navigationController?.navigationBar.translucent = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

