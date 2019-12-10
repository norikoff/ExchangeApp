//
//  HistoryModels.swift
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

enum History
{
  // MARK: Use cases
  
  enum Something
  {
    struct Request
    {
    }
    struct Response
    {
        let orders: [EntryList.SimpleOrder.Content]?
        let errorMessage: String?
        let successMessage: String?
    }
    struct ViewModel
    {
        let orders: [EntryList.SimpleOrder.Content]?
        let errorMessage: String?
        let successMessage: String?
    }
  }
}
