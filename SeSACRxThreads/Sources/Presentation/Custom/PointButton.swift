//
//  PointButton.swift
//  SeSACRxThreads
//
//  Created by gnksbm on 8/1/24.
//

import UIKit

final class PointButton: UIButton {
    init(title: String) {
        super.init(frame: .zero)
        configurationUpdateHandler = { button in
            var config = UIButton.Configuration.bordered()
            config.title = title
            config.baseForegroundColor = .white
            switch button.state {
            case .disabled:
                config.baseBackgroundColor = .lightGray
            default:
                config.baseBackgroundColor = .black
            }
            button.configuration = config
        }
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
