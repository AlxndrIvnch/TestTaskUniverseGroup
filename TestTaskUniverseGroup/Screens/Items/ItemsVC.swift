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
        button.title = "Mark as Favorite" //TODO: Localize
        button.style = .done
        button.addAction { [weak self] in
            self?.mark(asFavorite: true)
        }
        button.setTitleTextAttributes([.foregroundColor: UIColor.systemGreen,
                                       .font: UIFont.boldSystemFont(ofSize: 16)],
                                      for: .normal)
        button.setTitleTextAttributes([.foregroundColor: UIColor.gray,
                                       .font: UIFont.boldSystemFont(ofSize: 16)],
                                      for: .disabled)
        button.isEnabled = false
        return button
    }()
    
    private lazy var removeFromFavoriteButton: UIBarButtonItem = {
        let button = UIBarButtonItem()
        button.title = "Remove from Favorite"
        button.style = .done
        button.addAction { [weak self] in
            self?.mark(asFavorite: false)
        }
        button.setTitleTextAttributes([.foregroundColor: UIColor.red,
                                       .font: UIFont.boldSystemFont(ofSize: 16)],
                                      for: .normal)
        button.setTitleTextAttributes([.foregroundColor: UIColor.gray,
                                       .font: UIFont.boldSystemFont(ofSize: 16)],
                                      for: .disabled)
        button.isEnabled = false
        return button
    }()
    
    private lazy var selectButton: UIBarButtonItem = {
        let button = UIBarButtonItem()
        button.title = "Select"
        button.style = .plain
        button.addAction { [weak self] in
            guard let self else { return }
            setEditing(true, animated: true)
        }
        button.setTitleTextAttributes([.foregroundColor: UIColor.systemBlue,
                                       .font: UIFont.systemFont(ofSize: 16)],
                                      for: .normal)
        return button
    }()
    
    private lazy var doneButton: UIBarButtonItem = {
        let button = UIBarButtonItem()
        button.title = "Done"
        button.style = .done
        button.addAction { [weak self] in
            guard let self else { return }
            setEditing(false, animated: true)
        }
        button.setTitleTextAttributes([.foregroundColor: UIColor.systemBlue,
                                       .font: UIFont.boldSystemFont(ofSize: 16)],
                                      for: .normal)
        return button
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.estimatedRowHeight = 70
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.automaticallyAdjustsScrollIndicatorInsets = false
        tableView.allowsMultipleSelectionDuringEditing = true
        tableView.keyboardDismissMode = .onDrag
        tableView.sectionHeaderTopPadding = 0
        tableView.registerCell(with: UITableViewCell.self)
        return tableView
    }()
    
    private let emptyView: UIView = {
        let view = UIView() //TODO: Create
        view.isHidden = true
        view.backgroundColor = .red
        return view
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
        view.backgroundColor = .white
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.flashScrollIndicators()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate { [weak self] _ in //TODO: Check
            self?.tableView.reloadData()
        } completion: { [weak self] _ in
            self?.tableView.reloadData()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        setEditing(false, animated: animated)
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        if isEditingRow {
            tableView.isEditing = false
            isEditingRow = false
        }
        tableView.setEditing(editing, animated: animated)
        updateNavigationBarButtons(animated)
        updateToolbarButtons(animated)
        navigationController?.setToolbarHidden(!editing, animated: true)
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
        appearance.backgroundEffect = .init(style: .prominent)
        navigationController?.toolbar.standardAppearance = appearance
        navigationController?.toolbar.compactAppearance = appearance
        navigationController?.toolbar.scrollEdgeAppearance = appearance
        navigationController?.toolbar.compactScrollEdgeAppearance = appearance
        updateToolbarButtons()
    }
    
    override func setupConstraints() {
        let safeArea = view.safeAreaLayoutGuide
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.centerX.equalTo(safeArea)
            make.width.equalTo(safeArea).priority(.high)
            make.width.lessThanOrEqualTo(800)
            make.bottom.equalToSuperview()
        }
        view.addSubview(emptyView)
        emptyView.snp.makeConstraints { make in
            make.width.equalTo(220)
            make.height.equalTo(125)
            make.center.equalToSuperview()
        }
        view.addSubview(activityIndicator)
        activityIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    override func setupBindings() {
        viewModel.onUpdateUI = { [weak self] in
            guard let self else { return }
            tableView.reloadData()
            updateEmptyView()
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
    
    private func updateEmptyView() {
        emptyView.isHidden = !tableView.isEmpty
//        emptyView.text = viewModel.emptyText
    }
    
    private func updateNavigationBarButtons(_ animated: Bool) {
        let button = isEditing ? doneButton : selectButton
        navigationItem.setRightBarButton(button, animated: animated)
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
        removeFromFavoriteButton.isEnabled = viewModel.canRemoveFromFavorite(for: indexPaths)
        markFavoriteButton.isEnabled = viewModel.canMarkFavorite(for: indexPaths)
        
        let toolbarItems = buttons.reduce([UIBarButtonItem.flexibleSpace()]) {
            return $0 + [$1, .flexibleSpace()]
        }
        setToolbarItems(toolbarItems, animated: animated)
    }
    
    private func mark(asFavorite: Bool) {
        guard let indexPaths = tableView.indexPathsForSelectedRows else { return }
        Task {
            await viewModel.markItems(asFavorite: asFavorite, at: indexPaths)
            setEditing(false, animated: true)
        }
    }
}

extension ItemsVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.getNumberOfRows()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueCell(for: indexPath)
        cell.textLabel?.text = viewModel.getCellVM(for: indexPath)
        cell.backgroundColor = .clear
        return cell
    }
}

extension ItemsVC: UITableViewDelegate {
    
//    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
//        tableView.cellForRow(at: indexPath)?.setHighlighted(false, animated: false)
//    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.isEditing {
            updateToolbarButtons()
        } else {
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if tableView.isEditing {
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
            let action = UIContextualAction(style: .normal, title: actionVM.title) { _, _, completion in
                actionVM.action(completion)
            }
            action.backgroundColor = .systemBlue
            return action
        }
        return .init(actions: actions)
    }
}
