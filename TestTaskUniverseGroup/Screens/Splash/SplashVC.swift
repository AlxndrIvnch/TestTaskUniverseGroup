//
//  SplashVC.swift
//  TestTaskUniverseGroup
//
//  Created by Oleksandr Ivanchenko on 2/7/25.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

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
    
    private let disposeBag = DisposeBag()

    init(viewModel: SplashVM) {
        self.viewModel = viewModel
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.input.viewDidLoad.onNext(())
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
        Observable.just(())
            .delay(.milliseconds(500), scheduler: MainScheduler.instance)
            .subscribe(with: self, onCompleted: { $0.animateGradientTransition() })
            .disposed(by: disposeBag)
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
        viewModel.output.progress
            .do(afterNext: { [unowned self] progress in
                let animated = progressView.isInViewHierarchy
                UIView.animate(withDuration: animated ? 0.4 : 0, delay: 0, options: [.curveEaseOut]) {
                    self.progressView.layoutIfNeeded()
                } completion: { _ in
                    self.viewModel.input.progressAnimationCompleted.onNext(progress)
                }
            })
            .drive(progressView.rx.progress)
            .disposed(by: disposeBag)
        
        viewModel.output.error
            .drive(errorLabel.rx.text)
            .disposed(by: disposeBag)
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
