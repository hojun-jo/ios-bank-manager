//
//  BankManagerUIApp - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom academy. All rights reserved.
// 

import UIKit

class ViewController: UIViewController {
    let mainView: MainView = MainView()
    var bank: Bank = Bank()
    let timer = DispatchSource.makeTimerSource(flags: [], queue: DispatchQueue.main)

    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bank.delegate = self
        bank.startBusiness()
        addObsevers()
    }
    
    private func addObsevers() {
        NotificationCenter.default.addObserver(self, selector: #selector(addCustomerProcessLabel), name: NSNotification.Name("updateProcessLabel"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(deleteCustomerProcessLabel), name: NSNotification.Name("deleteProcessLabel"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(suspendTimer), name: NSNotification.Name("suspendTimer"), object: nil)
    }
    
    @objc func addCustomerProcessLabel(_ notification: Notification) {
        guard let customer = notification.userInfo?["customer"] as? Customer else { return }
        mainView.addProcessLabel(customer: customer)
    }
    
    @objc func deleteCustomerProcessLabel(_ notification: Notification) {
        guard let customer = notification.userInfo?["customer"] as? Customer else { return }
        mainView.deleteProcessLabel(customer: customer)
    }
    
    @objc func suspendTimer() {
        timer.suspend()
    }
}

extension ViewController: BankDelegate {
    func addCustomerWaitLabel(_ customer: Customer) {
        mainView.addWaitLabel(customer: customer)
    }
    
    func startTimer() {
        let start = Date()
        timer.schedule(deadline: .now(), repeating: 1)
        timer.setEventHandler(handler: {
            let diff = Int(Date().timeIntervalSince(start))
            self.mainView.updateTimer(String(format: "%02d:%02d:000", diff.minute, diff.seconds))
        })

        timer.resume()
    }
}

extension Int {
    var minute: Int {
        (self / 60) % 60
    }
    
    var seconds: Int {
        self % 60
    }
}
