//
//  MainViewController.swift
//  Test
//
//  Created by Ricky Weng on 2019/2/11.
//  Copyright © 2019 RickyWeng. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
  @IBOutlet weak var tableView: UITableView!

  override func viewDidLoad() {
    super.viewDidLoad()
    NetworkRequest.getParkingLot { (result) in
      switch result {
      case .success(let response):
        print(response)
      case .error(let errorMessage):
        print(errorMessage)
      }
    }
  }
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 1
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    return UITableViewCell()
  }
}
