//
//  colorFillterToggleButton.swift
//  PhotoExplorer
//
//  Created by 임윤휘 on 1/22/25.
//

import UIKit

final class colorFillterToggleButton: TitleToggleButton {
    override var isSelected: Bool {
        didSet {
            self.alpha = isSelected ? 0.5 : 1.0
        }
    }
}
