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
    
    private let progressView: UIProgressView = {
        let progressView = UIProgressView()
        progressView.trackTintColor = .white.withAlphaComponent(0.3)
        progressView.progressTintColor = .white
        return progressView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Splash Screen"
        label.font = UIFont.boldSystemFont(ofSize: 36)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    private let errorLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.textColor = .systemRed
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()

    init(viewModel: SplashVM) {
        self.viewModel = viewModel
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.viewDidLoad()
    }
    
    override func setupView() {
        view.backgroundColor = .splashScreenBackground
    }
    
    override func setupConstraints() {
        view.addSubview(titleLabel)
        view.addSubview(progressView)
        view.addSubview(errorLabel)
        titleLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.7)
        }
        progressView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom).offset(24)
            make.width.equalToSuperview().multipliedBy(0.5)
        }
        errorLabel.snp.makeConstraints { make in
            make.top.equalTo(progressView.snp.bottom).offset(24)
            make.horizontalEdges.equalToSuperview().inset(24)
        }
    }
    
    override func setupBindings() {
        viewModel.onProgress = { [weak self] progress in
            UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseOut]) {
                self?.progressView.setProgress(progress, animated: true)
            }
        }
        viewModel.onError = { [weak self] in
            self?.errorLabel.text = $0
        }
    }
}
