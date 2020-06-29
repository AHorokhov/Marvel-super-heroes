//
//  SearchCaller.swift
//  Marvel Super Heroes
//
//  Created by Alexey Horokhov on 5/20/19.
//  Copyright © 2019 Alexey Horokhov. All rights reserved.
//

import UIKit

protocol SearchCaller {
    
    func showSearchController(from: UIViewController)
    
}

extension SearchCaller {
    
    func showSearchController(from: UIViewController) {
        let searchController = UIStoryboard(name: "Search", bundle: nil).instantiateInitialViewController() as! SearchViewController
        from.navigationController?.pushViewController(searchController, animated: true)
    }
    
}
