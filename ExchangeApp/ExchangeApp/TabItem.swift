//
//  TabItem.swift
//  ExchangeApp
//
//  Created by Юрий Нориков on 28.11.2019.
//  Copyright © 2019 norikoff. All rights reserved.
//

import UIKit

enum TabItem: String, CaseIterable {
    case trade = "trade"
    case wallet = "wallet"
    case history = "history"
    case profile = "profile"
    
    
    var viewController: UIViewController {
        switch self {
        case .trade:
            return PairsViewController()
        case .wallet:
            return WalletViewController()
        case .history:
            return HistoryViewController()
        case .profile:
            return ProfileViewController()
        }
    }
    
    var icon: UIImage? {
        switch self {
        case .trade:
            return UIImage(named: "ic_trade")!
        case .wallet:
            return UIImage(named: "ic_wallet")!
        case .history:
            return UIImage(named: "ic_history")!
        case .profile:
            return UIImage(named: "ic_profile")!
        }
    }
    
    var displayTitle: String {
        return self.rawValue.capitalized(with: nil)
    }
}
