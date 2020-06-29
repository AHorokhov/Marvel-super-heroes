//
//  UIDeviceExtension.swift
//  Marvel Super Heroes
//
//  Created by Alexey Horokhov on 5/23/19.
//  Copyright © 2019 Alexey Horokhov. All rights reserved.
//

import UIKit

extension UIDevice {
    
    func isIPhone() -> Bool {
        return self.userInterfaceIdiom == .phone
    }
    
    func isIPad() -> Bool {
        return self.userInterfaceIdiom == .pad
    }
}
