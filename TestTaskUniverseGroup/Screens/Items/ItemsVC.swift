//
//  ItemsVC.swift
//  TestTaskUniverseGroup
//
//  Created by Oleksandr Ivanchenko on 2/7/25.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import RxDataSources

final class ItemsVC: BaseVC {
    
    typealias DataSource = RxTableViewSectionedAnimatedDataSource<AnimatableSectionModel<Int, ItemCell.ViewModel>>
    
    private let viewModel: ItemsVMProtocol
    
    private lazy var markFavoriteButton: UIBarButtonItem = {
        let button = UIBarButtonItem()
        button.title = String(localized: "add_item_to_favorites")
        button.style = .done
        let font = UIFont.preferredFont(forTextStyle: .subheadline)
        button.setTitleTextAttributes([.foregroundColor: UIColor.systemGreen,
                                       .font: font],
                                      for: .normal)
        button.setTitleTextAttributes([.foregroundColor: UIColor.systemGray,
                                       .font: font],
                                      for: .disabled)
        button.isEnabled = false
        return button
    }()
    
    private lazy var removeFromFavoriteButton: UIBarButtonItem = {
        let button = UIBarButtonItem()
        button.title = String(localized: "remove_item_from_favorites")
        button.style = .done
        let font = UIFont.preferredFont(forTextStyle: .subheadline)
        button.setTitleTextAttributes([.foregroundColor: UIColor.systemRed,
                                       .font: font],
                                      for: .normal)
        button.setTitleTextAttributes([.foregroundColor: UIColor.systemGray,
                                       .font: font],
                                      for: .disabled)
        button.isEnabled = false
        return button
    }()
    
    private lazy var selectButton: UIBarButtonItem = {
        let button = UIBarButtonItem()
        button.title = String(localized: "start_selection")
        button.style = .plain
        button.setTitleTextAttributes([.foregroundColor: UIColor.systemBlue,
                                       .font: UIFont.preferredFont(forTextStyle: .body)],
                                      for: .normal)
        return button
    }()
    
    private lazy var doneButton: UIBarButtonItem = {
        let button = UIBarButtonItem()
        button.title = String(localized: "stop_selection")
        button.style = .done
        button.setTitleTextAttributes([.foregroundColor: UIColor.systemBlue,
                                       .font: UIFont.preferredFont(forTextStyle: .headline)],
                                      for: .normal)
        return button
    }()
    
    private lazy var selectAllButton: UIBarButtonItem = {
        let button = UIBarButtonItem()
        button.title = String(localized: "select_all_items_action_text")
        button.style = .plain
        button.setTitleTextAttributes([.foregroundColor: UIColor.systemBlue,
                                       .font: UIFont.preferredFont(forTextStyle: .body)],
                                      for: .normal)
        return button
    }()
    
    private lazy var deselectAllButton: UIBarButtonItem = {
        let button = UIBarButtonItem()
        button.title = String(localized: "deselect_all_items")
        button.style = .plain
        button.setTitleTextAttributes([.foregroundColor: UIColor.systemBlue,
                                       .font: UIFont.preferredFont(forTextStyle: .body)],
                                      for: .normal)
        return button
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.estimatedRowHeight = 44
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.allowsMultipleSelectionDuringEditing = true
        tableView.sectionHeaderTopPadding = 0
        tableView.registerCell(with: ItemCell.self)
        return tableView
    }()
    
    private lazy var dataSource = DataSource(
        configureCell: { [weak view] _, tableView, indexPath, cellVM in
            let cell: ItemCell = tableView.dequeueCell(for: indexPath)
            cell.viewModel = cellVM
            cell.backgroundColor = view?.backgroundColor
            return cell
        },
        canEditRowAtIndexPath: { _, _ in true }
    )
    
