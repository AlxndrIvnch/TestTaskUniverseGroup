//
//  ItemCell.swift
//  TestTaskUniverseGroup
//
//  Created by Oleksandr Ivanchenko on 2/8/25.
//

import UIKit

final class ItemCell: UITableViewCell {

    var viewModel: ItemCell.ViewModel? {
        didSet { setNeedsUpdateConfiguration() }
    }

    override func updateConfiguration(using state: UICellConfigurationState) {
        super.updateConfiguration(using: state)
        var contentConfig = defaultContentConfiguration().updated(for: state)
        contentConfig.text = viewModel?.text
        contentConfig.imageProperties.tintColor = .systemBlue
        contentConfig.image = UIImage(systemName: "star\(viewModel?.isFavorite == true ? ".fill" : "")")
        contentConfiguration = contentConfig
    }
}
