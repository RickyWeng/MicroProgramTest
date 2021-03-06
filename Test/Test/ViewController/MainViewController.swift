//
//  MainViewController.swift
//  Test
//
//  Created by Ricky Weng on 2019/2/11.
//  Copyright © 2019 RickyWeng. All rights reserved.
//

import UIKit
import SVProgressHUD

class MainViewController: UIViewController {
  @IBOutlet weak var searchBar: UISearchBar!
  @IBOutlet weak var tableView: UITableView!
  var datas: [ParkingLot] = []
  let parkingLotManager = ParkingLotManager()
  lazy var refreshControl: UIRefreshControl = {
    let refreshControl = UIRefreshControl()
    refreshControl.backgroundColor = UIColor.clear
    refreshControl.tintColor = UIColor.clear
    refreshControl.addTarget(self, action: #selector(getParkingLot), for: .valueChanged)
    return refreshControl
  }()

  override func viewDidLoad() {
    super.viewDidLoad()
    title = "停車場"
    setupTableView()
    getParkingLot()
    searchBar.delegate = self
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    // 取消已選 Cell
    if let selectedRow = tableView.indexPathForSelectedRow {
      tableView.deselectRow(at: selectedRow, animated: false)
    }
  }

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if let detailViewController = segue.destination as? DetailViewController,
      let parkingLot = sender as? ParkingLot {
      detailViewController.parkingLot = parkingLot
    }
  }

  @objc private func getParkingLot() {
    SVProgressHUD.show()
    NetworkRequest.getParkingLot { (result) in
      SVProgressHUD.dismiss()
      self.refreshControl.endRefreshing()
      switch result {
      case .success(let response):
        print(response)
        self.datas = self.parkingLotManager.getAll()
        self.tableView.reloadData()
      case .error(let errorMessage):
        print(errorMessage)
      }
    }
  }

  private func setupTableView() {
    let bundle = Bundle(for: type(of: self))
    let nib = UINib(nibName: "ParkingLotTableViewCell", bundle: bundle)
    tableView.register(nib, forCellReuseIdentifier: "cell")
    tableView.delegate = self
    tableView.dataSource = self
    // 增加刷新元件
    tableView.addSubview(refreshControl)
  }
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return datas.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
      as? ParkingLotTableViewCell else { return UITableViewCell() }
    cell.data = datas[indexPath.row]
    return cell
  }

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    performSegue(withIdentifier: "DisplayDetailViewController", sender: datas[indexPath.row])
  }
}

extension MainViewController: UISearchBarDelegate {
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    view.endEditing(true)
    SVProgressHUD.show()
    // 從 CoreData 讀取資料
    if let text = searchBar.text, text != "" {
      datas = parkingLotManager.get(key: text)
    } else {
      datas = parkingLotManager.getAll()
    }

    tableView.reloadData()
    SVProgressHUD.dismiss(withDelay: 0.3)
  }
}
