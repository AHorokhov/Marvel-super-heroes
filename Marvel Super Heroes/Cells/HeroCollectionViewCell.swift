//
//  HeroCollectionViewCell.swift
//  Marvel Super Heroes
//
//  Created by Alexey Horokhov on 5/20/19.
//  Copyright © 2019 Alexey Horokhov. All rights reserved.
//

import UIKit

class HeroCollectionViewCell: UICollectionViewCell {
    
    // MARK: - let & vars -
    
    @IBOutlet private weak var mainImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    
    
    
    // MARK: - lifecycle -

    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = UIColor.clear
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
        mainImageView.image = nil
    }
    
    func updateWith(hero: Hero) {
        titleLabel.text = hero.name
        mainImageView.loadImageFor(url: URL(string: hero.portraitImageUrlString))
    }
}
