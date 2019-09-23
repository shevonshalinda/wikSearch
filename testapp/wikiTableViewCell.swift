//
//  wikiTableViewCell.swift
//  testapp
//
//  Created by Digital-02 on 9/21/19.
//  Copyright © 2019 Digital-02. All rights reserved.
//

import UIKit

class wikiTableViewCell: UITableViewCell {

    
    @IBOutlet weak var imgView: UIImageView!
    
    
    @IBOutlet weak var Title: UILabel!
    
    
    @IBOutlet weak var Description: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
