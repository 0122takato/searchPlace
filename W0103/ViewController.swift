//
//  ViewController.swift
//  W0103
//
//  Created by 新谷威人 on 2021/07/16.
//

import UIKit
import WebKit
import MapKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate,UITextFieldDelegate {
    @IBOutlet weak var displayMap: MKMapView!
    @IBOutlet weak var trackButton: UIButton!
    @IBOutlet weak var changeMap: UIButton!
    @IBOutlet weak var latitude: UILabel!
    @IBOutlet weak var longitude: UILabel!
    @IBOutlet weak var serch: UITextField!
    @IBOutlet weak var cancel: UIButton!
    var myLocationManager:CLLocationManager!
    var nowAnnotations: [MKAnnotation] = [ ]
    var serchAnnotations: [MKAnnotation] = [ ]
    var track: [MKAnnotation] = [ ]
    override func viewDidLoad() {
        super.viewDidLoad()
        myLocationManager = CLLocationManager()
        myLocationManager.requestWhenInUseAuthorization()
        myLocationManager.delegate = self
        // 初回のPINの処理
        let center = CLLocationCoordinate2D(latitude: 35.6916554,longitude: 139.6947481)
        let span = MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
        let region = MKCoordinateRegion(center: center, span: span)
            displayMap.setRegion(region, animated:true)
        let pin = MKPointAnnotation()
            pin.coordinate = center
            pin.title="HAL東京"
            self.latitude.text = "緯度:"+(pin.coordinate.latitude.description)
            self.longitude.text = "経度:"+(pin.coordinate.longitude.description)
            displayMap.addAnnotation(pin)
            serch.delegate = self
    }


    // 下のボタンを押した時のそれぞれの処理
    @IBAction func myButtonAction(_ sender: Any) {
        let buttonTagButton:UIButton = sender as! UIButton
        let buttonTag = buttonTagButton.tag
        switch buttonTag{
        case 0:
            let center = CLLocationCoordinate2D(latitude: 34.70003375219457,longitude: 135.4931607436453)
            let span = MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
            let region = MKCoordinateRegion(center: center, span: span)
                displayMap.setRegion(region, animated:true)
            let pin = MKPointAnnotation()
                pin.coordinate = center
                pin.title="HAL大阪"
                self.latitude.text = "緯度:"+(pin.coordinate.latitude.description)
                self.longitude.text = "経度:"+(pin.coordinate.longitude.description)
                displayMap.addAnnotation(pin)
        case 1:
            let center = CLLocationCoordinate2D(latitude: 34.702679428643776,longitude: 135.49601497063125)
            let span = MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)//1度...111km
            let region = MKCoordinateRegion(center: center, span: span)
                displayMap.setRegion(region, animated:true)
            let pin = MKPointAnnotation()
                pin.coordinate = center
                pin.title="大阪駅"
                self.latitude.text = "緯度:"+(pin.coordinate.latitude.description)
                self.longitude.text = "経度:"+(pin.coordinate.longitude.description)
                displayMap.addAnnotation(pin)
        case 2:
            let center = CLLocationCoordinate2D(latitude: 35.1682626074436,longitude: 136.88570099948018)
            let span = MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)//1度...111km
            let region = MKCoordinateRegion(center: center, span: span)
                displayMap.setRegion(region, animated:true)
            
            let pin = MKPointAnnotation()
                pin.coordinate = center
                pin.title="HAL名古屋"
            self.latitude.text = "緯度:"+(pin.coordinate.latitude.description)
            self.longitude.text = "経度:"+(pin.coordinate.longitude.description)
                displayMap.addAnnotation(pin)
        default:
            break
        }
    }
    // 緯度・経度に変更があった場合の処理
    func locationManager(_ manager: CLLocationManager,didUpdateLocations locations: [CLLocation]) {
        print("緯度:" + (manager.location?.coordinate.latitude.description)!)
        print("経度:" + (manager.location?.coordinate.longitude.description)!)
        latitude.text = "緯度:"+(manager.location?.coordinate.latitude.description)!
        longitude.text = "経度:"+(manager.location?.coordinate.longitude.description)!
        if let nowCoordinate = manager.location?.coordinate{
            print(nowCoordinate)
            let pin = MKPointAnnotation()
            pin.coordinate = nowCoordinate
            displayMap.addAnnotation(pin)
            let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
            let region = MKCoordinateRegion(center: nowCoordinate, span: span)
            displayMap.setRegion(region, animated: true)
        }
    }
    // 緯度・経度の取得失敗できなかった場合の処理
    func locationManager(_ manager: CLLocationManager,didFailWithError error: Error){
        print(error)
    }
    
    // 切替ボタンぼ処理
    @IBAction func mapChangePush(_ sender: Any) {
        if displayMap.mapType == .hybrid{ displayMap.mapType = .standard
        }
        else if displayMap.mapType == .standard{ displayMap.mapType = .satellite
        }
        else if displayMap.mapType == .satellite{ displayMap.mapType = .hybrid
        }
        
    }
    
    // 検索の処理
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    displayMap.removeAnnotations(serchAnnotations)
    let queryText = serch.text
    let request = MKLocalSearch.Request()
    request.naturalLanguageQuery = queryText
    let localSearch:MKLocalSearch = MKLocalSearch(request: request)
    localSearch.start(completionHandler: {(result, error) in
        if(error == nil) {
            let placemark = (result?.mapItems[0].placemark)!
            let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta:
            0.01)
            let region = MKCoordinateRegion(center: placemark.coordinate,
            span: span)
            self.displayMap.setRegion(region, animated:true)
            let pin2 = MKPointAnnotation()
            pin2.coordinate = placemark.coordinate
            pin2.title = queryText
            self.displayMap.addAnnotation(pin2)
            self.serchAnnotations.append(pin2)
            self.latitude.text = "緯度:"+(pin2.coordinate.latitude.description)
            self.longitude.text = "経度:"+(pin2.coordinate.longitude.description)
            
        }
        else {
            print(error ?? "default")
        }
    })
    serch.resignFirstResponder()
    return true
    }
    
    // キャンセルボタンの処理
    @IBAction func cancelClear(_ sender: Any) {
        displayMap.removeAnnotations(serchAnnotations)
        serch.text = ""
    }
    
    // トラッキングの処理
    @IBAction func buttonPush(_ sender: Any) {
        let button:UIButton = sender as! UIButton
        let pin = MKPointAnnotation()
        if button.currentTitle == "トラッキング開始" {
            trackButton.setTitle("停止", for: .normal)
            nowAnnotations.append( pin )
            myLocationManager.startUpdatingLocation()
        }
        else if button.currentTitle == "停止" {
            trackButton.setTitle("トラッキング開始", for: .normal)
            nowAnnotations.append( pin )
            myLocationManager.stopUpdatingLocation()
        }
    }
}

