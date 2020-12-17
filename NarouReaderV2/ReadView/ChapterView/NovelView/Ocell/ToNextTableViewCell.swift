//
//  ToNextTableViewCell.swift
//  NarouReaderV2
//
//  Created by 稲葉夏輝 on 2020/12/16.
//

import UIKit

protocol ToNextContent: class {
    func toNextContent()
}

class ToNextTableViewCell: UITableViewCell {
    @IBOutlet weak var toNext: UIButton!
    weak var delegate: ToNextContent?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func toNext(_ sender: Any) {
        delegate?.toNextContent()
    }
    
    
}
