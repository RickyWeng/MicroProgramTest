//
//  ParkingLotResponse.swift
//  Test
//
//  Created by Ricky Weng on 2019/2/11.
//  Copyright © 2019 RickyWeng. All rights reserved.
//

import Foundation

// 停車場 API Response
// swiftlint:disable all
struct GetParkingLotResponse: Codable {
  let success: Bool
  let result: GetParkingLotResult
}

struct GetParkingLotResult: Codable {
  let resourceID: String
  let limit, total: Int
  let fields: [GetParkingLotField]
  let records: [GetParkingLotRecord]

  enum CodingKeys: String, CodingKey {
    case resourceID = "resource_id"
    case limit, total, fields, records
  }
}

struct GetParkingLotField: Codable {
  let type: TypeEnum
  let id: String
}

enum TypeEnum: String, Codable {
  case text = "text"
}

struct GetParkingLotRecord: Codable {
  let id: String
  let area: String
  let name, type: String
  let summary: String
  let address, tel, payex, serviceTime: String
  let tw97X, tw97Y, totalCar, totalMotor: String
  let totalBike: String

  enum CodingKeys: String, CodingKey {
    case id = "ID"
    case area = "AREA"
    case name = "NAME"
    case type = "TYPE"
    case summary = "SUMMARY"
    case address = "ADDRESS"
    case tel = "TEL"
    case payex = "PAYEX"
    case serviceTime = "SERVICETIME"
    case tw97X = "TW97X"
    case tw97Y = "TW97Y"
    case totalCar = "TOTALCAR"
    case totalMotor = "TOTALMOTOR"
    case totalBike = "TOTALBIKE"
  }
}
