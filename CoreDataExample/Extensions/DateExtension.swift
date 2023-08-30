//
//  DateExtension.swift
//  CoreDataExample
//
//  Created by Vipul Negi on 17/08/23.
//

import Foundation

extension Date {
  var millisecondsSince1970:Int64 {
    Int64((self.timeIntervalSince1970 * 1000.0).rounded())
  }
  
  init(milliseconds:Int64) {
    self = Date(timeIntervalSince1970: TimeInterval(milliseconds) / 1000)
  }
  
  func minutes(from date: Date) -> Int {
      return Calendar.current.dateComponents([.minute], from: date, to: self).minute ?? 0
  }
  
  func seconds(from date: Date) -> Int {
      return Calendar.current.dateComponents([.second], from: date, to: self).second ?? 0
  }
  
}
