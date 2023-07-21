//
//  MainView.swift
//  BankManagerUIApp
//
//  Created by idinaloq, EtialMoon on 2023/07/21.
//

import UIKit

final class MainView: UIView {
    private var customerAddButton: UIButton = {
        let button: UIButton = UIButton()
        button.setTitle("고객 10명 추가", for: .normal)
        button.setTitleColor(UIColor.systemBlue, for: .normal)
        
        return button
    }()
    
    private var resetButton: UIButton = {
        let button: UIButton = UIButton()
        button.setTitle("초기화", for: .normal)
        button.setTitleColor(UIColor.systemRed, for: .normal)
        
        return button
    }()
    
    private let processTimeLabel: UILabel = {
        let label: UILabel = UILabel()
        label.text = "업무시간 - 00:00:00"
        label.textAlignment = .center
        label.font = .preferredFont(forTextStyle: .title1)
        
        return label
    }()
    
    private let waitTitleLabel: UILabel = {
        let label: UILabel = UILabel()
        label.text = "대기중"
        label.textAlignment = .center
        label.backgroundColor = .green
        label.textColor = .white
        label.font = .preferredFont(forTextStyle: .title1)
        
        return label
    }()
    
    private let processTitleLabel: UILabel = {
        let label: UILabel = UILabel()
        label.text = "업무중"
        label.backgroundColor = .blue
        label.textColor = .white
        label.textAlignment = .center
        label.font = .preferredFont(forTextStyle: .title1)
        
        return label
    }()
    
    private let waitLabel: UILabel = {
        let label: UILabel = UILabel()
        label.text = "예금대기"
        label.textAlignment = .center
        label.font = .preferredFont(forTextStyle: .title3)
        
        return label
    }()
    
    private let processLabel: UILabel = {
        let label: UILabel = UILabel()
        label.text = "대출중"
        label.textAlignment = .center
        label.font = .preferredFont(forTextStyle: .title3)
        
        return label
    }()
    
    private let buttonStackView: UIStackView = {
        let stackView: UIStackView = UIStackView()
        
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        stackView.spacing = 100
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    private let processTimeStackView: UIStackView = {
        let stackView: UIStackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    private let waitAndProcessTitleLabelStackView: UIStackView = {
        let stackView: UIStackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    private let waitLabelStackView: UIStackView = {
        let stackView: UIStackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    private let processLabelStackView: UIStackView = {
        let stackView: UIStackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    convenience init() {
        self.init(frame: CGRectZero)
        
        backgroundColor = .systemBackground
        configureRootView()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addWaitLabel(customer: Customer) {
        guard let bankingServiceType: BankingService = customer.getBankingServiceType() else { return }
        
        let label: UILabel = UILabel()
        label.text = "\(customer.getWaitingNumber()) - \(bankingServiceType)"
        
        waitLabelStackView.addArrangedSubview(label)
    }
}

// MARK: Configure
extension MainView {
    private func configureRootView() {
        addArrangeSubViews()
        configureConstraint()
    }
    
    private func addArrangeSubViews() {
        buttonStackView.addArrangedSubview(customerAddButton)
        buttonStackView.addArrangedSubview(resetButton)
        
        processTimeStackView.addArrangedSubview(processTimeLabel)
        
        waitAndProcessTitleLabelStackView.addArrangedSubview(waitTitleLabel)
        waitAndProcessTitleLabelStackView.addArrangedSubview(processTitleLabel)
        
        waitLabelStackView.addArrangedSubview(waitLabel)
        processLabelStackView.addArrangedSubview(processLabel)
        
        
        addSubview(buttonStackView)
        addSubview(processTimeStackView)
        addSubview(waitAndProcessTitleLabelStackView)
        addSubview(waitLabelStackView)
        addSubview(processLabelStackView)
        
    }
    
}

// MARK: Constraints
extension MainView {
    private func configureConstraint() {
        configureButtonStackViewConstraint()
        configureProcessTimeStackViewConstraint()
        configureWaitAndProcessLabelStackViewConstraint()
        waitLabelStackViewConstraint()
        processLabelStackViewConstraint()
    }
    
    
    private func configureButtonStackViewConstraint() {
        NSLayoutConstraint.activate([
            buttonStackView.topAnchor.constraint(equalTo: topAnchor, constant: 64),
            buttonStackView.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }
    
    private func configureProcessTimeStackViewConstraint() {
        NSLayoutConstraint.activate([
            processTimeStackView.topAnchor.constraint(equalTo: buttonStackView.bottomAnchor, constant: 16),
            processTimeStackView.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }
    
    private func configureWaitAndProcessLabelStackViewConstraint() {
        NSLayoutConstraint.activate([
            waitAndProcessTitleLabelStackView.topAnchor.constraint(equalTo: processTimeStackView.bottomAnchor, constant: 16),
            waitAndProcessTitleLabelStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            waitAndProcessTitleLabelStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            waitAndProcessTitleLabelStackView.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }
    
    private func waitLabelStackViewConstraint() {
        NSLayoutConstraint.activate([
            waitLabelStackView.topAnchor.constraint(equalTo: waitAndProcessTitleLabelStackView.bottomAnchor, constant: 16),
            waitLabelStackView.centerXAnchor.constraint(equalTo: waitTitleLabel.centerXAnchor)
        ])
    }
    
    private func processLabelStackViewConstraint() {
        NSLayoutConstraint.activate([
            processLabel.topAnchor.constraint(equalTo: waitAndProcessTitleLabelStackView.bottomAnchor, constant: 16),
            processLabel.centerXAnchor.constraint(equalTo: processTitleLabel.centerXAnchor)
        ])
    }
}
