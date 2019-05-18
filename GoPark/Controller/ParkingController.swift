//
//  ParkingController.swift
//  GoPark
//
//  Created by Michael Wong on 19/4/19.
//  Copyright © 2019 MWstudio. All rights reserved.
//  http://52.62.205.70/en/parking.php?duration=5&paid=1&lz=0&disabled=0

import UIKit
import Mapbox
import MapboxCoreNavigation
import MapboxNavigation
import MapboxDirections
import ClusterKit

// MGLPointAnnotation subclass
class MyCustomPointAnnotation: MGLPointAnnotation {
    var bayid = -1
    var duration = -1
    var typeDesc = ""
}


class ParkingController: UIViewController, MGLMapViewDelegate {
    
    @IBOutlet weak var btnServiceArea: UIButton!
    @IBOutlet weak var btnFilter: UIButton!
    @IBAction func btnServiceArea(_ sender: Any) {
        centerViewOnCBDLocation()
    }
    @IBAction func btnFilter(_ sender: Any) {
        
    }
    @IBOutlet weak var btnCenterUser: UIButton!
    @IBAction func btnCenterUser(_ sender: Any) {
        centerViewOnUserLocation()
    }
    var mapView: MGLMapView!
    let locationManager = CLLocationManager()
    let dispatchGroup = DispatchGroup()
    var api1Decodables: [API1Decodable]!
    var annotations = [MyCustomPointAnnotation]() // define an array to store annotation that need to be displayed
    var selectedAnnotation: MyCustomPointAnnotation?
    let CKMapViewDefaultAnnotationViewReuseIdentifier = "annotation"
    let CKMapViewDefaultClusterAnnotationViewReuseIdentifier = "cluster"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //set navigaiton bar title (language)
        self.navigationItem.title = LocalizationSystem.sharedInstance.localizedStringForKey(key: "ParkingController_title", comment: "")
        //set filter (language)
        self.btnFilter.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: "ParkingController_filterButton", comment: ""), for: .normal)
        
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
        
        // setup the btnServiceArea button round corner and shadow
        btnServiceArea.layer.cornerRadius = 10
        btnServiceArea.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
        btnServiceArea.layer.shadowColor = UIColor.lightGray.cgColor
        btnServiceArea.layer.shadowOpacity = 1
        btnServiceArea.layer.shadowOffset = CGSize(width: 3, height: 3)
        btnServiceArea.layer.shadowRadius = 2
        btnServiceArea.layer.borderWidth = 0.3
        btnServiceArea.layer.borderColor = UIColor.darkGray.cgColor
        // setup the btnFilter button round corner and shadow
        btnFilter.layer.cornerRadius = 10
        btnFilter.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]
        btnFilter.layer.shadowColor = UIColor.lightGray.cgColor
        btnFilter.layer.shadowOpacity = 1
        btnFilter.layer.shadowOffset = CGSize(width: 3, height: 3)
        btnFilter.layer.shadowRadius = 2
        // setup the btnCenterUser button shadow
        btnCenterUser.layer.shadowColor = UIColor.lightGray.cgColor
        btnCenterUser.layer.shadowOpacity = 0.8
        btnCenterUser.layer.shadowOffset = CGSize(width: 2, height: 2)
        btnCenterUser.layer.shadowRadius = 2
        
        
        setClusterManager() //set up cluster manager
        checkLocationServices() // after the view is load, check the location service
        
        requestDataFromAPI1() //get data from API1
        
        dispatchGroup.notify(queue: .main){
            self.addParkingSignAnnotation() // add Annotations to the map
        }
        
        
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
            centerViewOnUserLocation() // center the screen to user location
            locationManager.startUpdatingLocation() //
            break
        case .notDetermined: // if permission is not determined, ask for 'authorizedWhenInUse' permission
            locationManager.requestAlwaysAuthorization()
        case .denied, .restricted:
            break
        }
    }
    
    func centerViewOnUserLocation(){
        // if the location of locationManager is not null, center the view to user location
        if let location = locationManager.location?.coordinate{
            mapView.setCenter(CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude), zoomLevel: 13, animated: true)
        }
    }
    
    func centerViewOnCBDLocation(){
        mapView.setCenter(CLLocationCoordinate2D(latitude: -37.810043, longitude: 144.962757), zoomLevel: 12, animated: true)
    }
    
    func setGeofencing(){
        let geofencingRegion = CLCircularRegion(center: CLLocationCoordinate2D(latitude: -37.810043, longitude: 144.962757), radius: 2500, identifier: "Service area") // define a geofencing using a invisible circle region
        locationManager.startMonitoring(for: geofencingRegion) // monitor the geofencing
        locationManager.requestState(for: geofencingRegion) // check whether user already insider or outside the geofencing
    }
    
    func drawGeofencingPolygon() {
        let coordinate = CLLocationCoordinate2D(latitude: -37.810043, longitude: 144.962757)
        let withMeterRadius:Double = 2500
        
        let degreesBetweenPoints = 8.0
        //45 sides
        let numberOfPoints = floor(360.0 / degreesBetweenPoints)
        let distRadians: Double = withMeterRadius / 6371000.0
        // earth radius in meters
        let centerLatRadians: Double = coordinate.latitude * Double.pi / 180
        let centerLonRadians: Double = coordinate.longitude * Double.pi / 180
        var coordinates = [CLLocationCoordinate2D]()
        //array to hold all the points
        for index in 0 ..< Int(numberOfPoints) {
            let degrees: Double = Double(index) * Double(degreesBetweenPoints)
            let degreeRadians: Double = degrees * Double.pi / 180
            let pointLatRadians: Double = asin(sin(centerLatRadians) * cos(distRadians) + cos(centerLatRadians) * sin(distRadians) * cos(degreeRadians))
            let pointLonRadians: Double = centerLonRadians + atan2(sin(degreeRadians) * sin(distRadians) * cos(centerLatRadians), cos(distRadians) - sin(centerLatRadians) * sin(pointLatRadians))
            let pointLat: Double = pointLatRadians * 180 / Double.pi
            let pointLon: Double = pointLonRadians * 180 / Double.pi
            let point: CLLocationCoordinate2D = CLLocationCoordinate2DMake(pointLat, pointLon)
            coordinates.append(point)
        }
        let polygon = MGLPolygon(coordinates: &coordinates, count: UInt(coordinates.count))
        self.mapView.addAnnotation(polygon)
    }
    
    func setClusterManager(){
        let algorithm = CKNonHierarchicalDistanceBasedAlgorithm()
        algorithm.cellSize = 280
        mapView.clusterManager.algorithm = algorithm
        mapView.clusterManager.marginFactor = 0
    }
    
    func requestDataFromAPI1(){
        //enter
        self.dispatchGroup.enter()
        
        //http://52.62.205.70/en/parking.php?paid=1&lz=0&disabled=0
        //https://goparkapi-prodssl.tk/en/parking.php?paid=1&lz=0&disabled=0
        let urlStr = "https://goparkapi-prodssl.tk/en/parking.php" +
                        "?duration=" + UserDefaults.standard.string(forKey: "filterDuration")! +
                        "&paid=" + UserDefaults.standard.string(forKey: "filterPaid")! +
                        "&lz=" + UserDefaults.standard.string(forKey: "filterLoadingZone")! +
                        "&disabled=" + UserDefaults.standard.string(forKey: "filterDisabled")!
        print("API1: " + urlStr)
        let url = URL(string: urlStr)!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        URLSession.shared.dataTask(with: request) {(data, response, error) in
            do{
                if data == nil {
                    return
                }
                //let jsons = try! JSONSerialization.jsonObject(with: data!, options: .mutableContainers)
                //print(jsons)
                
                //decode the data and store in an array call users
                let api1Decodables = try JSONDecoder().decode([API1Decodable].self, from: data!)
                //print(api1Decodables)
                self.api1Decodables = api1Decodables
                //leave
                self.dispatchGroup.leave()
            }catch{
                print("Error info: \(error)")
            }
        }.resume()
    }
    
    func addParkingSignAnnotation(){
        // loop through the parkingSignDecodables array
        for api1Decodable in self.api1Decodables{
            //create annotation
            let myCustomPointAnnotation = MyCustomPointAnnotation()
            myCustomPointAnnotation.coordinate = CLLocationCoordinate2D(latitude: api1Decodable.lat ?? 0, longitude: api1Decodable.lon ?? 0)
            // set callout title
            myCustomPointAnnotation.title = api1Decodable.typedesc ?? "Unknown"
            // set callout subtitle, which store the annotation color
            myCustomPointAnnotation.subtitle = api1Decodable.occRate ?? "blue"
            // set myCustomPointAnnotation added attributes
            myCustomPointAnnotation.bayid = api1Decodable.bayid ?? 0
            myCustomPointAnnotation.duration = api1Decodable.duration ?? 0
            myCustomPointAnnotation.typeDesc = api1Decodable.typedesc ?? "Unknown"
            // append the annotation to the array
            annotations.append(myCustomPointAnnotation)
        }
        // add annotations using the annotation array
        mapView.clusterManager.annotations = annotations
    }
    
    
    // MARK: MGLMapViewDelegate
    
    func mapView(_ mapView: MGLMapView, viewFor annotation: MGLAnnotation) -> MGLAnnotationView? {
        guard let cluster = annotation as? CKCluster else {return nil}
        if cluster.count > 1 {
            return mapView.dequeueReusableAnnotationView(withIdentifier: CKMapViewDefaultClusterAnnotationViewReuseIdentifier) ??
                MBXClusterView(annotation: annotation, reuseIdentifier: CKMapViewDefaultClusterAnnotationViewReuseIdentifier, count: Int(cluster.count))
        }
        return mapView.dequeueReusableAnnotationView(withIdentifier: CKMapViewDefaultAnnotationViewReuseIdentifier) ??
            MBXAnnotationView(annotation: annotation, reuseIdentifier: CKMapViewDefaultAnnotationViewReuseIdentifier)
    }
    
    func mapView(_ mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
        //guard let cluster = annotation as? CKCluster else {return true}
        //return cluster.count == 1 //如果count唯一，就允许callout
        return false
    }
    
    // MARK: - Change map language according to perfer language
    func mapView(_ mapView: MGLMapView, didFinishLoading style: MGLStyle) {
        style.localizeLabels(into: nil)
    }
    
    // MARK: - How To Update Clusters
    func mapView(_ mapView: MGLMapView, regionDidChangeAnimated animated: Bool) {
        mapView.clusterManager.updateClustersIfNeeded()
    }
    
    // MARK: - How To Handle Selection/Deselection
    func mapView(_ mapView: MGLMapView, didSelect annotation: MGLAnnotation) {
        guard let cluster = annotation as? CKCluster else {
            return
        }
        if cluster.count > 1 { //if count>1，zoom in
            let edgePadding = UIEdgeInsetsMake(200, 150, 200, 150) //40, 20, 44, 20
            let camera = mapView.cameraThatFitsCluster(cluster, edgePadding: edgePadding)
            mapView.setCamera(camera, animated: true)
        } else if let annotation = cluster.firstAnnotation { //if=1，select the annotation
            mapView.clusterManager.selectAnnotation(annotation, animated: false);
            let myCustomPointAnnotation = annotation as! MyCustomPointAnnotation // convert the Annotation back to MyCustomPointAnnotation
            selectedAnnotation = myCustomPointAnnotation //set to instance variable selectedAnnotation
            performSegue(withIdentifier: "ParkingToPopupNavigaitonSegue", sender: nil) //popup ParkingPopupController
        }
    }
    
    func mapView(_ mapView: MGLMapView, didDeselect annotation: MGLAnnotation) {
        guard let cluster = annotation as? CKCluster, cluster.count == 1 else {
            return
        }
        mapView.clusterManager.deselectAnnotation(cluster.firstAnnotation, animated: false);
    }
    
    // the follow two map view methods is for drawing polygon (geofencing)
    // geofencing polygon stroke color
    func mapView(_ mapView: MGLMapView, strokeColorForShapeAnnotation annotation: MGLShape) -> UIColor {
        return .white
    }
    
    // geofencing polygon fill color
    func mapView(_ mapView: MGLMapView, fillColorForPolygonAnnotation annotation: MGLPolygon) -> UIColor {
        return UIColor(red: 33/255, green: 150/255, blue: 243/255, alpha: 0.1)
    }
    
    
    // this method create the rotating animation after map view is load.
    func mapViewDidFinishLoadingMap(_ mapView: MGLMapView) {
        // Wait for the map to load before initiating the first camera movement.
        // Create a camera that rotates around the same center point, rotating 30°.
        // `fromDistance:` is meters above mean sea level that an eye would have to be in order to see what the map view is showing.
        let camera = MGLMapCamera(lookingAtCenter: mapView.centerCoordinate, altitude: 2000, pitch: 0, heading: 30)
        // Animate the camera movement over 1.2 seconds.
        mapView.setCamera(camera, withDuration: 1.2, animationTimingFunction: CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut))
    }
    
    // Unwill method. It is called when Navigate button of ParkingPopupNavigationController is clicked.
    @IBAction func unwillParkingPopupNavigationController(sender: UIStoryboardSegue){
        let originWaypoint = Waypoint(coordinate: mapView.userLocation!.coordinate, coordinateAccuracy: -1, name: "Origin")
        let destinationWaypoint = Waypoint(coordinate: selectedAnnotation!.coordinate, coordinateAccuracy: -1, name: "Destination")
        let navigationRouteOptions = NavigationRouteOptions(waypoints: [originWaypoint, destinationWaypoint], profileIdentifier: .automobileAvoidingTraffic)
        
        Directions.shared.calculate(navigationRouteOptions, completionHandler: { (waypoints, routes, error) in
            if (error == nil) {
                let navigationViewController = NavigationViewController(for:(routes?.first)!)
                self.present(navigationViewController, animated: true, completion: nil)
            }
        })
    }
    
    // Unwill method. It is called when ok button of ParkingPopupFilterController is clicked.
    @IBAction func unwillParkingPopupFilterController(sender: UIStoryboardSegue){
        self.mapView.clusterManager.removeAnnotations(annotations) //remove old annotations first
        annotations = [] //clear MyCustomPointAnnotation array
        requestDataFromAPI1() //request new data
        dispatchGroup.notify(queue: .main){
            self.addParkingSignAnnotation() //add new annotation
            self.centerViewOnCBDLocation() //reset the camera to CBD
        }
    }
    
    
    //this method is excuted only when the list from listController is clicked
    func showAnnotaitonSelectedFromList(bayid: Int) {
        for annotation in annotations {
            if annotation.bayid == bayid {
                mapView.clusterManager.selectAnnotation(annotation, animated: true)
                let location = annotation.coordinate
                mapView.setCenter(CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude), zoomLevel: 20, animated: true)
            }
        }
    }
    
     // MARK: - Navigation
    
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ParkingToPopupNavigaitonSegue"
        {
            let parkingPopupNavigationController = segue.destination as? ParkingPopupNavigationController
            parkingPopupNavigationController?.selectedAnnotation = selectedAnnotation
        }
     }
    
}


