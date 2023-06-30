//
//  SeparatorView.swift
//  ToDoList
//
//  Created by Азат Султанов on 22.06.2023.
//

import UIKit

class SeparatorView: UIView {
  
  private let separatorView: UIView = {
    let view = UIView()
    view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.2)
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  
  init() {
    super.init(frame: .zero)
    setupView()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupView() {
    addSubview(separatorView)
    
    NSLayoutConstraint.activate([
      separatorView.heightAnchor.constraint(equalToConstant: 0.5),
      separatorView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
      separatorView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16)
    ])
  }
}
