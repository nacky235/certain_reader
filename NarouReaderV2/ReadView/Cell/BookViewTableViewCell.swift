//
//  BookViewTableViewCell.swift
//  NarouReaderV2
//
//  Created by 稲葉夏輝 on 2020/11/19.
//

import UIKit

class BookViewTableViewCell: UITableViewCell {
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var author: UILabel!
    @IBOutlet weak var genre: UILabel!
    @IBOutlet weak var bigGenre: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
