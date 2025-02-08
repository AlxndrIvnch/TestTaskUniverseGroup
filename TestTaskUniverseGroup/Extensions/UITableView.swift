//
//  UITableView.swift
//  TestTaskUniverseGroup
//
//  Created by Oleksandr Ivanchenko on 2/7/25.
//

import UIKit

extension UITableView {
    
    var isEmpty: Bool { (0..<numberOfSections).allSatisfy { numberOfRows(inSection: $0) == 0 } }
    
    func registerCell<T: UITableViewCell>(with type: T.Type) {
         register(T.self, forCellReuseIdentifier: T.reuseIdentifier)
     }

     func dequeueCell<T: UITableViewCell>(for indexPath: IndexPath) -> T {
         dequeueReusableCell(withIdentifier: T.reuseIdentifier, for: indexPath) as! T
     }
}
