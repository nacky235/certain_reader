//
//  OutlineCell.swift
//  NarouReader
//
//  Created by 稲葉夏輝 on 2020/12/20.
//

import UIKit

class OutlineCell: UITableViewCell {

    @IBOutlet weak var contentLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
