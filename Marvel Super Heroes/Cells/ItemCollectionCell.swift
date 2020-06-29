//
//  ItemCollectionCell.swift
//  Marvel Super Heroes
//
//  Created by Alexey Horokhov on 5/21/19.
//  Copyright © 2019 Alexey Horokhov. All rights reserved.
//

import UIKit

class ItemCollectionCell: UICollectionViewCell {
    
    // MARK: - let & vars -
    
    @IBOutlet private weak var mainImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!

    
    
    // MARK: - lifecycle -
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = UIColor.clear
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
        mainImageView.image = nil
        descriptionLabel.text = nil
    }
    
    func updateWith(item: Item) {
        titleLabel.text = item.title
        descriptionLabel.text = item.fullDescription
        mainImageView.loadImageFor(url: URL(string: item.imageUrlString))
    }
    
    
    
    
}
