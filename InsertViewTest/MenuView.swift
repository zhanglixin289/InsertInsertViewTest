//
//  MenuView.swift
//
//  Created by 张立鑫 on 16/2/18.
//  Copyright © 2016年 zhang. All rights reserved.
//

import UIKit

class MenuItemView:NSObject{
    var title:String!
    var img:UIImage!
    var num:Int!
    
    
    init(title:String,img:UIImage,num:Int){
        super.init()
        self.title = title
        self.img = img
        self.num = num
    }
    
}


protocol MenuDelegate{
    func didShowMenu(menu:MenuView)
    func didCloseMenu(menu:MenuView)
    func menuClick(btn:UIButton)
}

class MenuView: UIView {

    var delegate:MenuDelegate?
    
    typealias DidShow = (MenuView)->Void
    typealias DidDiss = (MenuView)->Void
    
    var con:UINavigationController!
    
    var isOpen:Bool = false{
        didSet{
            if(self.isOpen){
                self.insertViewToNavigationView()
                if let delegate = self.delegate{
                    delegate.didShowMenu(self)
                }
            }else{
                self.dismissView()
                if let delegate = self.delegate{
                    delegate.didCloseMenu(self)
                }
            }
        }
    }
    
    let moreY:CGFloat = 15
    var rowNum:Int!
    var columnNum:Int!
    var menu_frame:CGRect!
    var items:[MenuItemView]!
    var didshowBlock:DidShow?
    var didDissBlock:DidDiss?
    var bar:UIBarButtonItem?
    
    // 背景图层,监听点击事件
    var back_layer:UIView={
        let bl = UIView()
        bl.backgroundColor = UIColor.clearColor()
        bl.frame = CGRectZero
        return bl
    }()
    
    
    init(con:UINavigationController,items:[MenuItemView],frame:CGRect,rowNum:Int,columnNum:Int){
        
        super.init(frame: CGRectMake(0, -frame.size.height - frame.origin.y, frame.size.width, frame.size.height))
        
        self.items = items
        self.menu_frame = frame
        self.rowNum = rowNum
        self.columnNum = columnNum
        self.con = con
        
        // 添加点击事件监听
        let tap = UITapGestureRecognizer(target: self, action: "closeMenu")
        tap.numberOfTapsRequired = 1
        self.back_layer.addGestureRecognizer(tap)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "zhuan:", name: UIDeviceOrientationDidChangeNotification, object: nil)
        
    }

    func zhuan(notifi:NSNotification){
        
        print(self.subviews.count)
        print(self.items.count)
        let newSize = UIScreen.mainScreen().bounds.size
        let navHeight = UIApplication.sharedApplication().statusBarFrame.height + self.con.navigationBar.frame.size.height
        self.menu_frame = CGRectMake(0, navHeight, newSize.width, self.menu_frame.size.height)
        
        if(self.isOpen){
            layoutSubviews()
        }
        
    }
    
    // 特殊关闭事件
    func closeMenu(){
        self.isOpen = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func insertViewToNavigationView(){
        
        con.view.insertSubview(self.back_layer, belowSubview: con.navigationBar)
        con.view.insertSubview(self, belowSubview: con.navigationBar)
        
        UIView.animateWithDuration(0.2, animations: {() -> Void in
            self.back_layer.frame = self.con.view.frame
            self.frame = CGRectMake(0, self.menu_frame.origin.y + self.moreY, self.menu_frame.size.width, self.menu_frame.size.height)
            
            }) { (res) -> Void in
                UIView.animateWithDuration(0.1, delay: 0.1, options: .OverrideInheritedOptions, animations: { () -> Void in
                    self.frame = self.menu_frame
                    }, completion: { (res2) -> Void in
                        self.bar?.enabled = true
                })
        }
    }
    
    func dismissView(){
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.frame.origin = CGPointMake(0, self.frame.origin.y + self.moreY  )
            self.back_layer.frame = CGRectZero
            }) { (res) -> Void in
                UIView.animateWithDuration(0.1, delay: 0.1, options: .OverrideInheritedOptions , animations: { () -> Void in
                    self.frame.origin = CGPointMake(0, -self.frame.origin.y )
                }, completion: { (res2) -> Void in
                    self.back_layer.removeFromSuperview()
                    self.removeFromSuperview()
                    self.bar?.enabled = true
            })
        }
    }
    
    // 控制器点击事件
    func openMenu(bar:UIBarButtonItem){
        bar.enabled = false
        self.bar = bar
        self.isOpen = !self.isOpen
    }

    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.frame = self.menu_frame
        
        self.backgroundColor = UIColor.darkGrayColor()
        let width = self.menu_frame.size.width
        let height = self.menu_frame.size.height
        let btnWidth = (width / CGFloat(columnNum))
        let btnHeight = (height / CGFloat(rowNum))
        
        let views = self.subviews
        for ob in views{
            ob.removeFromSuperview()
            print("a")
        }
        
        let _ = items.map { (item) -> Void in
        
            let btn = UIButton(type:.Custom)
            btn.backgroundColor = UIColor.clearColor()
            btn.frame = CGRectMake(CGFloat(item.num % (1 + self.rowNum)) * btnWidth, CGFloat(item.num / (1 + self.rowNum)) * btnHeight, btnWidth, btnHeight)
            btn.tag = item.num
            btn.addTarget(self, action: "btnClick:", forControlEvents: .TouchUpInside)
            let imgView = UIImageView(image: item.img)
            imgView.center = CGPointMake(btnWidth / 2, btnHeight / 2 - 5)
            btn.addSubview(imgView)
            
            let lab = UILabel()
            lab.text = item.title
            lab.textAlignment = .Center
            lab.textColor = UIColor.blackColor()
            btn.addSubview(lab)
            lab.frame = CGRectMake(0, btnHeight - 15 , btnWidth, 15)
            
            self.addSubview(btn)
        }
        
    }
    
    deinit{
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func btnClick(btn:UIButton){
        // 每次点击按钮都关闭
        self.closeMenu()
        if let delegate = delegate{
            delegate.menuClick(btn)
        }
    }
    
}
