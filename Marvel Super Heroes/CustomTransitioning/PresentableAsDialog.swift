//
//  PresentableAsDialog.swift
//  Marvel Super Heroes
//
//  Created by Alexey Horokhov on 5/23/19.
//  Copyright © 2019 Alexey Horokhov. All rights reserved.
//

@objc protocol PresentableAsDialog {
    
    var dialogSize: CGSize { get }
    func dialogBackgroundTapped()
}
