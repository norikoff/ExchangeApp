//
//  HistoryPresenter.swift
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

protocol HistoryPresentationLogic
{
    func presentSomething(response: History.Something.Response)
    func presentOrders(response: History.Something.Response)
    func presentError(response: History.Something.Response)
}

class HistoryPresenter: HistoryPresentationLogic
{
    
    
    weak var viewController: HistoryDisplayLogic?
    
    // MARK: Do something
    
    func presentSomething(response: History.Something.Response)
    {
//        let viewModel = History.Something.ViewModel()
//        viewController?.displaySomething(viewModel: viewModel)
    }
    
    func presentOrders(response: History.Something.Response) {
        let viewModel = History.Something.ViewModel(orders: response.orders, errorMessage: nil)
        viewController?.displayOrders(viewModel: viewModel)
    }
    
    func presentError(response: History.Something.Response) {
        let viewModel = History.Something.ViewModel(orders: nil, errorMessage: response.errorMessage)
        viewController?.displayAllert(viewModel: viewModel)
    }
}
