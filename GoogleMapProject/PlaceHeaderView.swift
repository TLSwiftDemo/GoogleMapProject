//
//  PlaceHeaderView.swift
//  GoogleMapProject
//
//  Created by Andrew on 2016/11/30.
//  Copyright © 2016年 Andrew. All rights reserved.
//

import UIKit
import SnapKit
import GooglePlaces
import GoogleMaps

class PlaceHeaderView: UITableViewHeaderFooterView {
    

    var placeNameLb:UILabel!
    //距离左边的距离
    var leadingSpace:CGFloat!
    //具体顶部的距离
    var topSpace:CGFloat!
    
    var compact = false {
        didSet {
            topSpace = compact ? 9 : 29
        }
    }
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        self.contentView.backgroundColor = Colors.blue2
        placeNameLb = UILabel()
        placeNameLb.textColor = UIColor.white
        placeNameLb.font = UIFont.boldSystemFont(ofSize: 20)
        placeNameLb.lineBreakMode = .byCharWrapping
        placeNameLb.numberOfLines = 0
        placeNameLb.backgroundColor = Colors.blue2
        addSubview(placeNameLb)
        
        placeNameLb.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.right.equalTo(-15)
            make.top.equalTo(0)
            make.bottom.equalTo(30)
        }

    }
    
   

    
    func setDataSource(place:GMSPlace) {
        self.placeNameLb.text = place.name
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
