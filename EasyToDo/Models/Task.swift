//
//  Task.swift
//  EasyToDo
//
//  Created by Mihaela Simion on 5/8/20.
//  Copyright © 2020 Mihaela Simion. All rights reserved.
//

import Foundation
import RealmSwift

enum Priority: Int {
    case high = 3
    case medium = 2
    case low = 1
}

class Task: Object {
    @objc dynamic var content: String?
    @objc dynamic var createdDate = Date()
    @objc dynamic var doneDate: Date?
    @objc dynamic var done = false
    @objc dynamic var priority = 3
}
