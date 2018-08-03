//
//  CategoryCell.swift
//  tododo
//
//  Created by Kings on 7/26/18.
//  Copyright © 2018 Kings. All rights reserved.
//

import UIKit

class CategoryCell: UITableViewCell {

    @IBOutlet weak var categoryName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(cate: Category)
    {
        self.categoryName.text = cate.name
    }

}
