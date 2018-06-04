//
//  TableViewCell.swift
//  TestApp
//
//  Created by Ali Noorani on 2018-05-07.
//  Copyright © 2018 Ali Noorani. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {
    @IBOutlet weak var myCellImageView: UIImageView!
    @IBOutlet weak var myLableView: UILabel!
    @IBOutlet weak var myTextView: UITextView!
    
    @IBOutlet weak var myLable_Count: UILabel!
    @IBOutlet weak var myBlurView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.myCellImageView.layer.cornerRadius = 5;
        self.myCellImageView.clipsToBounds = true;
        
        self.myBlurView.layer.cornerRadius = 5;
        self.myBlurView.clipsToBounds = true
        
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.myBlurView.bounds
        blurEffectView.alpha = 0.9
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.myBlurView.addSubview(blurEffectView)
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
