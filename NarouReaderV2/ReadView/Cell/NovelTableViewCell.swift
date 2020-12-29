//
//  NovelTableViewCell.swift
//  NarouReaderV2
//
//  Created by 稲葉夏輝 on 2020/12/19.
//

import UIKit

class NovelTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        self.textLabel?.font = .boldSystemFont(ofSize: 18)
        self.textLabel?.numberOfLines = 0
        self.accessoryType = .detailButton
        // Configure the view for the selected state
    }
    
}