// MARK: - Custom annotation view

/**
 1P, 1P Meter, 1P Ticket A,
 2P, 2P Meter, 2P Ticket A,
 3P, 3P Meter, 3P Ticket A,
 4P, 4P Meter, 4P Ticket A,
 No Restrictions
 
 P 05 Min
 P 10 Mins
 1/4P, P 15 Min
 1/2P, 1/2P Disabled, 1/2P Meter, 1/2P Ticket A
 1P, 1P Meter, 1P Ticket A, 1P Disabled Only
 2P, 2P Meter, 2P Ticket A, 2P Disabled Only
 3P, 3P Meter, 3P Ticket A, 3P Disabled Only
 4P, 4P Meter, 4P Ticket A, 4P Disabled Only
 No Restrictions
 
 **/

class MBXAnnotationView: MGLAnnotationView {
    var imageView: UIImageView!
    override init(annotation: MGLAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        
        
        let color = annotation?.subtitle
        if color == "green" {
            imageView = UIImageView(image: UIImage(named: "markerGreen"))
        }else if color == "red"{
            imageView = UIImageView(image: UIImage(named: "markerRed"))
        }else{
            imageView = UIImageView(image: UIImage(named: "markerBlue"))
        }
        
        var title = annotation?.title
        if title == "P 05 Min"{
            title = "P5"
        }else if title == "P 10 Mins"{
            title = "P10"
        }else if title == "1/4P" || title == "P 15 Min"{
            title = "P15"
        }else if title == "1/2P" || title == "1/2P Disabled" || title == "1/2P Meter" || title == "1/2P Ticket A"{
            title = "P30"
        }else if title == "1P" || title == "1P Meter" || title == "1P Ticket A" || title == "1P Disabled Only"{
            title = "1P"
        }else if title == "2P" || title == "2P Meter" || title == "2P Ticket A" || title == "2P Disabled Only"{
            title = "2P"
        }else if title == "3P" || title == "3P Meter" || title == "3P Ticket A" || title == "3P Disabled Only"{
            title = "3P"
        }else if title == "4P" || title == "4P Meter" || title == "4P Ticket A" || title == "4P Disabled Only"{
            title = "4P"
        }else if title == "No Restrictions"{
            title = "P"
        }else{
            title = "P"
        }
        
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 20, height: 20)) //a label to display the count of parking spots
        label.text = title ?? "P" //set the text of the label
        label.font = UIFont.boldSystemFont(ofSize: 12.0)
        label.textColor = UIColor.white
        
        label.adjustsFontSizeToFitWidth = true //allow frame to adjust size based on the length of text
        label.textAlignment = .center //set text center to label frame
        label.center = CGPoint(x: imageView.frame.size.width  / 2, y: imageView.frame.size.height / 2) //set label center to image view
        
        
        imageView.addSubview(label) //add ui view to image view.
        
        addSubview(imageView)
        frame = imageView.frame
        isDraggable = true
        centerOffset = CGVector(dx: 0.5, dy: 1)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("Not implemented")
    }
    override func setDragState(_ dragState: MGLAnnotationViewDragState, animated: Bool) {
        super.setDragState(dragState, animated: animated)
        switch dragState {
        case .starting:
            UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 0.5, options: [.curveLinear], animations: {
                self.transform = self.transform.scaledBy(x: 2, y: 2)
            })
        case .ending:
            UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 0.5, options: [.curveLinear], animations: {
                self.transform = CGAffineTransform.identity
            })
        default:
            break
        }
    }
}

