//
//  UITableView.swift
//  TestTaskUniverseGroup
//
//  Created by Oleksandr Ivanchenko on 2/7/25.
//

import UIKit

extension UITableView {
    
    var isEmpty: Bool { (0..<numberOfSections).allSatisfy { numberOfRows(inSection: $0) == 0 } }
}
