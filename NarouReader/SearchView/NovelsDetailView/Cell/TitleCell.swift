//
//  TitleCell.swift
//  NarouReader
//
//  Created by 稲葉夏輝 on 2020/12/20.
//

import UIKit

class TitleCell: UITableViewCell {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        self.textLabel?.numberOfLines = 0
        self.textLabel?.font = UIFont.boldSystemFont(ofSize: 32)
        // Configure the view for the selected state
    }
    
}
