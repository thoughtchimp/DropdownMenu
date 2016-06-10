//
//  MenuTableViewCell.swift
//  TCMenu
//
//  Created by Thought Chimp on 30/05/16.
//  Copyright © 2016 ThoughtChimp. All rights reserved.
//

import UIKit

class MenuTableViewCell: UITableViewCell {
    var titleLable: UILabel!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        titleLable = UILabel(frame: CGRectZero)
        contentView.addSubview(titleLable)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        titleLable.frame = CGRect(origin: CGPointZero, size: CGSize(width: frame.size.width, height: 21))
    }
    
}
