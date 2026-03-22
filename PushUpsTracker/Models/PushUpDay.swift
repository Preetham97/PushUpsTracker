//
//  PushUpDay.swift
//  PushUpsTracker
//
//  Created by Preetham Akhil Bhuma on 3/22/26.
//

import Foundation
import SwiftData

@Model
final class PushUpDay {
    var date: Date
    var count: Int

    init(date: Date = .now, count: Int = 0) {
        self.date = Calendar.current.startOfDay(for: date)
        self.count = count
    }

    var formattedDate: String {
        date.formatted(date: .abbreviated, time: .omitted)
    }

    var dayOfWeek: String {
        date.formatted(.dateTime.weekday(.abbreviated))
    }
}
