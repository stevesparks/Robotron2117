//
//  ServiceProvider.swift
//  TopShelfExtension
//
//  Created by Steve Sparks on 2/14/17.
//  Copyright © 2017 Big Nerd Ranch. All rights reserved.
//

import Foundation
import TVServices

class ServiceProvider: NSObject, TVTopShelfProvider {

    override init() {
        super.init()
    }

    // MARK: - TVTopShelfProvider protocol

    var topShelfStyle: TVTopShelfContentStyle {
        // Return desired Top Shelf style.
        return .inset
    }

    var topShelfItems: [TVContentItem] {
        // Create an array of TVContentItems.
        return [pic1, pic2]
    }
    
    var pic1 : TVContentItem = {
        let ident = TVContentIdentifier(identifier:
            "pic1", container: nil)!
        let item = TVContentItem(contentIdentifier:
            ident)!
        item.imageURL = Bundle.main.url(forResource:
            "pic1", withExtension: "png")
        item.displayURL = URL(string: "Nerdotron://play")
        return item
    }()

    var pic2 : TVContentItem = {
        let ident = TVContentIdentifier(identifier:
            "pic2", container: nil)!
        let item = TVContentItem(contentIdentifier:
            ident)!
        item.imageURL = Bundle.main.url(forResource:
            "pic2", withExtension: "png")
        item.displayURL = URL(string: "Nerdotron://play")
        return item
    }()
}

