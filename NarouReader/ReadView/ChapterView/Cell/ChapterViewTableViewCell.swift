//
//  ChapterViewTableViewCell.swift
//  NarouReader
//
//  Created by 稲葉夏輝 on 2020/11/22.
//

import UIKit

class ChapterViewTableViewCell: UITableViewCell {
    @IBOutlet weak var title: UILabel!
    @IBOutlet var readMark: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
