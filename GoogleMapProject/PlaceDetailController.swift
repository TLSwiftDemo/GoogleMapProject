//
//  PlaceDetailController.swift
//  GoogleMapProject
//
//  Created by Andrew on 2016/11/30.
//  Copyright © 2016年 Andrew. All rights reserved.
//

import UIKit
import GooglePlacePicker
import GooglePlaces
import GoogleMaps

class PlaceDetailController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    private let place: GMSPlace
    private weak var photoView: UIImageView!
    private weak var mapView: GMSMapView!
    private var backView:TableBackgroundView!
    
    var tableView:UITableView!
    weak var tableDataSource:PlaceDataSource!
    
    init(place: GMSPlace) {
        self.place = place
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        // Do any additional setup after loading the view.
        initTableView()
    }
    
    func initTableView() -> Void
    {
        
        tableView = UITableView()
        // Configure some other properties.
        tableView.estimatedRowHeight = 64
        tableView.estimatedSectionHeaderHeight = 44
        tableView.sectionHeaderHeight = UITableViewAutomaticDimension
        self.view.addSubview(tableView)
        
//      tableDataSource = PlaceDataSource(place: place, tableView: tableView)
//      tableView.dataSource = tableDataSource
//      tableView.delegate = tableDataSource
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.snp.makeConstraints { (make) in
            make.left.equalTo(0)
            make.top.equalTo(64+150)
            make.right.equalTo(0)
            make.bottom.equalTo(0)
        }
        tableView.reloadData()
        
        
        backView = TableBackgroundView(frame: self.tableView.bounds)
        tableView.backgroundView = backView
    }

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
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = PlaceHeaderView()
        header.setDataSource(place: place)
        header.backgroundColor = Colors.blue2
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 100
    }

  
}
