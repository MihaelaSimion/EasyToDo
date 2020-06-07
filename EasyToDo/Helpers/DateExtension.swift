//
//  DateExtension.swift
//  EasyToDo
//
//  Created by Mihaela Simion on 5/8/20.
//  Copyright © 2020 Mihaela Simion. All rights reserved.
//

import Foundation

extension Date {
    func dateToString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .none
        dateFormatter.dateFormat = "d MMM yyyy"

        return dateFormatter.string(from: self)
    }
}
