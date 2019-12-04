//
//  WalletModels.swift
//  ExchangeApp
//
//  Created by Юрий Нориков on 03.12.2019.
//  Copyright (c) 2019 norikoff. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

enum Wallet
{
  // MARK: Use cases
  
  enum Something
  {
    struct Request
    {
    }
    struct Response
    {
        let wallet: [EntryList.Currency]
    }
    struct ViewModel
    {
        let wallet: [EntryList.Currency]
    }
  }
}