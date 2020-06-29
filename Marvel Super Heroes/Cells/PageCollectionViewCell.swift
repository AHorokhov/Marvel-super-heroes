//
//  PageCollectionViewCell.swift
//  Marvel Super Heroes
//
//  Created by Alexey Horokhov on 5/21/19.
//  Copyright © 2019 Alexey Horokhov. All rights reserved.
//

import UIKit

class PageCollectionViewCell: UICollectionViewCell {
    
    // MARK: - let & vars -
    
    @IBOutlet private weak var pageNumberTitle: UILabel!
    override var isSelected: Bool {
        didSet {
            backgroundColor = isSelected ? UIColor.red : UIColor.clear
        }
    }
    
    
    
    // MARK: - lifecycle -
    
    override func prepareForReuse() {
        super.prepareForReuse()
        pageNumberTitle.text = nil
    }
    
    func updateWith(pageNumber: Int) {
        pageNumberTitle.text = "\(pageNumber)"
    }
    
}
