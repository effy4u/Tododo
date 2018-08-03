//
//  itemCell.swift
//  tododo
//
//  Created by Kings on 7/24/18.
//  Copyright © 2018 Kings. All rights reserved.
//

import UIKit

class itemCell: UITableViewCell {

    @IBOutlet weak var itemName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func updateCell(item: Item)
    {
        self.itemName.text = item.title
    }

}
