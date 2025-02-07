//
//  BaseVC.swift
//  TestTaskUniverseGroup
//
//  Created by Oleksandr Ivanchenko on 2/7/25.
//

import UIKit

class BaseVC: UIViewController {
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupConstraints()
        setupBindings()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationBar()
    }

    func setupConstraints() {}
    
    func setupView() {}
    
    func setupBindings() {}
    
    func setupNavigationBar() {}
}
