//
//  LaunchScreenViewCtr.swift
//  淘妈咪
//
//  Created by 韩景军 on 2017/3/24.
//  Copyright © 2017年 韩景军. All rights reserved.
//

import UIKit

//启动成功的代理
@objc protocol LaunchScreenDelegate:NSObjectProtocol{
    
    func launchScreenSuccess()
}

class LaunchScreenViewCtr: UIViewController {
    
    weak var delegate: LaunchScreenDelegate?
    @IBOutlet weak var logoImgView: UIImageView!
    @IBOutlet weak var sloganImgView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //创建动画图片数组
        var images = [UIImage]()
        for i in 21...30{
            guard let img = UIImage(named: "tao_anim_0\(i).png") else{
                continue
            }
            images.append(img)
        }
        self.logoImgView.animationDuration = 2.0  //动画执行周期
        self.logoImgView.animationImages = images //动画数组
        self.logoImgView.animationRepeatCount = 1 //动画循环次数
        self.logoImgView.startAnimating()         //开始执行动画
        
        //利用transform，等比例缩放slogan大小
        self.sloganImgView.layer.setAffineTransform(CGAffineTransform(scaleX: 0.2,y: 0.2))
        UIView.animate(withDuration: 2, delay:0.2 ,options:UIViewAnimationOptions.curveEaseInOut, animations:{()-> Void in
            self.sloganImgView.layer.setAffineTransform(CGAffineTransform(scaleX: 1,y: 1))
        },completion:{(finished:Bool) -> Void in
            sleep(1) //睡1秒，让界面跳转看起来缓和一些
            if self.delegate != nil {
                self.delegate?.launchScreenSuccess()
            }
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
