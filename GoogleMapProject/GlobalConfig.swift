//
//  GlobalConfig.swift
//  GoogleMapProject
//
//  Created by Andrew on 2016/11/30.
//  Copyright © 2016年 Andrew. All rights reserved.
//

import Foundation
import UIKit

struct Colors {
    static let blue1 = UIColor(red: 0.224, green: 0.286, blue: 0.671, alpha: 1)
    static let blue2 = UIColor(red: 0.247, green: 0.318, blue: 0.710, alpha: 1)
}

enum PlaceProperty: Int {
    case placeID
    case coordinate
    case openNowStatus
    case phoneNumber
    case website
    case formattedAddress
    case rating
    case priceLevel
    case types
    case attribution
    
    static func numberOfProperties() -> Int {
        return 10
    }
    func localizedDescription() -> String {
        switch self {
        case .placeID:
            return NSLocalizedString("Places.Property.PlaceID",
                                     comment: "Name for the Place ID property")
        case .coordinate:
            return NSLocalizedString("Places.Property.Coordinate",
                                     comment: "Name for the Coordinate property")
        case .openNowStatus:
            return NSLocalizedString("Places.Property.OpenNowStatus",
                                     comment: "Name for the Open now status property")
        case .phoneNumber:
            return NSLocalizedString("Places.Property.PhoneNumber",
                                     comment: "Name for the Phone number property")
        case .website:
            return NSLocalizedString("Places.Property.Website",
                                     comment: "Name for the Website property")
        case .formattedAddress:
            return NSLocalizedString("Places.Property.FormattedAddress",
                                     comment: "Name for the Formatted address property")
        case .rating:
            return NSLocalizedString("Places.Property.Rating",
                                     comment: "Name for the Rating property")
        case .priceLevel:
            return NSLocalizedString("Places.Property.PriceLevel",
                                     comment: "Name for the Price level property")
        case .types:
            return NSLocalizedString("Places.Property.Types",
                                     comment: "Name for the Types property")
        case .attribution:
            return NSLocalizedString("Places.Property.Attributions",
                                     comment: "Name for the Attributions property")
        }
    }
    
    func icon() -> UIImage? {
        switch self {
        case .placeID:
            return UIImage(named: "place_id")
        case .coordinate:
            return UIImage(named: "coordinate")
        case .openNowStatus:
            return UIImage(named: "open_now")
        case .phoneNumber:
            return UIImage(named: "phone_number")
        case .website:
            return UIImage(named: "website")
        case .formattedAddress:
            return UIImage(named: "address")
        case .rating:
            return UIImage(named: "rating")
        case .priceLevel:
            return UIImage(named: "price_level")
        case .types:
            return UIImage(named: "types")
        case .attribution:
            return UIImage(named: "attribution")
        }
    }
    
}


