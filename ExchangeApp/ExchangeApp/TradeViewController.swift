//
//  TradeViewController.swift
//  ExchangeApp
//
//  Created by Юрий Нориков on 04.12.2019.
//  Copyright (c) 2019 norikoff. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol TradeDisplayLogic: class
{
    func displaySomething(viewModel: Trade.Something.ViewModel)
}

class TradeViewController: UIViewController, TradeDisplayLogic
{
    var interactor: TradeBusinessLogic?
    var router: (NSObjectProtocol & TradeRoutingLogic & TradeDataPassing)?
    
    let buyButton: UIButton = {
        let buyButton = UIButton(type: .custom)
        buyButton.backgroundColor = UIColor.green
        buyButton.setTitle("BUY", for: .normal)
        buyButton.translatesAutoresizingMaskIntoConstraints = false
        buyButton.sizeToFit()
        return buyButton
    }()
    
    let sellButton: UIButton = {
        let sellButton = UIButton(type: .custom)
        sellButton.backgroundColor = UIColor.red
        sellButton.setTitle("SELL", for: .normal)
        sellButton.translatesAutoresizingMaskIntoConstraints = false
        sellButton.sizeToFit()
        return sellButton
    }()
    
    // MARK: Object lifecycle
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?)
    {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        setup()
    }
    
    // MARK: Setup
    
    private func setup()
    {
        let viewController = self
        let interactor = TradeInteractor()
        let presenter = TradePresenter()
        let router = TradeRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
    
    // MARK: Routing
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if let scene = segue.identifier {
            let selector = NSSelectorFromString("routeTo\(scene)WithSegue:")
            if let router = router, router.responds(to: selector) {
                router.perform(selector, with: segue)
            }
        }
    }
    
    // MARK: View lifecycle
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.title = "Trade"
        self.view.backgroundColor = UIColor.black
        self.view.addSubview(buyButton)
        self.view.addSubview(sellButton)
        buyButton.addTarget(self, action: #selector(buyPush), for: .touchUpInside)
        sellButton.addTarget(self, action: #selector(sellPush), for: .touchUpInside)
        buyButton.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 50)
        sellButton.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 50)
        NSLayoutConstraint.activate([
            buyButton.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -self.tabBarController!.tabBar.frame.size.height),
            buyButton.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            buyButton.rightAnchor.constraint(equalTo: self.view.centerXAnchor),
            buyButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            
            sellButton.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -self.tabBarController!.tabBar.frame.size.height),
            sellButton.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            sellButton.leftAnchor.constraint(equalTo: self.view.centerXAnchor),
            sellButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            ])
    }
    
    // MARK: Do something
    
    //@IBOutlet weak var nameTextField: UITextField!
    
    @objc func buyPush(){
        print("buy")
    }
    
    @objc func sellPush(){
        print("sell")
    }
    
    func doSomething()
    {
        let request = Trade.Something.Request()
        interactor?.doSomething(request: request)
    }
    
    func displaySomething(viewModel: Trade.Something.ViewModel)
    {
        //nameTextField.text = viewModel.name
    }
}
