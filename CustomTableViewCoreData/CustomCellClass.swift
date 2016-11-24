//
//  CustomCellClassTableViewCell.swift
//  CustomTableViewCoreData
//
//  Created by Kashif on 24/11/16.
//  Copyright © 2016 Kashif. All rights reserved.
//

import UIKit

class CustomCellClass: UITableViewCell {
    
    @IBOutlet weak var marks: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var imageViewCell: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        //        self.imageViewCell.image=nil
    }
    override func prepareForReuse() {
        self.imageViewCell.image=nil
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
