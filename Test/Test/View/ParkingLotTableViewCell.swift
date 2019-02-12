//
//  ParkingLotTableViewCell.swift
//  Test
//
//  Created by Ricky Weng on 2019/2/12.
//  Copyright © 2019 RickyWeng. All rights reserved.
//

import UIKit

class ParkingLotTableViewCell: UITableViewCell {
  @IBOutlet var labels: [UILabel]!

  var data: ParkingLot? {
    didSet {
      guard let data = data else { return }
      labels[0].text = data.area ?? ""
      labels[1].text = data.servicetTime ?? ""
      labels[2].text = data.address ?? ""
      labels[3].text = data.name ?? ""
    }
  }
}