    private lazy var emptyStateLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = UIColor.secondaryLabel
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.numberOfLines = 0
        return label
    }()
    
    private let isMultipleSelectionOn = BehaviorRelay(value: false)
    private let selectionChanged = PublishRelay<Void>()
    private let disposeBag = DisposeBag()
    
    init(viewModel: some ItemsVMProtocol) {
        self.viewModel = viewModel
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupToolBar()
    }
    
    override func setupView() {
        view.backgroundColor = .secondarySystemBackground
    }
    
    override func viewIsAppearing(_ animated: Bool) {
        super.viewIsAppearing(animated)
        viewModel.input.viewWillAppear.accept(())
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.flashScrollIndicators()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        isMultipleSelectionOn.accept(false)
    }
    
    override func setupNavigationBar(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: animated)
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func setupToolBar() {
        let appearance = UIToolbarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.backgroundEffect = .init(style: .systemUltraThinMaterial)
        navigationController?.toolbar.standardAppearance = appearance
        navigationController?.toolbar.compactAppearance = appearance
        navigationController?.toolbar.scrollEdgeAppearance = appearance
        navigationController?.toolbar.compactScrollEdgeAppearance = appearance
    }
    
    override func setupConstraints() {
        view.addSubview(tableView)
        view.addSubview(emptyStateLabel)
        let safeArea = view.safeAreaLayoutGuide
        tableView.snp.makeConstraints { make in
            make.top.centerX.equalTo(safeArea)
            make.width.equalTo(safeArea).priority(.high)
            make.width.lessThanOrEqualTo(800)
            make.bottom.equalToSuperview()
        }
        emptyStateLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalToSuperview().offset(-48)
        }
    }
    
    override func setupBindings() {
        
        // MARK: ViewModel Output
        
        viewModel.output.title
            .drive(navigationItem.rx.title)
            .disposed(by: disposeBag)
        
        viewModel.output.cellVMs
            .filter { [unowned self] _ in tableView.isInViewHierarchy }
            .map { [AnimatableSectionModel(model: 0, items: $0)] }
            .drive(tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        viewModel.output.emptyStateText
            .drive(emptyStateLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.output.showRemoveFromFavoriteButton
            .map { !$0 }
            .drive(removeFromFavoriteButton.rx.isHidden)
            .disposed(by: disposeBag)
        
        viewModel.output.showMarkFavoriteButton
            .map { !$0 }
            .drive(markFavoriteButton.rx.isHidden)
            .disposed(by: disposeBag)
        
        viewModel.output.canRemoveFromFavorite
            .drive(removeFromFavoriteButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        viewModel.output.canMarkFavorite
            .drive(markFavoriteButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        // MARK: ViewModel Input
        
        Infallible.merge(
            markFavoriteButton.rx.tap.asInfallible().map { true },
            removeFromFavoriteButton.rx.tap.asInfallible().map { false }
        )
        .do(afterNext: { [weak self] _ in
            self?.isMultipleSelectionOn.accept(false)
        })
        .bind(to: viewModel.input.markItemsAction)
        .disposed(by: disposeBag)
        
        tableView.rx.itemSelected
            .asInfallible()
            .filter { [tableView] _ in !tableView.isEditing }
            .bind(to: viewModel.input.didSelectRow)
            .disposed(by: disposeBag)
        
        Infallible.combineLatest(
            selectionChanged.asInfallible(),
            isMultipleSelectionOn.asInfallible(),
            resultSelector: { _, isMultipleSelectionOn in isMultipleSelectionOn }
        )
        .map { [tableView] isMultipleSelectionOn in
            isMultipleSelectionOn ? tableView.indexPathsForSelectedRows ?? [] : []
        }
        .distinctUntilChanged()
        .bind(to: viewModel.input.indexPathsForSelectedRows)
        .disposed(by: disposeBag)
        
        // MARK: Internal
        
        Infallible.merge(
            selectButton.rx.tap.asInfallible().map { true },
            doneButton.rx.tap.asInfallible().map { false }
        )
        .bind(to: isMultipleSelectionOn)
        .disposed(by: disposeBag)
        
        Infallible.merge(
            isMultipleSelectionOn.asInfallible().map { _ in },
            tableView.rx.itemSelected.asInfallible().map { _ in },
            tableView.rx.itemDeselected.asInfallible().map { _ in }
        )
        .bind(to: selectionChanged)
        .disposed(by: disposeBag)
        
        selectAllButton.rx.tap
            .asInfallible()
            .do(afterNext: { [unowned self] in selectionChanged.accept(()) })
            .bind(onNext: { [tableView] _ in
                tableView.selectAll(animated: false)
            })
            .disposed(by: disposeBag)
        
        deselectAllButton.rx.tap
            .asInfallible()
            .do(afterNext: { [unowned self] in selectionChanged.accept(()) })
            .bind(onNext: { [tableView] _ in
                tableView.deselectAll(animated: false)
            })
            .disposed(by: disposeBag)
        
        isMultipleSelectionOn
            .asInfallible()
            .bind(onNext: { [tableView] in
                tableView.setEditing($0, animated: true)
            })
            .disposed(by: disposeBag)
        
        isMultipleSelectionOn
            .asInfallible()
            .map { !$0 }
            .bind(onNext: { [navigationController] in
                navigationController?.setToolbarHidden($0, animated: true)
            })
            .disposed(by: disposeBag)
        
        isMultipleSelectionOn
            .asInfallible()
            .map { [unowned self] isMultipleSelectionOn in
                isMultipleSelectionOn ? doneButton : selectButton
            }
            .bind(to: navigationItem.rx.rightBarButtonItem)
            .disposed(by: disposeBag)
        
        Infallible.combineLatest(
            selectionChanged.asInfallible(),
            isMultipleSelectionOn.asInfallible(),
            resultSelector: { _, isMultipleSelectionOn in isMultipleSelectionOn }
        )
        .map { [unowned self] isMultipleSelectionOn in
            guard isMultipleSelectionOn && !tableView.isEmpty else { return nil }
            return tableView.isAllCellsSelected ? deselectAllButton : selectAllButton
        }
        .distinctUntilChanged()
        .bind(to: navigationItem.rx.leftBarButtonItem)
        .disposed(by: disposeBag)
        
        Infallible.merge(
            removeFromFavoriteButton.rx.observe(\.isHidden).asInfallible(onErrorFallbackTo: .empty()),
            markFavoriteButton.rx.observe(\.isHidden).asInfallible(onErrorFallbackTo: .empty())
        )
        .flatMap { [unowned self] _ in
            Observable.of(removeFromFavoriteButton, markFavoriteButton)
                .filter { !$0.isHidden }
                .reduce([.flexibleSpace()]) { $0 + [$1, .flexibleSpace()] }
        }
        .bind(onNext: { [unowned self] buttons in
            self.setToolbarItems(buttons, animated: true)
        })
        .disposed(by: disposeBag)
    }
}

extension ItemsVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        guard let actionVMs = viewModel.getLeadingSwipeActions(for: indexPath) else { return nil }
        let actions = actionVMs.map { actionVM in
            let style: UIContextualAction.Style = actionVM.isDestructive ? .destructive : .normal
            let action = UIContextualAction(style: style, title: actionVM.title) { _, _, completion in
                actionVM.action(completion)
            }
            if style == .normal {
                action.backgroundColor = .systemGreen
            }
            return action
        }
        return .init(actions: actions)
    }
}
