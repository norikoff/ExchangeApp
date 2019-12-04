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
}

class HistoryViewController: UIViewController, HistoryDisplayLogic
{
    
    var interactor: HistoryBusinessLogic?
    var router: (NSObjectProtocol & HistoryRoutingLogic & HistoryDataPassing)?
    var orders: [SimpleOrder]?
    
    let tableView: UITableView = {
        let  tableView = UITableView()
        tableView.backgroundColor = .black
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        return tableView
    }()
    
    
    let searchField: UITextField = {
        let textField = UITextField()
        
        textField.backgroundColor = .white
        textField.textColor = .black
        textField.textAlignment = .center
        textField.placeholder = "Enter order number"
        textField.layer.cornerRadius = 20
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        //        textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        
        return textField
    }()
    
    let reuseId = "UITableViewCellreuseId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        interactor!.getListOfOrders()
        self.title = "Order history"
        self.view.backgroundColor = UIColor.black
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: reuseId)
        self.view.addSubview(tableView)
        
        //        self.view.addSubview(searchField)
        
        NSLayoutConstraint.activate([
            //            searchField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            //            searchField.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 8),
            //            searchField.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -8),
            //            searchField.heightAnchor.constraint(equalToConstant: 40),
            
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -self.tabBarController!.tabBar.frame.size.height/2)])
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
        let router = HistoryRouter()
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
    
    func doSomething()
    {
        let request = History.Something.Request()
        interactor?.doSomething(request: request)
    }
    
    func displayOrders(viewModel: History.Something.ViewModel){
        DispatchQueue.main.async {
            self.orders = viewModel.orders
            guard let data = viewModel.orders, data.count > 0 else{
                return
            }
            self.tableView.reloadData()
        }
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}

extension HistoryViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let count = self.orders{
            return count.count
        }
        return 0
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseId, for: indexPath)
        
        cell.layer.borderWidth = 1.0
        cell.layer.borderColor = UIColor.black.cgColor
        cell.backgroundColor = .black
        let bgColorView = UIView()
        bgColorView.backgroundColor = UIColor.orange
        cell.selectedBackgroundView = bgColorView
        cell.textLabel?.textColor = .white
        guard let data = orders, data.count > 0 else{
            return cell
        }
        let model = data[indexPath.row]
         cell.textLabel?.text = "\(model.orderNumber) \(model.total)"
        
        return cell
    }
}
