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
    fileprivate let place: GMSPlace
    fileprivate weak var mapView: GMSMapView!
    fileprivate var backView:TableBackgroundView!
    fileprivate var fakeView:UIView!
    fileprivate static let photoSize = CGSize(width: 450, height: 300)
    
    var tableView:UITableView!
    weak var tableDataSource:PlaceDataSource!
    
    
    /// google map 的客户端API
     lazy var placeClient = {
      GMSPlacesClient.shared()
    }()
    
    
    /// 左边距是否偏移
    var offsetNavigationTitle = false
    var compactHeader = false {
        didSet {
            if #available(iOS 9.0, *) {
                tableView.beginUpdates()
                updateNavigationBar()
                tableView.endUpdates()
            } else {
                // We'd really rather not call reloadData(), but on iOS 8.x begin/endUpdates tend to crash
                // for this particular tableView.
                tableView.reloadData()
            }
        }
    }
    
    init(place: GMSPlace) {
        self.place = place
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
   
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        // Do any additional setup after loading the view.
        initTableView()
        //查找照片
        self.lookUpPhoto()
    }
    
    
    
    func initTableView() -> Void
    {
        
        tableView = UITableView()
        tableView.bounces = false
        // Configure some other properties.
        tableView.estimatedRowHeight = 64
        tableView.estimatedSectionHeaderHeight = 44
        tableView.sectionHeaderHeight = UITableViewAutomaticDimension
        self.view.addSubview(tableView)
        

        tableView.delegate = self
        tableView.dataSource = self
        tableView.snp.makeConstraints { (make) in
            make.left.equalTo(0)
            make.top.equalTo(0)
            make.right.equalTo(0)
            make.bottom.equalTo(0)
        }
        
        //创建返回按钮
        let backBtn = UIButton()
        self.view.addSubview(backBtn)
        
        let backImg = UIImage(named:"back")!
        backBtn.setImage(backImg, for: .normal)
        backBtn.addTarget(self, action: #selector(backAction(btn:)), for: .touchUpInside)
        
        backBtn.snp.makeConstraints { (make) in
            make.top.equalTo(15)
            make.left.equalTo(0)
            make.size.equalTo(CGSize(width: 50, height: 40))
        }
        
        //创建虚拟的View
        if fakeView == nil{
            fakeView = UIView()
            fakeView.frame = CGRect(x: 0, y: 0, width: 320, height: 160)
            tableView.tableHeaderView = fakeView
        }
        
        backView = TableBackgroundView(frame: self.tableView.bounds)
        tableView.backgroundView = backView
    }
    
    func backAction(btn:UIButton) -> Void {
        self.navigationController?.popViewController(animated: true)
    }

    //MARK: - UITableview dataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return PlaceProperty.numberOfProperties() + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0{
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
        
        var header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "Header") as? PlaceHeaderView
        if header == nil{
            header = PlaceHeaderView(reuseIdentifier: "Header")
        }
        header?.setDataSource(place: place)
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
    
    
    /// 滚动tableView监听的方法
    ///
    /// - Parameter scrollView:
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // Update the extensionConstraint and the navigation title offset when the tableView scrolls.
//        extensionConstraint.constant = max(0, -scrollView.contentOffset.y)
        
        
        let offSetY = scrollView.contentOffset.y
        
        print("offsetY\(offSetY)")
        
        if offSetY>130{
          offsetNavigationTitle = true
        }else{
          offsetNavigationTitle = false
        }
        
        updateNavigationTextOffset()
    }
  
}

extension PlaceDetailController{
  //MARK: - private methods
    
    func updateNavigationTextOffset() {
        updateNavigationBar()
    }
    
    func updateNavigationBar() -> Void {
        // Grab the header.
        if let header = self.tableView.headerView(forSection: 0) as? PlaceHeaderView {
            updateNavigationBar(header)
        }
        
    }
    private func updateNavigationBar(_ header: PlaceHeaderView){
      
        if offsetNavigationTitle{
            let offset = max(0, min(36, tableView.contentOffset.y - 130))

            
            header.placeNameLb.snp.updateConstraints({ (make) in
                make.left.equalTo(offset+10)
                make.bottom.equalTo(-30)

            })
        }else{
            header.placeNameLb.snp.updateConstraints({ (make) in
                make.left.equalTo(15)
                make.bottom.equalTo(30)
            })
        }
        
        // Update the compact status.
//        header.compact = compactHeader
    }
    
    
    /// look up picture
     func lookUpPhoto(){
        placeClient.lookUpPhotos(forPlaceID: place.placeID){
          (metadata,error) in
            //Handle the result if it was successful
            if let data = metadata {
                if data.results.isEmpty == false{
                  self.loadPhoto(photo: data.results[0])
                }else{
                  print("No photos were found")
                }
            }else if error != nil {
                NSLog("An error occured while looking up the photos: \(error)")
            }else {
                fatalError("An unexpected error occured")
            }
        }
    }
    
    func loadPhoto(photo:GMSPlacePhotoMetadata) -> Void {
        //Load the specified photo
        placeClient.loadPlacePhoto(photo, constrainedTo: PlaceDetailController.photoSize, scale: view.window?.screen.scale ?? 1){
          (image,error) in
            //handle the result if it was successful
            if let image = image {
             self.backView.picImgView.image = image
            }else if error != nil {
                NSLog("An error occured while loading the first photo: \(error)")
            } else {
                fatalError("An unexpected error occured")
            }
        }
    }
}
