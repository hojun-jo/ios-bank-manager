//
//  BankManagerUIApp - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom academy. All rights reserved.
// 

import UIKit

class ViewController: UIViewController {
    let mainView: MainView = MainView()
    var bank: Bank = Bank()

    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bank.delegate = self
        bank.startBusiness()
    }

}

extension ViewController: BankDelegate {
    func addCustomerWaitLabel(_ customer: Customer) {
        mainView.addWaitLabel(customer: customer)
    }
}
