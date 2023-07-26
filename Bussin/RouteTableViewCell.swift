//
//  RouteTableViewCell.swift
//  Bussin
//
//  Created by Diem Nguyen on 2023-07-25.
//

import UIKit

class RouteTableViewCell: UITableViewCell {
    @IBOutlet weak var routeIdLabel: UILabel!
    
    @IBOutlet weak var routeStopIdsLabel: UILabel!
    @IBOutlet weak var routeNameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
