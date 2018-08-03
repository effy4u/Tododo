//
//  Data.swift
//  tododo
//
//  Created by Kings on 8/3/18.
//  Copyright © 2018 Kings. All rights reserved.
//

import Foundation
import RealmSwift

class Data: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var age: Int = 0
}
