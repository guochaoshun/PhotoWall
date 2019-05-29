//
//  PhotoWall.swift
//  PhotoWall
//
//  Created by 郭朝顺 on 2019/5/21Tuesday.
//  Copyright © 2019 智网易联. All rights reserved.
//

import UIKit

class PhotoWallView: UIView,UICollectionViewDataSource,UICollectionViewDelegate {

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.black
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
    
    var callBack = {
        print("结束了,执行动画")
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photoArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as! PhotoCell
        cell.mainImage.image = UIImage(named: photoArray[indexPath.item])
        cell.callBack = { [weak self]  in
            self?.selectIndex = indexPath.item
            self?.viewDisappear()
        }
        return cell
    }
    
    func viewDisappear() {
        
        self.callBack()
        self.removeFromSuperview()
        
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
