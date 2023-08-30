//
//  EncodableExtension.swift
//  CoreDataExample
//
//  Created by Vipul Negi on 17/08/23.
//

import Foundation
import UIKit

extension Encodable {
    func toJSONString() -> String {
        let jsonData = try! JSONEncoder().encode(self)
        return String(data: jsonData, encoding: .utf8)!
    }
}


