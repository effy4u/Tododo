//
//  Item.swift
//  tododo
//
//  Created by Kings on 8/3/18.
//  Copyright © 2018 Kings. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    @objc dynamic var dateCreated: Date?
    var parentCate = LinkingObjects(fromType: CatGory.self, property: "items" )
}
