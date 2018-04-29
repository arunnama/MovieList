//
//  MovieCell.swift
//  CareemTest
//
//  Created by Arun Kumar Nama on 29/4/18.
//  Copyright © 2018 Arun Kumar Nama. All rights reserved.
//

import UIKit

class MovieCell: UITableViewCell {

    @IBOutlet weak var lblMovie_title: UILabel!
    @IBOutlet weak var lblRelease_date: UILabel!
    @IBOutlet weak var lblOverview: UILabel!
    @IBOutlet weak var imgMovie_poster: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
