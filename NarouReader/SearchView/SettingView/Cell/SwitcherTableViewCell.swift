//
//  SwitcherTableViewCell.swift
//  NarouReader
//
//  Created by 稲葉夏輝 on 2021/01/06.
//

import UIKit

class SwitcherTableViewCell: UITableViewCell {
    
    @IBOutlet weak var switcher: UISwitch!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
