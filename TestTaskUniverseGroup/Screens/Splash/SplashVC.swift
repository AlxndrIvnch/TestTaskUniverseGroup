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
        progressView.trackTintColor = .systemGray.withAlphaComponent(0.3)
        progressView.progressTintColor = .systemGray6
        return progressView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = String(localized: "splash_screen_title")
        if #available(iOS 17.0, *) {
            label.font = UIFont.preferredFont(forTextStyle: .extraLargeTitle)
        } else {
            label.font = UIFont.preferredFont(forTextStyle: .largeTitle)
        }
        label.textColor = .systemGray6
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private let errorLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        label.textColor = .systemRed
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private let gradientLayer: CAGradientLayer = {
        let layer = CAGradientLayer()
        layer.colors = .init(repeating: UIColor.splashScreenBackground.cgColor, count: 3)
        layer.startPoint = .zero
        layer.endPoint = .init(x: 1, y: 1)
        return layer
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
        view.layer.insertSublayer(gradientLayer, above: view.layer)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        gradientLayer.frame = view.bounds
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        Task {
            try await Task.sleep(for: .seconds(0.5))
            animateGradientTransition()
        }
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
            self?.progressView.progress = progress
            UIView.animate(withDuration: 0.25, delay: 0, options: [.curveEaseOut]) {
                self?.progressView.layoutIfNeeded()
            } completion: { _ in
                guard progress == 1 else { return }
                self?.viewModel.progressFillAnimationEnded()
            }
        }
        viewModel.onError = { [weak self] in
            self?.errorLabel.text = $0
        }
    }
    
    private func animateGradientTransition() {
        let finalColors: [CGColor] = [UIColor.systemBlue.cgColor,
                                      UIColor.splashScreenBackground.cgColor,
                                      UIColor.systemPurple.cgColor]
        let colorAnimation = CABasicAnimation(keyPath: "colors")
        colorAnimation.fromValue = gradientLayer.colors
        colorAnimation.toValue = finalColors
        colorAnimation.duration = 1
        colorAnimation.fillMode = .forwards
        colorAnimation.isRemovedOnCompletion = false
        gradientLayer.add(colorAnimation, forKey: "colorsChange")
    }
}
