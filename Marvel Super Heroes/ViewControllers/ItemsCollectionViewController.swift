//
//  ItemsCollectionViewController.swift
//  Marvel Super Heroes
//
//  Created by Alexey Horokhov on 5/21/19.
//  Copyright © 2019 Alexey Horokhov. All rights reserved.
//

import UIKit

class ItemsCollectionViewController: UICollectionViewController {
    
    private var items: [Item] = []
    
    func updateWith(items: [Item]) {
        self.items = items
        collectionView.reloadData()
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "itemCollectionCell", for: indexPath) as? ItemCollectionCell else { return UICollectionViewCell() }
        cell.updateWith(item: items[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 200, height: 300)
    }
    
}
