//
//  ParkingConfirmController.swift
//  GoPark
//
//  Created by Michael Wong on 9/5/19.
//  Copyright © 2019 MWstudio. All rights reserved.
//

import UIKit
import Mapbox
import MapboxCoreNavigation
import MapboxNavigation
import MapboxDirections
import UserNotifications

class ParkingConfirmController: UIViewController, MGLMapViewDelegate {

    
    @IBOutlet weak var viwPopupPanel: UIView!
    @IBOutlet weak var btnDirectToCar: UIButton!
    @IBOutlet weak var btnCancel: UIButton!
    
    
    @IBOutlet weak var lblParkingConfrim: UILabel!
    @IBOutlet weak var lblSetReminder: UILabel!
    @IBOutlet weak var lblCloseScreen: UILabel!
    
    
    
    
    @IBOutlet weak var lblReminder: UILabel!
    @IBOutlet weak var switchReminder: UISwitch!
    @IBOutlet weak var btnCenterUser: UIButton!
    
    @IBAction func btnCenterUser(_ sender: Any) {
        centerViewOnUserLocation()
    }
    
    @IBAction func btnDirectToCar(_ sender: Any) {
        let annotationCoordinate = CLLocationCoordinate2D(latitude: selectedAnnotation!.coordinate.latitude, longitude: selectedAnnotation!.coordinate.longitude)
        
        calculateRoute(from: mapView.userLocation!.coordinate, to: annotationCoordinate) { (route, error) in }
    }
    @IBAction func btnCancel(_ sender: Any) {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests() //remover all notification
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func switchReminder(_ sender: UISwitch) {
        if sender.isOn == false {
            self.lblReminder.text = "Reminder is not activated"
            UNUserNotificationCenter.current().removeAllPendingNotificationRequests() //remover all notification
        }else{
            self.lblReminder.text = "Will remind you at: " + self.caculateRemindTime(addMinute: self.selectedAnnotation!.duration)//caculate the remind time and set the Label
            self.setReminder() //set the notification base on the addMinute
        }
    }
    
    var mapView: MGLMapView!
    let locationManager = CLLocationManager()
    var selectedAnnotation: MyCustomPointAnnotation?
    var route: Route?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //set language
        self.lblParkingConfrim.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "ParkingConfirmController_lblParkingConfrim", comment: "")
        self.lblSetReminder.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "ParkingConfirmController_lblSetReminder", comment: "")
        self.lblCloseScreen.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "ParkingConfirmController_lblCloseScreen", comment: "")
        self.btnDirectToCar.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: "ParkingConfirmController_lblFindMyCar", comment: ""), for: .normal)
        self.btnCancel.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: "ParkingConfirmController_cancelParking", comment: ""), for: .normal)
        
        
        // set button style
        btnDirectToCar.layer.cornerRadius = 5
        btnCancel.layer.cornerRadius = 5
        btnCancel.layer.borderWidth = 1
        btnCancel.layer.borderColor = UIColor(red: 33/255, green: 150/255, blue: 243/255, alpha: 1).cgColor
        // set popup panel style
        viwPopupPanel.layer.cornerRadius = 10
        viwPopupPanel.layer.shadowColor = UIColor.lightGray.cgColor
        viwPopupPanel.layer.shadowOpacity = 1
        viwPopupPanel.layer.shadowOffset = CGSize.zero
        viwPopupPanel.layer.shadowRadius = 10
        // setup the btnCenterUser button shadow
        btnCenterUser.layer.shadowColor = UIColor.lightGray.cgColor
        btnCenterUser.layer.shadowOpacity = 0.8
        btnCenterUser.layer.shadowOffset = CGSize(width: 2, height: 2)
        btnCenterUser.layer.shadowRadius = 2

        
        // Setup map view
        mapView = MGLMapView(frame: view.bounds)
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.styleURL = MGLStyle.lightStyleURL
        mapView.delegate = self
        mapView.tintColor = UIColor(red: 117/255, green: 188/255, blue: 236/255, alpha: 1) // Set map user annotation style (light blue)
        mapView.userTrackingMode = .followWithHeading // set tracking mode to heading
        mapView.showsUserHeadingIndicator = true // show the arrow to indicate user heading
        mapView.logoView.isHidden = true //remove mapbox logo
        mapView.attributionButton.isHidden = true //remove mapbox info icon
        view.addSubview(mapView)
        view.sendSubview(toBack: mapView) // bring the mapview to back, otherwise, the ui elements will be covered
        
        checkLocationServices() // after the view is load, check the location service
        
        //ask for notificaion Authorization request permission and set remind label
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound])
        { (granted, error) in
            if granted == true{ //if notification is granted
                DispatchQueue.main.async {
                    self.switchReminder.isUserInteractionEnabled = true
                    self.lblReminder.text = "Reminder is not activated"
                    // if duration is 0, set switch to be not interactable
                    if self.selectedAnnotation!.duration < 20 {
                        self.switchReminder.isUserInteractionEnabled = false
                        if LocalizationSystem.sharedInstance.getLanguage() == "en" {
                            self.lblReminder.text = "Cannot remind if less than 15 mins"
                        }else if LocalizationSystem.sharedInstance.getLanguage() == "zh-Hans" {
                            self.lblReminder.text = "如果低于15分钟，无法提醒"
                        }
                    }
                }
            }else{ //if notification deny
                DispatchQueue.main.async {
                    self.lblReminder.text = "Without notification permission"
                    self.switchReminder.isUserInteractionEnabled = false
                }
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        centerViewOnAnnotationLocation()
        mapView.addAnnotation(selectedAnnotation!)
    }
    
    func checkLocationServices(){
        if CLLocationManager.locationServicesEnabled(){ // if location service is enabled
            locationManager.delegate = self // set up location manager delegate
            locationManager.desiredAccuracy = kCLLocationAccuracyBest// set up location manager
            checkLocationAuthorization() // and check location authorization
        }else{
            // show an alert to ask user to turn on location service
        }
    }
    
    func checkLocationAuthorization(){
        switch CLLocationManager.authorizationStatus() {
        case .authorizedAlways, .authorizedWhenInUse: // if have this permission,
            mapView.showsUserLocation = true // map display user's current location
            locationManager.startUpdatingLocation() //
            break
        case .notDetermined: // if permission is not determined, ask for 'authorizedWhenInUse' permission
            locationManager.requestAlwaysAuthorization()
        case .denied, .restricted:
            break
        }
    }
    
    func centerViewOnAnnotationLocation(){
        mapView.setCenter(CLLocationCoordinate2D(latitude: selectedAnnotation!.coordinate.latitude, longitude: selectedAnnotation!.coordinate.longitude), zoomLevel: 20, animated: false)
    }
    
    func centerViewOnUserLocation(){
        // if the location of locationManager is not null, center the view to user location
        if let location = locationManager.location?.coordinate{
            mapView.setCenter(CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude), zoomLevel: 13, animated: true)
        }
    }
    
    func caculateRemindTime(addMinute: Int) -> String {
        let currentTime = Date()
        let calendar = Calendar.current
        let newAddMinute = addMinute - 10
        let remindTime = calendar.date(byAdding: .minute, value: newAddMinute, to: currentTime)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm"
        return dateFormatter.string(from: remindTime!)
    }
    
    func setReminder(){
        //set notification content
        let content = UNMutableNotificationContent()
        content.title = "Times up"
        content.subtitle = "You should take your car"
        content.badge = 1
        content.sound = UNNotificationSound.defaultCritical
        //set a count down timer to trigger notification
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: Double(selectedAnnotation!.duration), repeats: false)
        let request = UNNotificationRequest(identifier: "timerDone", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
    
    func calculateRoute(from originCoordinate: CLLocationCoordinate2D, to destinationCoordinate: CLLocationCoordinate2D, completion: @escaping (Route?, Error) -> Void){
        let originWaypoint = Waypoint(coordinate: originCoordinate, coordinateAccuracy: -1, name: "Origin")
        let destinationWaypoint = Waypoint(coordinate: destinationCoordinate, coordinateAccuracy: -1, name: "Destination")
        let navigationRouteOptions = NavigationRouteOptions(waypoints: [originWaypoint, destinationWaypoint], profileIdentifier: .walking)
        
        Directions.shared.calculate(navigationRouteOptions, completionHandler: { (waypoints, routes, error) in
            self.route = routes?.first
            //call画路线
            self.drawRoute(route: self.route!)
            //设置画图后mapview显示区域
            let coordinateBounds = MGLCoordinateBounds(sw: destinationCoordinate, ne: originCoordinate)
            let insets = UIEdgeInsets(top: 50, left: 50, bottom: 300, right: 50)
            let routeCamera = self.mapView.cameraThatFitsCoordinateBounds(coordinateBounds, edgePadding: insets)
            self.mapView.setCamera(routeCamera, animated: true)
        })
    }
    
    //画路线
    func drawRoute(route: Route){
        guard route.coordinateCount > 0 else { return }
        // Convert the route’s coordinates into a polyline
        var routeCoordinates = route.coordinates!
        let polyline = MGLPolylineFeature(coordinates: &routeCoordinates, count: route.coordinateCount)
        
        // If there's already a route line on the map, reset its shape to the new route
        if let source = mapView.style?.source(withIdentifier: "route-source") as? MGLShapeSource {
            source.shape = polyline
        } else {
            let source = MGLShapeSource(identifier: "route-source", features: [polyline], options: nil)
            // Customize the route line color and width
            let lineStyleLayer = MGLLineStyleLayer(identifier: "route-style", source: source)
            lineStyleLayer.lineColor = NSExpression(forConstantValue: UIColor.blue)
            lineStyleLayer.lineWidth = NSExpression(forConstantValue: 5)
            // Add the source and style layer of the route line to the map
            mapView.style?.addSource(source)
            mapView.style?.addLayer(lineStyleLayer)
        }
    }
    
    
    func mapView(_ mapView: MGLMapView, imageFor annotation: MGLAnnotation) -> MGLAnnotationImage? {
        
        // For better performance, always try to reuse existing annotations.
        var annotationImage = mapView.dequeueReusableAnnotationImage(withIdentifier: "carIcon")
        
        // If there is no reusable annotation image available, initialize a new one.
        if(annotationImage == nil) {
            annotationImage = MGLAnnotationImage(image: UIImage(named: "carIcon")!, reuseIdentifier: "carIcon")
        }
        
        return annotationImage
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension ParkingConfirmController: CLLocationManagerDelegate{
    
    // this method deal with the Authorization changes
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        // if the Authorization is changed, check which Authorization the user gives and handle each case accordingly
        checkLocationAuthorization()
    }
}
