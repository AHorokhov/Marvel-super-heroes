//
//  StoryboardInstantiable.swift
//  Marvel Super Heroes
//
//  Created by Alexey Horokhov on 5/23/19.
//  Copyright © 2019 Alexey Horokhov. All rights reserved.
//

/**
 Class, which implements this protocol, admits that it has a storyboard identifier and can be instantiated from storyboard.
 
 Supposed to be used by view controllers, which have visual representation and storyboardId in storyboard.
 */

protocol StoryboardInstantiable {
    
    static var storyboardIdentifier: String { get }
    
}