class MBXClusterView: MGLAnnotationView {
    init(annotation: MGLAnnotation?, reuseIdentifier: String?, count: Int?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        let imageView = UIImageView(image: UIImage(named: "cluster")) //image view for icon
        //let label = UILabel(frame: CGRect(x: 0, y: 0, width: 35, height: 35)) //a label to display the count of parking spots
        //label.text = String(count ?? 0) //set the text of the label
        //label.font = label.font.withSize(12)
        //label.adjustsFontSizeToFitWidth = true //allow frame to adjust size based on the length of text
        //label.textAlignment = .center //set text center to label frame
        //label.center = CGPoint(x: imageView.frame.size.width  / 2, y: imageView.frame.size.height / 2) //set label center to image view
        //imageView.addSubview(label) //add ui view to image view.
        addSubview(imageView) //add image to mapview
        frame = imageView.frame
        centerOffset = CGVector(dx: 0.5, dy: 1)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("Not implemented")
    }
}




extension ParkingController: CLLocationManagerDelegate{
    
    // this method deal with the Authorization changes
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        // if the Authorization is changed, check which Authorization the user gives and handle each case accordingly
        checkLocationAuthorization()
        // if the authorization is always allow, set geofencing and draw Polygon
        if CLLocationManager.authorizationStatus() == .authorizedAlways {
            setGeofencing()
            drawGeofencingPolygon()
        }
    }
    
    //geofencing
    func locationManager(_ manager: CLLocationManager, didDetermineState state: CLRegionState, for region: CLRegion) {
        switch state {
        case .inside:
            btnServiceArea.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: "ParkingController_topButton_inside", comment: ""), for: .normal)
            print("user already inside")
        case .outside:
            btnServiceArea.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: "ParkingController_topButton_outside", comment: ""), for: .normal)
            print("user already outside")
        default:
            print("impossible")
        }
    }
}
