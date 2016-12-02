//
//  ViewController.swift
//  GoogleMapProject
//
//  Created by Andrew on 2016/11/29.
//  Copyright © 2016年 Andrew. All rights reserved.
//

import UIKit
import GoogleMaps
import SnapKit
import GooglePlacePicker
import GooglePlaces


class ViewController: UIViewController,GMSMapViewDelegate {
    
    var googleMap:GMSMapView!
    var placePicker:GMSPlacePicker!
    var firstLocationUpdate:Bool = false
    
    var searchBtn:UIButton!
    var filterBtn:UIButton!
    var locateBtn:UIButton!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        // Do any additional setup after loading the view, typically from a nib.
        initMapView()
        initView()
    }

    
    func initMapView() -> Void {

        let coordinate = CLLocationCoordinate2D(latitude: 38.8879, longitude: -77.0200)
        let camera = GMSCameraPosition(target: coordinate, zoom: 17, bearing: 0, viewingAngle: 10)
        
        
        googleMap = GMSMapView()
        googleMap.delegate = self
        googleMap.camera = camera
        googleMap.isTrafficEnabled = true
        googleMap.isBuildingsEnabled=true
        
        googleMap.settings.compassButton = true
//        googleMap.settings.myLocationButton = true
        self.view.addSubview(googleMap)
        
        
        let marker = GMSMarker()
        marker.position = camera.target
        marker.snippet = "Hello World"
        marker.appearAnimation = kGMSMarkerAnimationPop
        marker.map = googleMap
        
        googleMap.snp.makeConstraints { (make) in
            make.left.equalTo(0)
            make.right.equalTo(0)
            make.top.equalTo(0)
            make.bottom.equalTo(-50)
        }
        
        // Listen to the myLocation property of GMSMapView.

        googleMap.addObserver(self, forKeyPath: "myLocation", options: .new, context: nil)
        
    }
    
    func initView() -> Void {
        let toolBar = UIToolbar()
        self.view.addSubview(toolBar)
        
        toolBar.snp.makeConstraints { (make) in
            make.left.equalTo(0)
            make.top.equalTo(googleMap.snp.bottom)
            make.bottom.equalTo(0)
            make.right.equalTo(0)
        }
        
        searchBtn = UIButton()
        searchBtn.setTitle("搜索", for: .normal)
        searchBtn.setTitleColor(UIColor.red, for: .normal)
        searchBtn.addTarget(self, action: #selector(pickPlace(sender:)), for: .touchUpInside)
        toolBar.addSubview(searchBtn)
        
        searchBtn.snp.makeConstraints { (make) in
            make.centerY.equalTo(toolBar.snp.centerY)
            make.left.equalTo(15)
            make.size.equalTo(CGSize(width: 60, height: 40))
        }
        
        //filter button
        filterBtn = UIButton()
        filterBtn.setTitleColor(UIColor.red, for: .normal)
        filterBtn.setTitle("filter", for: .normal)
        filterBtn.addTarget(self, action: #selector(filterAction), for: .touchUpInside)
        toolBar.addSubview(filterBtn)
        
        filterBtn.snp.makeConstraints { (make) in
            make.centerY.equalTo(toolBar.snp.centerY)
            make.centerX.equalTo(toolBar.snp.centerX)
            make.size.equalTo(CGSize(width: 60, height: 40))
        }
        
        //locateCurrent button
        locateBtn = UIButton()
        locateBtn.setTitle("定位", for: .normal)
        locateBtn.setTitleColor(UIColor.red, for: .normal)
        locateBtn.addTarget(self, action: #selector(locateAction), for: .touchUpInside)
        toolBar.addSubview(locateBtn)
        
        locateBtn.snp.makeConstraints { (make) in
            make.right.equalTo(-15)
            make.centerY.equalTo(toolBar.snp.centerY)
            make.size.equalTo(CGSize(width: 60, height: 40))
        }
        
        //地图类型切换的segment
        let segment = UISegmentedControl(items: ["Normal","Satellite","Hybrid","Terrain"])
        segment.tintColor = UIColor.red
        segment.selectedSegmentIndex = 0
        segment.addTarget(self, action: #selector(segmentSwitchAction(sender:)), for: .valueChanged)
        googleMap.addSubview(segment)
        
        segment.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.top.equalTo(20)
            make.size.equalTo(CGSize(width: 220, height: 35))
            
        }
        
    }
 

    
    //MARK: - GMSMapView Delegate
    func mapViewDidStartTileRendering(_ mapView: GMSMapView) {
        print("开始渲染")
    }
    
    func mapViewDidFinishTileRendering(_ mapView: GMSMapView) {
      print("渲染结束")
        
        
    }

   //MARK: - KVO updates
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if firstLocationUpdate == false{
          firstLocationUpdate = true
//            CLLocation *location = [change objectForKey:NSKeyValueChangeNewKey];
//            _mapView.camera = [GMSCameraPosition cameraWithTarget:location.coordinate
//                zoom:14];
            let location = change?[.newKey] as! CLLocation
            
            let coordinate = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            let camara = GMSCameraPosition(target: coordinate, zoom:17, bearing: 0, viewingAngle: 10)
        
            googleMap.camera = camara
        }
    }

}


extension ViewController{
    //MARK: - 定位的方法
    func locateAction() -> Void {
        googleMap.isMyLocationEnabled = true
    }
    
    func filterAction() -> Void {
        googleMap.isBuildingsEnabled = !googleMap.isBuildingsEnabled
        googleMap.isIndoorEnabled =  !googleMap.isIndoorEnabled
        googleMap.accessibilityElementsHidden = !googleMap.accessibilityElementsHidden
    }
    
    
    /// switch map type
    ///
    /// - Parameter sender:
    func segmentSwitchAction(sender:UISegmentedControl) -> Void {
        let index = sender.selectedSegmentIndex
        switch index {
        case 0:
            googleMap.mapType = kGMSTypeNormal
        case 1:
            googleMap.mapType = kGMSTypeSatellite
        case 2:
            googleMap.mapType = kGMSTypeHybrid
        case 3:
            googleMap.mapType = kGMSTypeTerrain
        default:
            break
        }
    }
    
    /// 选定一个地点
    ///
    /// - Parameter sender:
    func pickPlace(sender: UIButton) {
        
        let center = CLLocationCoordinate2DMake(51.5108396, -0.0922251)
        let northEast = CLLocationCoordinate2DMake(center.latitude + 0.001, center.longitude + 0.001)
        let southWest = CLLocationCoordinate2DMake(center.latitude - 0.001, center.longitude - 0.001)
        let viewport = GMSCoordinateBounds(coordinate: northEast, coordinate: southWest)
        
        let config = GMSPlacePickerConfig(viewport: viewport)
        placePicker = GMSPlacePicker(config: config)
        
        placePicker.pickPlace { (place, error) in
            if let error = error{
                print("Pick Place error:\(error.localizedDescription)")
                return
            }
            
            if let place = place{
                
                //create the next view controller,we are going to display and present it
                let nextScreen = PlaceDetailController(place: place)
                
                self.navigationController?.pushViewController(nextScreen, animated: true)
                
                print("Place name \(place.name)")
                print("Place address \(place.formattedAddress)")
                print("Place attributions \(place.attributions)")
            } else {
                print("No place selected")
            }
        }

    }
}

