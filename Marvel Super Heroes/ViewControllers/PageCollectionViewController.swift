//
//  PageCollectionViewController.swift
//  Marvel Super Heroes
//
//  Created by Alexey Horokhov on 5/21/19.
//  Copyright © 2019 Alexey Horokhov. All rights reserved.
//

import UIKit

protocol PageVCDelegate: class {
    
    func didSelectPage(number: Int)
    
}

class PageCollectionViewController: UICollectionViewFlowLayout, UICollectionViewDataSource, UICollectionViewDelegate {
    
    private var pages: Int = 1
    weak var delegate: PageVCDelegate?
    
    func updateWithNumberOfPages(amount: Int) {
        pages = amount
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pages
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "pageCell", for: indexPath) as? PageCollectionViewCell else { return UICollectionViewCell() }
        cell.updateWith(pageNumber: indexPath.row + 1)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.didSelectPage(number: indexPath.row)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 20, height: 20)
    }
    
}
