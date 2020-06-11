//
//  DateHelper.swift
//  Edana
//
//  Created by TinhPV on 6/12/20.
//  Copyright © 2020 TinhPV. All rights reserved.
//

import Foundation


struct TimeHelper {
    static func convertToTime(timestamp: Int) -> String {
        let timestampDate = Date(timeIntervalSince1970: TimeInterval(timestamp))
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm a"
        return dateFormatter.string(from: timestampDate)
    }
}
