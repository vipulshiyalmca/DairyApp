//
//  DairyListCell.swift
//  DiaryApp
//
//  Created by prompt on 12/1/20.
//

import UIKit

class DairyListCell: UITableViewCell {

    @IBOutlet weak var viewMain:  UIView!
    @IBOutlet weak var lblTitle:  UILabel!
    @IBOutlet weak var lblDetails:  UILabel!
    @IBOutlet weak var lblHours:  UILabel!
    @IBOutlet weak var lblCircul:  UILabel!
    @IBOutlet weak var btnClose:  UIButton!
    @IBOutlet weak var btnEdit:  UIButton!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        lblCircul.layer.borderWidth = 1
        lblCircul.layer.borderColor = UIColor.systemGray4.cgColor
        lblCircul.layer.cornerRadius = lblCircul.frame.size.width/2
        lblCircul.clipsToBounds = true
     
        btnClose.layer.cornerRadius = btnClose.frame.size.width/2
        btnClose.clipsToBounds = true
        btnClose.imageEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)

    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
