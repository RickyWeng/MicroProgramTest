//
//  NetworkRequest.swift
//  Test
//
//  Created by Ricky Weng on 2019/2/11.
//  Copyright © 2019 RickyWeng. All rights reserved.
//

import Foundation

enum NetworkResult<T> {
  case success(T)
  case error(String)
}

class NetworkRequest {
  static let url = URL(string: "http://data.ntpc.gov.tw/api/v1/rest/datastore/382000000A-000225-002")
  class func getParkingLot(completion: ((NetworkResult<GetParkingLotResponse>) -> Void)?) {
    // 建立網路請求
    guard let url = url else { return }
    var request = URLRequest(url: url)
    request.httpMethod = "GET"
    URLSession.shared.dataTask(with: request) { (data, response, error) in
      guard let data = data, error == nil else {
        DispatchQueue.main.async {
          completion?(.error(error.debugDescription))
        }
        return
      }

      // 解碼成 GetParkingLotResponse 結構
      let decoder = JSONDecoder()
      do {
        let getParkingLotResponse = try decoder.decode(GetParkingLotResponse.self, from: data)
        // 儲存資料至 CoreData
        let parkingLotMangaer = ParkingLotManager()
        switch parkingLotMangaer.add(records: getParkingLotResponse.result.records) {
        case .success:
          print("added parking lot to CoreData")
        case .failure(let error):
          print(error.description)
        }

        DispatchQueue.main.async {
          completion?(.success(getParkingLotResponse))
        }
      } catch {
        DispatchQueue.main.async {
          completion?(.error("Decoding Error"))
        }
      }
    }.resume()
  }
}
