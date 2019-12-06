//
//  PairsViewController.swift
//  ExchangeApp
//
//  Created by Юрий Нориков on 06.12.2019.
//  Copyright (c) 2019 norikoff. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol PairsDisplayLogic: class
{
  func displaySomething(viewModel: Pairs.Something.ViewModel)
}

class PairsViewController: UIViewController, PairsDisplayLogic
{
  var interactor: PairsBusinessLogic?
  var router: (NSObjectProtocol & PairsRoutingLogic & PairsDataPassing)?

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
    let interactor = PairsInteractor()
    let presenter = PairsPresenter()
    let router = PairsRouter()
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
  }
  
  // MARK: Do something
  
  //@IBOutlet weak var nameTextField: UITextField!
  
  
  func displaySomething(viewModel: Pairs.Something.ViewModel)
  {
    //nameTextField.text = viewModel.name
  }
}
