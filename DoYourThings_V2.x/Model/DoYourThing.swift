//
//  DoYourThing.swift
//  DoYourThings_V2.x
//
//  Created by RGMCode on 13.07.24.
//

import Foundation

struct DoYourThing: Identifiable, Hashable {
    var id: UUID
    var dytTitel: String
    var dytDetailtext: String
    var dytPriority: String
    var dytCategory: String
    var dytTime: Date
    var dytDate: Date
    var dytAlarmReminderDate: Date
    var dytAlarmReminderTime: Date
    var dytAlarmDeadlineDate: Date
    var dytAlarmDeadlineTime: Date
}

