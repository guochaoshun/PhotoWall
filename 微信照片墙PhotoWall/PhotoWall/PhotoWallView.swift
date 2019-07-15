//
//  PhotoWall.swift
//  PhotoWall
//
//  Created by 郭朝顺 on 2019/5/21Tuesday.
//  Copyright © 2019 智网易联. All rights reserved.
//

import UIKit

class PhotoWallView: UIView,UICollectionViewDataSource,UICollectionViewDelegate {

    let bigImageView = UIImageView()
    var originalPoint = CGPoint.zero

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        
        let pan = UIPanGestureRecognizer(target: self, action: #selector(panAction(pan:)))
        self.addGestureRecognizer(pan)
        
        bigImageView.clipsToBounds = true
        bigImageView.tag = 100
        bigImageView.center = UIApplication.shared.keyWindow!.center
        bigImageView.contentMode = .scaleAspectFit
        self.addSubview(bigImageView)

        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var photoArray = [""]{
        didSet{
            collectionView.reloadData()
        }
    }
    
    var selectIndex : Int = 0{
        didSet {
            collectionView.scrollToItem(at: IndexPath(item: selectIndex, section: 0), at: .centeredHorizontally, animated: false)
            
        }
    }
    
    var callBack = { print("结束了,执行动画") }
    var beginDraging = { print("开始拖动了") }

    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photoArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as! PhotoCell
        cell.mainImage.image = UIImage(named: photoArray[indexPath.item])
        cell.callBack = { [weak self]  in
            self?.selectIndex = indexPath.item
            
            // 调整bigImageView的大小和图片 , 然后调用回调 , 完成隐藏的动画
            let bigImageView = self!.bigImageView
            bigImageView.image = cell.mainImage.image
            let height = Screen_Width * bigImageView.image!.size.height / bigImageView.image!.size.width
            bigImageView.frame = CGRect(x: 0, y: 0, width: Screen_Width, height: height)
            bigImageView.center = UIApplication.shared.keyWindow!.center
        
            self?.backToViewController()
        }
        return cell
    }
    
    func backToViewController() {
        
        
        bigImageView.contentMode = .scaleAspectFill

        collectionView.isHidden = true
        bigImageView.isHidden = false

        self.callBack()
        
    }
  
    
    
    @objc func panAction(pan : UIPanGestureRecognizer) {
        
        let bgView = pan.view!

        if pan.state == .began {
            originalPoint = bigImageView.center
            collectionView.isHidden = true
            bigImageView.isHidden = false

            let cell = collectionView.visibleCells.first as! PhotoCell
            bigImageView.image = cell.mainImage.image
            let height = Screen_Width * bigImageView.image!.size.height / bigImageView.image!.size.width
            bigImageView.frame = CGRect(x: 0, y: 0, width: Screen_Width, height: height)
            bigImageView.center = UIApplication.shared.keyWindow!.center

            self.selectIndex = collectionView.indexPathsForVisibleItems.first!.item
            self.beginDraging()
            
        } else if pan.state == .changed {
            
            let point = pan.translation(in: UIApplication.shared.keyWindow)
            
            // 注释掉向上拖动的判断,允许向上拖动的返回
//            if point.y < 0 {
//                print("向上拖动 , 不处理 , 结束")
//                return
//            }
            
            
            let alpha = 0.7-abs(point.y)/Screen_Height
            print("透明度"+alpha.description)
            bgView.backgroundColor = UIColor.black.withAlphaComponent(alpha)
            bigImageView.center = CGPoint(x: originalPoint.x+point.x, y: originalPoint.y+point.y)
            let size = 1 - abs(point.y)/Screen_Height
            bigImageView.transform = CGAffineTransform(scaleX: max(size, 0.75), y: max(size, 0.75))
            
        } else if pan.state == .ended {
            print("拖动结束")
            
            if bigImageView.center.y > Screen_Height * 0.6 || bigImageView.center.y < Screen_Height * 0.4 {
                backToViewController()
            } else {
                backToOriginal(pan: pan)
            }
   
            
        } else if pan.state == .cancelled || pan.state == .failed {
            print("cancelled or failed")
            backToOriginal(pan: pan)

        }
        
    }

    
    
    /// 回到初始位置
    func backToOriginal(pan : UIPanGestureRecognizer)  {
        
        let bgView = pan.view!
        let bigImageView = bgView.viewWithTag(100)! as! UIImageView
        
        UIView.animate(withDuration: animationDuration*0.5, animations: {
            bgView.backgroundColor = .black
            
            bigImageView.contentMode = .scaleAspectFit
            let height = Screen_Width * bigImageView.image!.size.height / bigImageView.image!.size.width
            bigImageView.frame = CGRect(x: 0, y: 0, width: Screen_Width, height: height)
            bigImageView.center = UIApplication.shared.keyWindow!.center
            
            
        }) { (isF) in
            self.collectionView.isHidden = false
            bigImageView.isHidden = true

            
        }
    }
    
    
    
    lazy var collectionView : UICollectionView = {
        
        let flow = UICollectionViewFlowLayout.init()
        flow.scrollDirection = .horizontal
        flow.itemSize = bounds.size
        flow.minimumLineSpacing = 0
        var collection = UICollectionView(frame: self.bounds, collectionViewLayout: flow)
        collection.delegate = self
        collection.dataSource = self
        collection.isPagingEnabled = true
        collection.register(UINib(nibName: "PhotoCell", bundle: nil), forCellWithReuseIdentifier: "PhotoCell")
        self.addSubview(collection)
        return collection
    }()
    
    

}
