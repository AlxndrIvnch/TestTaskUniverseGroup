//
//  ItemsVC.swift
//  TestTaskUniverseGroup
//
//  Created by Oleksandr Ivanchenko on 2/7/25.
//

import UIKit
import SnapKit

final class ItemsVC: BaseVC {
    
    private let viewModel: ItemsVMProtocol
    
    private lazy var markFavoriteButton: UIBarButtonItem = {
        let button = UIBarButtonItem()
        button.title = String(localized: "add_item_to_favorites")
        button.style = .done
        button.addAction { [weak self] in
            self?.mark(asFavorite: true)
        }
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
        button.addAction { [weak self] in
            self?.mark(asFavorite: false)
        }
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
        button.addAction { [weak self] in
            self?.setEditing(true, animated: true)
        }
        button.setTitleTextAttributes([.foregroundColor: UIColor.systemBlue,
                                       .font: UIFont.preferredFont(forTextStyle: .body)],
                                      for: .normal)
        return button
    }()
    
    private lazy var doneButton: UIBarButtonItem = {
        let button = UIBarButtonItem()
        button.title = String(localized: "stop_selection")
        button.style = .done
        button.addAction { [weak self] in
            self?.setEditing(false, animated: true)
        }
        button.setTitleTextAttributes([.foregroundColor: UIColor.systemBlue,
                                       .font: UIFont.preferredFont(forTextStyle: .headline)],
                                      for: .normal)
        return button
    }()
    
    private lazy var selectAllButton: UIBarButtonItem = {
        let button = UIBarButtonItem()
        button.title = String(localized: "select_all_items_action_text")
        button.style = .plain
        button.addAction { [weak self] in
            guard let self else { return }
            tableView.selectAll(animated: false)
            updateNavigationBarButtons()
            updateToolbarButtons()
        }
        button.setTitleTextAttributes([.foregroundColor: UIColor.systemBlue,
                                       .font: UIFont.preferredFont(forTextStyle: .body)],
                                      for: .normal)
        return button
    }()
    
    private lazy var deselectAllButton: UIBarButtonItem = {
        let button = UIBarButtonItem()
        button.title = String(localized: "deselect_all_items")
        button.style = .plain
        button.addAction { [weak self] in
            guard let self else { return }
            tableView.deselectAll(animated: false)
            updateNavigationBarButtons()
            updateToolbarButtons()
        }
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
    
    private lazy var dataSource: UITableViewDiffableDataSource<Int, ItemCell.ViewModel> = {
        return UITableViewDiffableDataSource(tableView: tableView) { [weak view] tableView, indexPath, cellVM in
            let cell: ItemCell = tableView.dequeueCell(for: indexPath)
            cell.viewModel = cellVM
            cell.backgroundColor = view?.backgroundColor
            return cell
        }
    }()
    
    private lazy var emptyView: UILabel = {
        let label = UILabel()
        label.isHidden = true
        label.text = viewModel.textWhenEmpty
        label.textAlignment = .center
        label.textColor = UIColor.secondaryLabel
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.numberOfLines = 0
        return label
    }()
    
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    
    private var isEditingRow = false
    
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
        updateTableView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.flashScrollIndicators()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        setEditing(false, animated: animated)
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        if editing && isEditingRow {
            // fix for conflict of editing row (SwipeAction)
            // and transition to editing table view (selection mode)
            tableView.isEditing = false
            isEditingRow = false
        }
        super.setEditing(editing, animated: animated)
        tableView.setEditing(editing, animated: animated)
        updateNavigationBarButtons(animated)
        updateToolbarButtons(animated)
        navigationController?.setToolbarHidden(!editing, animated: animated)
    }
    
