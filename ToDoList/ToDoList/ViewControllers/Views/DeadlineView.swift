//
//  DeadlineView.swift
//  ToDoList
//
//  Created by Азат Султанов on 22.06.2023.
//

import UIKit

class DeadlineView: UIView {
  
  public var dateButtonTapCompletion: (() -> Void)?
  public var switchOffCompletion: (() -> Void)?
  public var switchOnCompletion: (() -> Void)?

  
  private let deadLineLabel: UILabel = {
    let label = UILabel()
    label.text = "Сделать до"
    return label
  }()
  
  private let deadLineSwitch: UISwitch = {
    let switchdl = UISwitch()
    switchdl.translatesAutoresizingMaskIntoConstraints = false
    return switchdl
  }()
  
  private let dateButton: UIButton = {
    let button = UIButton()
    let dateFormat = DateFormatter()
    dateFormat.locale = Locale(identifier: "Ru_ru")
    dateFormat.dateFormat = "dd LLLL YYYY"
    
    let date = Date()
    
    let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: date)
    
    let titleDate = dateFormat.string(from: tomorrow ?? Date())
    
    button.setTitle("\(titleDate)", for: .normal)
    button.titleLabel?.font = .systemFont(ofSize: 13)
    button.setTitleColor(.systemBlue, for: .normal)
    button.isHidden = true
    return button
  }()
  
  private let deadDateStack: UIStackView = {
    let stack = UIStackView()
    stack.axis = .vertical
    stack.translatesAutoresizingMaskIntoConstraints = false
    stack.backgroundColor = .white
    stack.spacing = 0
    return stack
  }()
  
  init() {
    super.init(frame: .zero)
    setupView()
    dateButton.addTarget(self, action: #selector(dateButtonTapped), for: .touchUpInside)
    deadLineSwitch.addTarget(self, action: #selector(didSwitch(target: )), for: .valueChanged)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  public func changeDeadlineButton(title: String) {
    dateButton.setTitle(title, for: .normal)
  }
  
  public func setup(switchEnabled: Bool) {
    deadLineSwitch.isOn = switchEnabled
    dateButton.isHidden = !switchEnabled
  }
  
  private func setupView() {
    deadDateStack.addArrangedSubview(deadLineLabel)
    deadDateStack.addArrangedSubview(dateButton)
    addSubview(deadDateStack)
    addSubview(deadLineSwitch)
    
    NSLayoutConstraint.activate([
      deadLineSwitch.topAnchor.constraint(equalTo: topAnchor, constant: 12.5),
      deadLineSwitch.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
      deadLineSwitch.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12.5),
      
      deadDateStack.centerYAnchor.constraint(equalTo: centerYAnchor),
      deadDateStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16)
    ])
  }
  
  @objc func dateButtonTapped() {
    dateButtonTapCompletion?()
  }
  
  @objc func didSwitch(target: UISwitch) {
    if !target.isOn {
      switchOffCompletion?()
    } else {
      switchOnCompletion?()
    }
    
    dateButton.isHidden = !target.isOn
    
  }
}
