//
//  NotificationTableViewCell.swift
//  Bussin
//
//  Created by Alexander Gullen on 2023-07-21.
//

import UIKit

class NotificationTableViewCell: UITableViewCell {

    @IBOutlet weak var lbl_notification_type: UILabel!
    @IBOutlet weak var lbl_notification_message: UILabel!
    @IBOutlet weak var lbl_notification_image: UIImageView!
    @IBOutlet weak var lbl_notification_startDate: UILabel!
    @IBOutlet weak var lbl_notification_endDate: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
