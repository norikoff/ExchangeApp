//
//  CallsViewController.swift
//  ExchangeApp
//
//  Created by Юрий Нориков on 28.11.2019.
//  Copyright © 2019 norikoff. All rights reserved.
//

import UIKit

protocol HistoryDisplayLogic: class
{
    func displayOrders(viewModel: History.Something.ViewModel)
    func displayAllert(viewModel: History.Something.ViewModel)
    func displaySuccess(viewModel: History.Something.ViewModel)
    
}

class HistoryViewController: UIViewController, HistoryDisplayLogic
{
    
    var interactor: HistoryBusinessLogic?
    
    var orders: [EntryList.SimpleOrder.Content]?
    var currentOrders: [EntryList.SimpleOrder.Content]?
    private let refreshControl = UIRefreshControl()
    let tableView: UITableView = {
        let  tableView = UITableView()
        tableView.backgroundColor = .black
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        return tableView
    }()
    
    
    var searchField: UITextField!
    
    let reuseId = "UITableViewCellreuseId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        interactor!.getListOfOrders()
        self.title = "Order history"
        self.view.backgroundColor = UIColor.black
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(HistoryCell.self, forCellReuseIdentifier: reuseId)
        
        searchField = TextFieldFactory.createTextField(title: "Enter order number")
        searchField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        
        let label = UILabel(frame: CGRect.zero)
        label.text = "Number"
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
        priceLable.text = "Type"
        priceLable.font = UIFont.systemFont(ofSize: 16)
        priceLable.translatesAutoresizingMaskIntoConstraints = false
        priceLable.clipsToBounds = true
        priceLable.sizeToFit()
        priceLable.textColor = .orange
        priceLable.textAlignment = .right
        tableView.addSubview(refreshControl)
        refreshControl.addTarget(self, action: #selector(refreshOrderData(_:)), for: .valueChanged)
        self.view.addSubview(tableView)
        self.view.addSubview(label)
        self.view.addSubview(priceLable)
        self.view.addSubview(amountLable)
        self.view.addSubview(searchField)
        
        NSLayoutConstraint.activate([
            searchField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
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
            
            tableView.topAnchor.constraint(equalTo: priceLable.bottomAnchor),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -self.tabBarController!.tabBar.frame.size.height/2)])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.showSpinner(onView: self.view)
        interactor!.getListOfOrders()
    }
    
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
        let interactor = HistoryInteractor()
        let presenter = HistoryPresenter()
        viewController.interactor = interactor
        interactor.presenter = presenter
        presenter.viewController = viewController
    }
    
    // MARK: Action
    
    func displayOrders(viewModel: History.Something.ViewModel){
        DispatchQueue.main.async {
            guard let data = viewModel.orders, data.count > 0 else{
                self.currentOrders = []
                self.tableView.reloadData()
                self.refreshControl.endRefreshing()
                self.removeSpinner()
                return
            }
            self.orders = viewModel.orders
            self.currentOrders = self.orders
            self.tableView.reloadData()
            self.refreshControl.endRefreshing()
            self.removeSpinner()
        }
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        
        if let text = textField.text {
            self.search(by: text)
        }
    }
    
    private func search(by searchText: String) {
        currentOrders?.removeAll()
        if !searchText.isEmpty{
            currentOrders = orders?.filter({ wal -> Bool in
                return wal.orderNumber.lowercased().contains(searchText.lowercased())
            })
        }else {
            currentOrders = orders
            
        }
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    @objc func refreshOrderData(_ sender: Any){
        searchField.text?.removeAll()
        interactor!.getListOfOrders()
    }
    
    func displayAllert(viewModel: History.Something.ViewModel){
        DispatchQueue.main.async {
            self.refreshControl.endRefreshing()
            let alert = UIAlertController(title: "Error", message: viewModel.errorMessage!, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Okay", style: .cancel, handler: nil))
            self.present(alert, animated: true)
            self.removeSpinner()
        }
    }
    
    func displayCancelOrder(orderNumber: String){
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Cancel", message: "Do you want cancel order?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Don't cancel", style: .cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { action in
                self.interactor?.cancelOrder(orderNumber: orderNumber)
            }))
            self.present(alert, animated: true)
        }
    }
    
    func displaySuccess(viewModel: History.Something.ViewModel){
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Success", message: viewModel.successMessage!, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Okay", style: .cancel, handler: nil))
            self.present(alert, animated: true)
        }
        self.showSpinner(onView: self.view)
        interactor!.getListOfOrders()
    }
    
}

extension HistoryViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let num = currentOrders?[indexPath.row].orderNumber {
            displayCancelOrder(orderNumber: num)
        }else{
            displayAllert(viewModel: History.Something.ViewModel(orders: nil, errorMessage: "Cant cancel order", successMessage: nil))
        }
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let count = self.currentOrders{
            return count.count
        }
        return 0
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseId, for: indexPath) as! HistoryCell
        cell.layer.borderWidth = 1.0
        cell.layer.borderColor = UIColor.black.cgColor
        cell.backgroundColor = .black
        let bgColorView = UIView()
        bgColorView.backgroundColor = UIColor.orange
        cell.selectedBackgroundView = bgColorView
        cell.textLabel?.textColor = .white
        if indexPath.row < currentOrders!.count {
            let model = currentOrders![indexPath.row]
            cell.order = model
        }
        return cell
    }
}
