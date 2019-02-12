//
//  DetailViewController.swift
//  Test
//
//  Created by Ricky Weng on 2019/2/12.
//  Copyright © 2019 RickyWeng. All rights reserved.
//

import UIKit
import MapKit

class DetailViewController: UIViewController {
  @IBOutlet weak var tableView: UITableView!
  var cellModels: [CellConfigurator] = []
  var parkingLot: ParkingLot? {
    didSet {
      guard let parkingLot = parkingLot,
        let name = parkingLot.name,
        let area = parkingLot.area,
        let serviceTime = parkingLot.servicetTime,
        let address = parkingLot.address,
        let tw97X = parkingLot.tw97X,
        let tw97Y = parkingLot.tw97Y else { return }
      guard let coordinateX = Double(tw97X), let coordinateY = Double(tw97Y) else { return }
      // 轉換 TWD97 -> CGS84
      let coordinate2D = ConvertCoordinate.TWD097_to_GWS84(point:
        CGPoint(x: coordinateX, y: coordinateY))
      // 設置cell model
      cellModels = [
        BaseCellConfigurator(item: BaseCellData(title: "停車場名稱", value: name)),
        BaseCellConfigurator(item: BaseCellData(title: "區域", value: area)),
        BaseCellConfigurator(item: BaseCellData(title: "營業時間", value: serviceTime)),
        BaseCellConfigurator(item: BaseCellData(title: "地址", value: address)),
        MapCellConfigurator(item: coordinate2D)
      ]
    }
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    title = "停車場資訊"
    setupTableView()
  }

  private func setupTableView() {
    let bundle = Bundle(for: type(of: self))
    let baseCellNibName = String(describing: BaseTableViewCell.self)
    let baseCellNib = UINib(nibName: baseCellNibName, bundle: bundle)
    tableView.register(baseCellNib, forCellReuseIdentifier: baseCellNibName)
    let mapCellNibName = String(describing: MapTableViewCell.self)
    let mapCellNib = UINib(nibName: mapCellNibName, bundle: bundle)
    tableView.register(mapCellNib, forCellReuseIdentifier: mapCellNibName)
    tableView.delegate = self
    tableView.dataSource = self
  }
}

extension DetailViewController: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    // 設置 MapCell 高度為500, 其他自行運算
    if cellModels[indexPath.row] is MapCellConfigurator {
      return 500
    } else {
      return UITableView.automaticDimension
    }
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return cellModels.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cellModel = cellModels[indexPath.row]
    let cell = tableView.dequeueReusableCell(withIdentifier: type(of: cellModel).reuseId)!
    cellModel.configure(cell: cell)
    return cell
  }
}
