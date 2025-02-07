//
//  SplashVC.swift
//  TestTaskUniverseGroup
//
//  Created by Oleksandr Ivanchenko on 2/7/25.
//

import UIKit
import SnapKit

final class SplashVC: BaseVC {
    
    private let viewModel: SplashVM

    init(viewModel: SplashVM) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.loadData()
    }
    
    override func setupView() {
        view.backgroundColor = .yellow
    }
}
