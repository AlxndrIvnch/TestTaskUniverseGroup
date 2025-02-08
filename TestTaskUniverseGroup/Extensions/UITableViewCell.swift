//
//  UITableViewCell.swift
//  TestTaskUniverseGroup
//
//  Created by Oleksandr Ivanchenko on 2/7/25.
//

import UIKit

extension UITableViewCell {
    
    static var reuseIdentifier: String {
        String(describing: self)
    }

    var reuseIdentifier: String {
        type(of: self).reuseIdentifier
    }
}
