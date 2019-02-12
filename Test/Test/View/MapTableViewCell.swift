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
class MapTableViewCell: UITableViewCell, ConfigurableCell {
  @IBOutlet weak var mapView: MKMapView!
  @IBOutlet weak var routeButton: UIButton!
  typealias DataType = CLLocationCoordinate2D

  func configure(data: CLLocationCoordinate2D) {
    
  }

  override func awakeFromNib() {
    super.awakeFromNib()
    mapView.mapType = .standard
    mapView.showsUserLocation = true
    mapView.isZoomEnabled = true
    mapView.delegate = self
  }
}

extension MapTableViewCell: MKMapViewDelegate {
  
}
