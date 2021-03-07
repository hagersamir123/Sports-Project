//
//  LeagueTableViewCell.swift
//  sports
//
//  Created by MacOSSierra on 2/28/21.
//  Copyright © 2021 ITI. All rights reserved.
//

import UIKit

class LeagueTableViewCell: UITableViewCell {
    
    @IBOutlet weak var leaguetName: UILabel!
    @IBOutlet weak var leagueImage: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
