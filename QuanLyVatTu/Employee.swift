//
//  Employee.swift
//  QuanLyVatTu
//
//  Created by Macintosh HD on 4/9/20.
//  Copyright © 2020 Macintosh HD. All rights reserved.
//

import Foundation
final class Employee {
    var name = ""
    var employeeCode = ""
    
    init (data: [String: Any]){
        if let name = data["name"] as? String{
            self.name = name
        }
        if let employeeCode = data["employeeCode"] as? String{
            self.employeeCode = employeeCode
        }
    }
}
