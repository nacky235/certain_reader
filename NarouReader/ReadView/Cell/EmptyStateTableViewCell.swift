//
//  EmptyStateTableViewCell.swift
//  NarouReader
//
//  Created by 稲葉夏輝 on 2021/01/07.
//

import UIKit

class EmptyStateTableViewCell: UITableViewCell {

    @IBOutlet weak var view: UIView!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var button: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        if let _ = UserDefaults.standard.object(forKey: "novels") {
            label.text = "保存された小説がありません。"
        } else {
            label.text = "まずは，小説を追加しよう！"
        }
        button.layer.cornerRadius = 5
        // Configure the view for the selected state
    }
    
}
