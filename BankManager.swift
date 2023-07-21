//
//  BankManager.swift
//  Created by yagom.
//  Copyright © yagom academy. All rights reserved.
//

import Foundation

struct BankManager {
    private let queue: DispatchQueue = DispatchQueue(label: "concurrent", attributes: .concurrent)
    private let semaphore: DispatchSemaphore

    init(people semaphore: Int) {
        self.semaphore = DispatchSemaphore(value: semaphore)
    }
    
    func work(for customer: Customer, with group: DispatchGroup) {
        queue.async(group: group) {
            semaphore.wait()
            DispatchQueue.main.async {
                NotificationCenter.default.post(name: NSNotification.Name("updateProcessLabel"), object: nil, userInfo: ["customer": customer])
            }
            Thread.sleep(forTimeInterval: customer.getBankingProcessTime())
            DispatchQueue.main.async {
                NotificationCenter.default.post(name: NSNotification.Name("deleteProcessLabel"), object: nil, userInfo: ["customer": customer])
            }
            semaphore.signal()
        }
        
        group.notify(queue: queue) {
            NotificationCenter.default.post(name: NSNotification.Name("suspendTimer"), object: nil)
        }
    }
}
