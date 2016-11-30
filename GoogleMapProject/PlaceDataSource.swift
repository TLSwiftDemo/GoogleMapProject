//
//  PlaceDataSource.swift
//  GoogleMapProject
//
//  Created by Andrew on 2016/11/30.
//  Copyright © 2016年 Andrew. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces

let cellIdentity1 = "cellIdentity1"
let cellIdentity2 = "cellIdentity2"


class PlaceDataSource: NSObject,UITableViewDelegate,UITableViewDataSource {
    fileprivate let place: GMSPlace
    private let blueCellIdentifier = "BlueCellIdentifier"
    
    private var tableView:UITableView!
    
    
    init(place:GMSPlace,tableView:UITableView) {
        self.place = place
        self.tableView = tableView
    }
    
}

extension PlaceDataSource{
 //MARK: - UITableview dataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return PlaceProperty.numberOfProperties() + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.item == 0{
            var cell = tableView.dequeueReusableCell(withIdentifier: cellIdentity1)
            if cell == nil{
               cell = PlaceCell(style: .default, reuseIdentifier: cellIdentity1)
            }
            cell?.backgroundColor = Colors.blue2
            cell?.selectionStyle = .none
            return cell!
        }
        
        //for all other cells use the same style
        
        var cell = tableView.dequeueReusableCell(withIdentifier: cellIdentity2)
        if cell == nil
        {
         cell = PlaceCell(style: .default, reuseIdentifier: cellIdentity2)
        }
        //Disable selection
        cell?.selectionStyle = .none
       
        (cell as! PlaceCell).setDataSource(place: place, index: indexPath.row)
        
        return cell!
        
        
    }
}