    override func setupNavigationBar(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: animated)
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = viewModel.title
        updateNavigationBarButtons(animated)
    }
    
    private func setupToolBar() {
        let appearance = UIToolbarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.backgroundEffect = .init(style: .systemUltraThinMaterial)
        navigationController?.toolbar.standardAppearance = appearance
        navigationController?.toolbar.compactAppearance = appearance
        navigationController?.toolbar.scrollEdgeAppearance = appearance
        navigationController?.toolbar.compactScrollEdgeAppearance = appearance
        updateToolbarButtons()
    }
    
    override func setupConstraints() {
        view.addSubview(tableView)
        view.addSubview(emptyView)
        view.addSubview(activityIndicator)
        let safeArea = view.safeAreaLayoutGuide
        tableView.snp.makeConstraints { make in
            make.top.centerX.equalTo(safeArea)
            make.width.equalTo(safeArea).priority(.high)
            make.width.lessThanOrEqualTo(800)
            make.bottom.equalToSuperview()
        }
        emptyView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.lessThanOrEqualToSuperview().offset(-48)
        }
        activityIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    override func setupBindings() {
        viewModel.onUpdateUI = { [weak self] in
            guard let self else { return }
            updateTableView()
            updateToolbarButtons()
        }
        viewModel.onLoading = { [weak self] isLoading in
            guard let self = self else { return }
            if isLoading {
                activityIndicator.startAnimating()
            } else {
                activityIndicator.stopAnimating()
            }
            view.isUserInteractionEnabled = !isLoading
        }
    }
    
    private func updateTableView() {
        guard tableView.isInViewHierarchy else { return }
        let snapshot = viewModel.createSnapshot()
        dataSource.apply(snapshot, animatingDifferences: true)
        updateEmptyView()
    }
    
    private func updateEmptyView() {
        emptyView.isHidden = !tableView.isEmpty
    }
    
    private func updateNavigationBarButtons(_ animated: Bool = true) {
        let rightBarButton = isEditing ? doneButton : selectButton
        navigationItem.setRightBarButton(rightBarButton, animated: animated)
        if isEditing && !tableView.isEmpty {
            let leftBarButton = tableView.isAllCellsSelected ? deselectAllButton : selectAllButton
            navigationItem.setLeftBarButton(leftBarButton, animated: animated)
        } else {
            navigationItem.setLeftBarButton(nil, animated: animated)
        }
    }
    
    private func updateToolbarButtons(_ animated: Bool = true) {
        var buttons = [UIBarButtonItem]()
        if viewModel.showRemoveFromFavoriteButton {
            buttons.append(removeFromFavoriteButton)
        }
        if viewModel.showMarkFavoriteButton {
            buttons.append(markFavoriteButton)
        }
        
        let indexPaths = tableView.indexPathsForSelectedRows ?? []
        removeFromFavoriteButton.isEnabled = viewModel.canRemoveFromFavorite(at: indexPaths)
        markFavoriteButton.isEnabled = viewModel.canMarkFavorite(at: indexPaths)
        
        let toolbarItems = buttons.reduce([UIBarButtonItem.flexibleSpace()]) {
            return $0 + [$1, .flexibleSpace()]
        }
        setToolbarItems(toolbarItems, animated: animated)
    }
    
    private func mark(asFavorite: Bool) {
        guard let indexPaths = tableView.indexPathsForSelectedRows else { return }
        Task {
            await viewModel.markItems(at: indexPaths, asFavorite: asFavorite)
            setEditing(false, animated: true)
        }
    }
}

extension ItemsVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.isEditing {
            updateNavigationBarButtons()
            updateToolbarButtons()
        } else {
            Task {
                await viewModel.toggleItemIsFavorite(at: indexPath)
                tableView.deselectRow(at: indexPath, animated: true)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if tableView.isEditing {
            updateNavigationBarButtons()
            updateToolbarButtons()
        }
    }
    
    func tableView(_ tableView: UITableView, willBeginEditingRowAt indexPath: IndexPath) {
        tableView.allowsMultipleSelectionDuringEditing = false
        isEditingRow = true
    }
    
    func tableView(_ tableView: UITableView, didEndEditingRowAt indexPath: IndexPath?) {
        isEditingRow = false
        tableView.allowsMultipleSelectionDuringEditing = true
    }
    
    func tableView(_ tableView: UITableView, shouldBeginMultipleSelectionInteractionAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, didBeginMultipleSelectionInteractionAt indexPath: IndexPath) {
        guard !isEditing else { return }
        setEditing(true, animated: true)
    }
    
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
