//
//  PlaceCell.swift
//  GoogleMapProject
//
//  Created by Andrew on 2016/11/30.
//  Copyright © 2016年 Andrew. All rights reserved.
//

import UIKit
import SnapKit
import GooglePlaces
import GoogleMaps
class PlaceCell: UITableViewCell {
    
    private var namelb:UILabel!
    private var valuelb:UILabel!
    private var iconImgView:UIImageView!
    private let noneText = NSLocalizedString("PlaceDetails.MissingValue",
                                             comment: "The value of a property which is missing")

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        iconImgView = UIImageView()
        iconImgView.contentMode = .scaleAspectFit
        self.addSubview(iconImgView)
        
        iconImgView.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.centerY.equalTo(self.snp.centerY)
            make.size.equalTo(CGSize(width: 40, height: 40))
        }
        
        namelb = UILabel()
        namelb.textColor = UIColor.red
        namelb.font = UIFont.systemFont(ofSize: 15)
        self.addSubview(namelb)
        
        namelb.snp.makeConstraints { (make) in
            make.left.equalTo(iconImgView.snp.right).offset(15)
            make.bottom.equalTo(iconImgView.snp.top)
            make.right.equalTo(0)
            make.height.equalTo(20)
        }
        
        valuelb = UILabel()
        self.addSubview(valuelb)
        valuelb.snp.makeConstraints { (make) in
            make.left.equalTo(namelb.snp.left)
            make.top.equalTo(namelb.snp.bottom)
            make.right.equalTo(0)
            make.bottom.equalTo(0)
        }
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Utilities
    
    /// Return the appropriate text string for the specified |GMSPlacesOpenNowStatus|.
     func text(for status: GMSPlacesOpenNowStatus) -> String {
        switch status {
        case .no: return NSLocalizedString("Places.OpenNow.No",
                                           comment: "Closed/Open state for a closed location")
        case .yes: return NSLocalizedString("Places.OpenNow.Yes",
                                            comment: "Closed/Open state for an open location")
        case .unknown: return NSLocalizedString("Places.OpenNow.Unknown",
                                                comment: "Closed/Open state for when it is unknown")
        }
    }
    
    /// Return the appropriate text string for the specified |GMSPlacesPriceLevel|.
     func text(priceLevel: GMSPlacesPriceLevel) -> String {
        switch priceLevel {
        case .free: return NSLocalizedString("Places.PriceLevel.Free",
                                             comment: "Relative cost for a free location")
        case .cheap: return NSLocalizedString("Places.PriceLevel.Cheap",
                                              comment: "Relative cost for a cheap location")
        case .medium: return NSLocalizedString("Places.PriceLevel.Medium",
                                               comment: "Relative cost for a medium cost location")
        case .high: return NSLocalizedString("Places.PriceLevel.High",
                                             comment: "Relative cost for a high cost location")
        case .expensive: return NSLocalizedString("Places.PriceLevel.Expensive",
                                                  comment: "Relative cost for an expensive location")
        case .unknown: return NSLocalizedString("Places.PriceLevel.Unknown",
                                                comment: "Relative cost for when it is unknown")
        }
    }
    
    /// 设置数据源
    ///
    /// - Parameter place:GMSPlace
    func setDataSource(place:GMSPlace,index:Int) -> Void {
        
        if let propertyType = PlaceProperty(rawValue: index){
            self.namelb.text = propertyType.localizedDescription()
            self.iconImgView.image = propertyType.icon()
            
            switch propertyType {
            case .placeID:
                self.namelb.text = place.placeID
                break
            case .coordinate:
                self.valuelb.text = "[\(place.coordinate.latitude)，\(place.coordinate.longitude)]"
            case .openNowStatus:
                self.valuelb.text = text(for: place.openNowStatus)
            case .phoneNumber:
                self.valuelb.text = place.phoneNumber ?? noneText
            case .website:
                self.valuelb.text = place.website?.absoluteString ?? noneText
            case .formattedAddress:
                self.valuelb.text = place.formattedAddress ?? noneText
            case .rating:
                let rating = place.rating
                // As specified in the documentation for |GMSPlace|, a rating of 0.0 signifies that there
                // have not yet been any ratings for this location.
                if rating > 0 {
                   self.valuelb.text = "\(rating)"
                } else {
                    self.valuelb.text = noneText
                }
            case .priceLevel:
                valuelb.text = text(priceLevel: place.priceLevel)
            case .types:
                valuelb.text = place.types.joined(separator: ", ")
            case .attribution:
                if let attributions = place.attributions {
                    valuelb.attributedText = attributions
                } else {
                    valuelb.text = noneText
                }
            }
          
            }
        }
        
     
    
  

}
