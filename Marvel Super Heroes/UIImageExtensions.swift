//
//  UIImageExtensions.swift
//  Marvel Super Heroes
//
//  Created by Alexey Horokhov on 5/19/19.
//  Copyright © 2019 Alexey Horokhov. All rights reserved.
//

import UIKit

extension UIImageView {
    func loadImageFor(url: URL?) {
        DispatchQueue.global().async {
            guard let url = url else { return }
            let data = try? Data(contentsOf: url)
            DispatchQueue.main.async {
                guard let data = data else { return }
                self.image = UIImage(data: data)
            }
        }
    }
}
