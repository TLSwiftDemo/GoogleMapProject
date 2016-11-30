//
//  PlaceHeaderView.swift
//  GoogleMapProject
//
//  Created by Andrew on 2016/11/30.
//  Copyright © 2016年 Andrew. All rights reserved.
//

import UIKit
import SnapKit

class PlaceHeaderView: UIView {
    

   private var placeNameLb:UILabel!
    //距离左边的距离
    var leadingSpace:CGFloat!
    //具体顶部的距离
    var topSpace:CGFloat!
    
    var compact = false {
        didSet {
            topSpace = compact ? 9 : 29
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        placeNameLb = UILabel()
        placeNameLb.font = UIFont.boldSystemFont(ofSize: 22)
        addSubview(placeNameLb)
        
        placeNameLb.snp.makeConstraints { (make) in
            make.left.equalTo(20)
            make.centerY.equalTo(self.snp.centerY)
            make.size.equalTo(CGSize(width: 200, height: 30))
        }
    
    }

    
       
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
