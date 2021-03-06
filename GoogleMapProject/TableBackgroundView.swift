//
//  TableBackgroundView.swift
//  GoogleMapProject
//
//  Created by Andrew on 2016/12/1.
//  Copyright © 2016年 Andrew. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import SnapKit

class TableBackgroundView: UIView {
    public var picImgView:UIImageView!
    public var mapView:GMSMapView!

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        picImgView = UIImageView()
        picImgView.image = UIImage(named:"World_location_map")
        self.addSubview(picImgView)
        
        picImgView.snp.makeConstraints { (make) in
            make.left.equalTo(0)
            make.top.equalTo(0)
            make.right.equalTo(0)
            make.height.equalTo(200)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
