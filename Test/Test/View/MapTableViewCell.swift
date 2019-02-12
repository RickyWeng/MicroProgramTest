//
//  MapTableViewCell.swift
//  Test
//
//  Created by Ricky Weng on 2019/2/12.
//  Copyright © 2019 RickyWeng. All rights reserved.
//

import UIKit
import MapKit

typealias MapCellConfigurator = TableCellConfigurator<MapTableViewCell, CLLocationCoordinate2D>

// 停車場座標
final class ParkingLotAnnotation: NSObject, MKAnnotation {
  var coordinate: CLLocationCoordinate2D

  init(coordinate: CLLocationCoordinate2D) {
    self.coordinate = coordinate
  }
}

class MapTableViewCell: UITableViewCell, ConfigurableCell {
  @IBOutlet weak var mapView: MKMapView!
  /// 規劃路線按鈕
  @IBOutlet weak var routeButton: UIButton!
  typealias DataType = CLLocationCoordinate2D
  var data: DataType?

  lazy var locationManager: CLLocationManager = {
    let locationManager = CLLocationManager()
    locationManager.distanceFilter = kCLLocationAccuracyBestForNavigation
    locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
    return locationManager
  }()

  func configure(data: CLLocationCoordinate2D) {
    self.data = data
    updateLocation()
    setupMapView()
  }

  private func updateLocation() {
    // 取得定位權限
    if CLLocationManager.authorizationStatus() == .notDetermined {
      locationManager.requestAlwaysAuthorization()
      locationManager.startUpdatingLocation()
    } else {
      locationManager.startUpdatingLocation()
    }
  }

  private func setupMapView() {
    mapView.mapType = .standard
    mapView.showsUserLocation = true
    mapView.isZoomEnabled = true
    mapView.delegate = self
    guard let data = data else { return }
    // 加入座標
    mapView.addAnnotation(ParkingLotAnnotation(coordinate: data))
    // 設置地圖範圍
    let locationSpan = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
    let region = MKCoordinateRegion(center: data, span: locationSpan)
    mapView.setRegion(region, animated: false)
  }

  @IBAction func directionRequest(_ sender: Any) {
    guard let data = data, let userCorrdinate = locationManager.location?.coordinate else { return }
    let sourcePlaceMark = MKPlacemark(coordinate: userCorrdinate)
    let destinationPlaceMark = MKPlacemark(coordinate: data)
    let directionRequest = MKDirections.Request()
    directionRequest.source = MKMapItem(placemark: sourcePlaceMark)
    directionRequest.destination = MKMapItem(placemark: destinationPlaceMark)
    directionRequest.transportType = .automobile
    let directions = MKDirections(request: directionRequest)
    // 規劃路線
    directions.calculate { (response, error) in
      guard let route = response?.routes.first else {
        print(error.debugDescription)
        return
      }

      self.mapView.addOverlay(route.polyline, level: .aboveRoads)
      let rect = route.polyline.boundingMapRect
      self.mapView.setRegion(MKCoordinateRegion(rect), animated: true)
    }
  }
}

extension MapTableViewCell: MKMapViewDelegate {
  func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
    if annotation is MKUserLocation {
      return nil
    } else {
      return MKMarkerAnnotationView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
    }
  }

  func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
    let renderer = MKPolylineRenderer(overlay: overlay)
    renderer.strokeColor = UIColor.blue
    renderer.lineWidth = 4
    return renderer
  }
}
