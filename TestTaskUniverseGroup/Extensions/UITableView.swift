//
//  UITableView.swift
//  TestTaskUniverseGroup
//
//  Created by Oleksandr Ivanchenko on 2/7/25.
//

import UIKit

extension UITableView {
    
    var isEmpty: Bool { (0..<numberOfSections).allSatisfy { numberOfRows(inSection: $0) == 0 } }
    
    var indexPaths: [IndexPath] {
        var result = [IndexPath]()
        for section in 0..<numberOfSections {
            for row in 0..<numberOfRows(inSection: section) {
                result.append(IndexPath(row: row, section: section))
            }
        }
        return result
    }
    
    var isAllCellsSelected: Bool {
        guard let indexPathsForSelectedRows, !indexPathsForSelectedRows.isEmpty else { return false }
        return indexPathsForSelectedRows.count == indexPaths.count
    }
    
    func registerCell<T: UITableViewCell>(with type: T.Type) {
        register(T.self, forCellReuseIdentifier: T.reuseIdentifier)
    }
    
    func dequeueCell<T: UITableViewCell>(for indexPath: IndexPath) -> T {
        dequeueReusableCell(withIdentifier: T.reuseIdentifier, for: indexPath) as! T
    }
    
    func select(_ indexPaths: [IndexPath],
                animated: Bool = true,
                scrollPosition: UITableView.ScrollPosition = .none) {
        for indexPath in indexPaths {
            selectRow(at: indexPath, animated: animated, scrollPosition: scrollPosition)
        }
    }
    
    
    func deselect(_ indexPaths: [IndexPath], animated: Bool = true) {
        for indexPath in indexPaths {
            deselectRow(at: indexPath, animated: animated)
        }
    }
    
    func selectAll(animated: Bool = true) {
        select(indexPaths, animated: animated)
    }
    
    func deselectAll(animated: Bool = true) {
        deselect(indexPathsForSelectedRows ?? [], animated: animated)
    }
}
