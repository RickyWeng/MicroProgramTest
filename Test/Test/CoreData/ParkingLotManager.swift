//
//  ParkingLotManager.swift
//  Test
//
//  Created by Ricky Weng on 2019/2/11.
//  Copyright © 2019 RickyWeng. All rights reserved.
//

import CoreData

// every NSManagedObject need to inherit "EntityNamable" protocol
extension ParkingLot: EntityNamable {
  static var entityName: String { return "ParkingLot" }
}

struct ParkingLotManager {
  // 透過 [GetParkingLotRecord] 新增 ParkingLot Enitity
  func add(records: [GetParkingLotRecord]) -> CoreDataResult {
    // 避免同樣id的資料重複新增
    let ids = getAll().map({ return $0.id })
    for record in records where !ids.contains(record.id) {
      guard let parkingLot: ParkingLot = CoreDataManager.shared.new()
        else { return CoreDataResult.failure(.newManagedObjectFailed) }
      parkingLot.id = record.id
      parkingLot.area = record.area
      parkingLot.name = record.name
      parkingLot.type = record.type
      parkingLot.summary = record.summary
      parkingLot.address = record.address
      parkingLot.tel = record.tel
      parkingLot.payex = record.payex
      parkingLot.servicetTime = record.serviceTime
      parkingLot.tw97X = record.tw97X
      parkingLot.tw97Y = record.tw97Y
      parkingLot.totalCar = record.totalCar
      parkingLot.totalMotor = record.totalMotor
      parkingLot.totalBike = record.totalBike
    }

    CoreDataManager.shared.saveContext()
    return CoreDataResult.success
  }

  // 透過 停車場名稱 查詢 ParkingLot Enitity
  func get(name: String) -> [ParkingLot] {
    let request: NSFetchRequest<ParkingLot> = ParkingLot.fetchRequest()
    request.predicate = NSPredicate(format: "name == %@", name)
    request.sortDescriptors = [NSSortDescriptor(key: "id", ascending: true)]
    return CoreDataManager.shared.fetch(request: request)
  }

  // 透過 地區名稱 查詢 ParkingLot Enitity
  func get(area: String) -> [ParkingLot] {
    let request: NSFetchRequest<ParkingLot> = ParkingLot.fetchRequest()
    request.sortDescriptors = [NSSortDescriptor(key: "id", ascending: true)]
    return CoreDataManager.shared.fetch(request: request)
  }

  // 查詢所有 ParkingLot Enitity
  func getAll() -> [ParkingLot] {
    let request: NSFetchRequest<ParkingLot> = ParkingLot.fetchRequest()
    request.sortDescriptors = [NSSortDescriptor(key: "id", ascending: true)]
    return CoreDataManager.shared.fetch(request: request)
  }
}
