//
//  HistoryInteractor.swift
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

protocol HistoryBusinessLogic
{
    func getListOfOrders()
    func cancelOrder(orderNumber: String)
}

protocol HistoryDataStore
{
    
}

class HistoryInteractor: HistoryBusinessLogic, HistoryDataStore
{
    var presenter: HistoryPresentationLogic?
    let utils: NetworkService?
    let service: ApiService?
    
    init() {
        utils = UtilsService()
        service = PoloniexApiService(utilService: utils!)
    }
    
    // MARK: Do something
    
    func getListOfOrders() {
        if Reachability.isConnectedToNetwork(){
            service!.getOrders { result in
                switch result {
                case .success(let data):
                    let response = History.Something.Response.init(orders: data, errorMessage: nil, successMessage: nil)
                    self.presenter?.presentOrders(response: response)
                case .failure(let error):
                    let response = History.Something.Response.init(orders: nil, errorMessage: error.error, successMessage: nil)
                    self.presenter?.presentError(response: response)
                }
            }
        }else{
            let response = History.Something.Response.init(orders: nil, errorMessage: "Check enternet connection", successMessage: nil)
            self.presenter?.presentError(response: response)
        }
    }
    
    func cancelOrder(orderNumber: String){
        service?.cancelOrder(orderNumber: orderNumber){ result in
            switch result {
            case .success(let data):
                if data{
                    let response = History.Something.Response(orders: nil, errorMessage: nil, successMessage: "Done")
                    self.presenter?.presentSuccess(response: response)
                }else{
                    
                }
            case .failure(let error):
                let response = History.Something.Response.init(orders: nil, errorMessage: error.error, successMessage: nil)
                self.presenter?.presentError(response: response)
            }
            
        }
    }
    
}
