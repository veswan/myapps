//
//  ViewController.swift
//  Memorable Places
//
//  Created by Vishwan  aranha on 10/23/16.
//  Copyright © 2016 Vishwan  aranha. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
class ViewController: UIViewController,MKMapViewDelegate,CLLocationManagerDelegate {

    @IBOutlet var map: MKMapView!
    var manager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let uilpgr = UILongPressGestureRecognizer(target: self, action: #selector(ViewController.longpress(gestureRecognizer:)))
        uilpgr.minimumPressDuration = 2
        map.addGestureRecognizer(uilpgr)
        
        if activePlace == -1{
            manager.delegate = self
            manager.desiredAccuracy = kCLLocationAccuracyBest
            manager.requestWhenInUseAuthorization()
            manager.startUpdatingLocation()
        }else{
            if places.count > activePlace{
                if let name = places[activePlace]["name"]{
                    if let lat = places[activePlace]["lat"]{
                        if let long = places[activePlace]["long"]{
                            if let latitude = Double(lat){
                                if let longitude = Double(long){
                                    let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
                                    let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                                    let region = MKCoordinateRegion(center: coordinate, span: span)
                                    self.map.setRegion(region, animated: true)
                                    
                                    let annotation = MKPointAnnotation()
                                    annotation.coordinate = coordinate
                                    annotation.title = name
                                    self.map.addAnnotation(annotation)
                                    
                                }
                            }
                        }
                    }
                }
            }
        }
        print(activePlace)
    }
    func longpress(gestureRecognizer:UIGestureRecognizer){
        
        if gestureRecognizer.state == UIGestureRecognizerState.began{
        let touchPoint = gestureRecognizer.location(in: map)
        let newcoordinate = self.map.convert(touchPoint, toCoordinateFrom: self.map)
        let location = CLLocation(latitude: newcoordinate.latitude, longitude: newcoordinate.longitude)
            var title = ""
            CLGeocoder().reverseGeocodeLocation(location,completionHandler:{
                (placemarks,error) in
                
                if error != nil {
                    print(error)
                }else{
                    
                    
                    if let placemark = placemarks?[0]{
                        
                        if placemark.subThoroughfare != nil {
                            title += placemark.subThoroughfare! + " "
                            
                        }
                        if placemark.thoroughfare != nil {
                            title += placemark.thoroughfare!
                            
                        }

                        
                    }
                }
                if title == ""{
                    title = "Added \(NSDate())"
                }
                let annotation = MKPointAnnotation()
                annotation.coordinate = newcoordinate
                annotation.title = title
                
                self.map.addAnnotation(annotation)
                
                places.append(["name":title,"lat":String(newcoordinate.latitude) ,"long":String(newcoordinate.longitude)])
                UserDefaults.standard.set(places, forKey: "places")


                })
                }
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = CLLocationCoordinate2D(latitude: locations[0].coordinate.latitude, longitude: locations[0].coordinate.longitude)
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: location, span: span)
        self.map.setRegion(region, animated: true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

