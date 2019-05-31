//
//  ViewController.swift
//  PhotoWall
//
//  Created by 郭朝顺 on 2019/5/21Tuesday.
//  Copyright © 2019 智网易联. All rights reserved.
//

import UIKit


let Screen_Width = UIScreen.main.bounds.size.width
let Screen_Height = UIScreen.main.bounds.size.height
let animationDuration = 0.5


class ViewController: UIViewController {

    var dataArray = ["1","2","3","4"]
    

    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        


    }
    
    @IBAction func tapAction(_ tap: UITapGestureRecognizer) {
        
        // 放大 : 先把这个imageView放到keyWindow上,然后改view的frame,动画完成后此view回到初始位置,显示PhotoWallView
        // 缩小 : 隐藏PhotoWallView的collectionView,用一个一模一样的imageView,然后缩小这个imageView,最后移除PhotoWallView
  
        // 保存旧的frame
        let oldFrame = tap.view!.frame
        let imageView = tap.view as! UIImageView

        
        // 用window加载
        let keyWindow = UIApplication.shared.keyWindow!
        let photoWall = PhotoWallView.init(frame: keyWindow.bounds)
        
      
        photoWall.callBack = { [weak self] in
            // 缩小动画
            let bigImageView = photoWall.bigImageView
            
            UIView.animate(withDuration: animationDuration, animations: {

                photoWall.backgroundColor = UIColor.black.withAlphaComponent(0.1)
                bigImageView.frame = self?.view.viewWithTag(100+photoWall.selectIndex)?.frame ?? oldFrame

            }, completion: { (isF) in

                photoWall.removeFromSuperview()
                
            })
            
        }
        
        keyWindow.addSubview(photoWall)
        
        keyWindow.addSubview(tap.view!)
        
        // 放大动画
        imageView.contentMode = .scaleAspectFit

        UIView.animate(withDuration: animationDuration, animations: {

            photoWall.backgroundColor = UIColor.black.withAlphaComponent(1)
            
            let height = Screen_Width * imageView.image!.size.height / imageView.image!.size.width
            tap.view?.frame = CGRect(x: 0, y: 0, width: Screen_Width, height: height )
            tap.view?.center = keyWindow.center
            
        }) { (isComplete) in
            
            // 动画完成,恢复到原始样子
            imageView.contentMode = .scaleAspectFill
            imageView.frame = oldFrame
            self.view.addSubview(imageView)

            photoWall.photoArray = self.dataArray
            photoWall.selectIndex = tap.view!.tag-100

            
        }
        
        
        
        
    }
    
    
    


}

