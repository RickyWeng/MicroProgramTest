//
//  BaseTableViewCell.swift
//  Test
//
//  Created by Ricky Weng on 2019/2/12.
//  Copyright © 2019 RickyWeng. All rights reserved.
//

import UIKit

struct BaseCellData {
  var title: String
  var value: String
}

typealias BaseCellConfigurator = TableCellConfigurator<BaseTableViewCell, BaseCellData>
class BaseTableViewCell: UITableViewCell, ConfigurableCell {
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var valueLabel: UILabel!
  typealias DataType = BaseCellData

  func configure(data: DataType) {
    titleLabel.text = data.title
    valueLabel.text = data.value
  }
}
