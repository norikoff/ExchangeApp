//
//  WalletViewController.swift
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

protocol WalletDisplayLogic: class
{
    func displayWallet(viewModel: Wallet.Something.ViewModel)
}

class WalletViewController: UIViewController, WalletDisplayLogic
{
    var interactor: WalletBusinessLogic?
    var router: (NSObjectProtocol & WalletRoutingLogic & WalletDataPassing)?
    
    private let refreshControl = UIRefreshControl()
    
    let searchField: UITextField = {
        let textField = UITextField()
        
        textField.backgroundColor = .white
        textField.textColor = .black
        textField.textAlignment = .center
        textField.placeholder = "Enter currency name"
        textField.layer.cornerRadius = 20
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        
        return textField
    }()
    
    let tableView: UITableView = {
        let  tableView = UITableView()
        tableView.backgroundColor = .black
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        return tableView
    }()
    
    let searchDelayQueue: OperationQueue = {
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = 1
        return queue
    }()
    
    let reuseId = "UITableViewCellreuseId"
    var wallet: [EntryList.Currency]?
    var currentwallet: [EntryList.Currency]?
    
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
        let interactor = WalletInteractor()
        let presenter = WalletPresenter()
        let router = WalletRouter()
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Wallet"
        interactor!.getWallet()
        self.view.backgroundColor = UIColor.black
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(WalletCell.self, forCellReuseIdentifier: reuseId)
        tableView.addSubview(refreshControl)
        refreshControl.addTarget(self, action: #selector(refreshWalletData(_:)), for: .valueChanged)
        let label = UILabel(frame: CGRect.zero)
        label.text = "Currency"
        label.font = UIFont.systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.clipsToBounds = true
        label.sizeToFit()
        label.textColor = .orange
        
        let amountLable = UILabel(frame: CGRect.zero)
        amountLable.text = "Amount"
        amountLable.font = UIFont.systemFont(ofSize: 16)
        amountLable.translatesAutoresizingMaskIntoConstraints = false
        amountLable.clipsToBounds = true
        amountLable.sizeToFit()
        amountLable.textColor = .orange
        amountLable.textAlignment = .center
        
        let priceLable = UILabel(frame: CGRect.zero)
        priceLable.text = "Price"
        priceLable.font = UIFont.systemFont(ofSize: 16)
        priceLable.translatesAutoresizingMaskIntoConstraints = false
        priceLable.clipsToBounds = true
        priceLable.sizeToFit()
        priceLable.textColor = .orange
        priceLable.textAlignment = .right
        
        self.view.addSubview(label)
        self.view.addSubview(priceLable)
        self.view.addSubview(amountLable)
        self.view.addSubview(tableView)
        self.view.addSubview(searchField)
        
        NSLayoutConstraint.activate([
            searchField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: view.frame.height/3),
            searchField.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 8),
            searchField.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -8),
            searchField.heightAnchor.constraint(equalToConstant: 40),
            
            label.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 4),
            label.topAnchor.constraint(equalTo: searchField.bottomAnchor),
            
            amountLable.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            amountLable.rightAnchor.constraint(equalTo: priceLable.leftAnchor, constant: -4),
            amountLable.topAnchor.constraint(equalTo: searchField.bottomAnchor),
            amountLable.leftAnchor.constraint(equalTo: label.rightAnchor),
            
            priceLable.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -8),
            priceLable.topAnchor.constraint(equalTo: searchField.bottomAnchor),
            priceLable.leftAnchor.constraint(equalTo: amountLable.rightAnchor),
            
            tableView.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 8),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -self.tabBarController!.tabBar.frame.size.height)])
    }
    
    // MARK: Do something
    
    //@IBOutlet weak var nameTextField: UITextField!
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        
        searchDelayQueue.isSuspended = true
        searchDelayQueue.cancelAllOperations()
        
        if let text = textField.text {
            searchDelayQueue.addOperation {
                self.search(by: text)
            }
        }
        
        DispatchQueue.global().asyncAfter(deadline: .now() + 1) {
            self.searchDelayQueue.isSuspended = false
        }
    }
    
    private func search(by searchText: String) {
//        guard !searchText.isEmpty  else { currentwallet = wallet; return }
//        currentwallet = wallet?.filter({ wal -> Bool in
//            return wal.name.lowercased().contains(searchText.lowercased())
//        })
//        DispatchQueue.main.async {
//            self.tableView.reloadData()
//        }
    }
    
    @objc func refreshWalletData(_ sender: Any){
        interactor!.getWallet()
    }
    func doSomething()
    {
        let request = Wallet.Something.Request()
        interactor?.doSomething(request: request)
    }
    
    func displayWallet(viewModel: Wallet.Something.ViewModel)
    {
        DispatchQueue.main.async {
            self.wallet = viewModel.wallet
            self.wallet = self.wallet!.sorted()
            self.currentwallet = self.wallet
            self.refreshControl.endRefreshing()
            self.tableView.reloadData()
        }
    }
    
    
}


extension WalletViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let count = self.wallet{
            return count.count
        }
        return 0
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseId, for: indexPath) as! WalletCell
        let model = currentwallet![indexPath.row]
        cell.wallet = model
        if model.content.available == "0" {
            tableView.allowsSelection = false
        }
        cell.layer.borderWidth = 1.0
        cell.layer.borderColor = UIColor.black.cgColor
        cell.backgroundColor = .black
        let bgColorView = UIView()
        bgColorView.backgroundColor = UIColor.orange
        cell.selectedBackgroundView = bgColorView
        cell.textLabel?.textColor = .white
        return cell
    }
}
