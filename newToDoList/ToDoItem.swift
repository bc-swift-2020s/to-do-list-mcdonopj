//
//  ToDoItem.swift
//  newToDoList
//
//  Created by Ann McDonough on 2/07/20.
//  Copyright © 2020 Patrick McDonough. All rights reserved.
//

import Foundation


struct ToDoItem: Codable {
    var name: String
    var date: Date
    var notes: String
    var reminderSet: Bool
    var notificationID: String?
    var completed: Bool
}
