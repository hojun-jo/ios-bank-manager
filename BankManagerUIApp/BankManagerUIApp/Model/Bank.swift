//
//  Bank.swift
//  BankManagerConsoleApp
//
//  Created by idinaloq, EtialMoon on 2023/07/13.
//

import Foundation

protocol BankDelegate: AnyObject {
    func addCustomerWaitLabel(_ customer: Customer)
    func startTimer()
}

struct Bank {
    private var depositBankManagers: BankManager = BankManager(people: 2)
    private var loansBankManagers: BankManager = BankManager(people: 1)
    private var customerNumber: Int = 0
    private var customerQueue: SingleLinkedList<Customer> = SingleLinkedList<Customer>()
    weak var delegate: BankDelegate?
    
     mutating func startBusiness() {
        createCustomerRandomNumber()
        receiveCustomers()
        processBusiness()
        delegate?.startTimer()
    }
    
    private mutating func createCustomerRandomNumber() {
         customerNumber = Int.random(in: 10...30)
    }
    
    mutating func receiveCustomers() {
        for number in 1...10 {
            let customer: Customer = Customer(waitingNumber: number)
            customerQueue.enqueue(customer)
        }
    }
    
    private mutating func updateWaitingQueue() {
        customerQueue.getDataInQueue().forEach {
            delegate?.addCustomerWaitLabel($0)
        }
    }
    
    private mutating func processBusiness() {
        let group: DispatchGroup = DispatchGroup()
        updateWaitingQueue()
        
        while let customer = customerQueue.dequeue() {
            switch customer.getBankingServiceType() {
            case .deposit:
                depositBankManagers.work(for: customer, with: group)
            case .loans:
                loansBankManagers.work(for: customer, with: group)
            case .none:
                print("BankingTypeIsNil")
            }
        }
    }
}
