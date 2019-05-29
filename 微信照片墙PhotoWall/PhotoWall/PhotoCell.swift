//
//  PhotoCell.swift
//  PhotoWall
//
//  Created by 郭朝顺 on 2019/5/21Tuesday.
//  Copyright © 2019 智网易联. All rights reserved.
//

import UIKit

class PhotoCell: UICollectionViewCell,UIScrollViewDelegate {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var mainImage: UIImageView!
    
    var callBack = {
        print("移除这个view")
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        scrollView.delegate = self
        
        let sigleTap = UITapGestureRecognizer.init(target: self, action: #selector(self.tapToClose(_:)))
        self.mainImage.addGestureRecognizer(sigleTap)
        
        let douleTap = UITapGestureRecognizer.init(target: self, action: #selector(self.doubleTapToZoom(_:)))
        douleTap.numberOfTapsRequired = 2;
        self.mainImage.addGestureRecognizer(douleTap)

        sigleTap.require(toFail: douleTap)
    }
    
    // 单击,关闭这个view
    @objc func tapToClose(_ tap: UITapGestureRecognizer) {
        callBack()

    }
    // 双击,放大或者缩小view
    @objc func doubleTapToZoom(_ doubleTap: UITapGestureRecognizer) {
        if self.scrollView.zoomScale>1 {
            self.scrollView.setZoomScale(self.scrollView.minimumZoomScale, animated: true)
        } else {
            self.scrollView.setZoomScale(self.scrollView.maximumZoomScale, animated: true)
        }
        
    }
    
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return mainImage
    }

}
