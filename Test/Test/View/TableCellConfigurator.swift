//
//  TableCellConfigurator.swift
//  Test
//
//  Created by Ricky Weng on 2019/2/12.
//  Copyright © 2019 RickyWeng. All rights reserved.
//

import UIKit

protocol ConfigurableCell {
  associatedtype DataType
  func configure(data: DataType)
}

protocol CellConfigurator {
  static var reuseId: String { get }
  func configure(cell: UIView)
}

class TableCellConfigurator<CellType: ConfigurableCell, DataType>: CellConfigurator where CellType.DataType == DataType, CellType: UITableViewCell {
  static var reuseId: String { return String(describing: CellType.self) }
  let item: DataType
  
  init(item: DataType) {
    self.item = item
  }
  
  func configure(cell: UIView) {
    guard let cell = cell as? CellType else { return }
    cell.configure(data: item)
  }
}
