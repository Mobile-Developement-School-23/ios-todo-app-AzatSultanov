//
//  ImportanceView.swift
//  ToDoList
//
//  Created by Азат Султанов on 22.06.2023.
//

import UIKit

class ImportanceView: UIView {
  
  private(set) var currentImportance: Importance = .normal
  
  private lazy var segmentControl: UISegmentedControl = {
    let importanceArray: [Any] = [Images.imageSegment1?.withTintColor(Colors.LightTheme.lightGray, renderingMode: .alwaysOriginal),
                                  "нет",
                                  Images.imageSegment3?.withTintColor(Colors.LightTheme.red, renderingMode: .alwaysOriginal)]
    let segmentControl = UISegmentedControl(items: importanceArray)
    segmentControl.translatesAutoresizingMaskIntoConstraints = false
    segmentControl.selectedSegmentIndex = currentImportance.segmentValue
    return segmentControl
  }()
  
  private let importanceLabel: UILabel = {
    let label = UILabel()
    label.text = "Важность"
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  init() {
    super.init(frame: .zero)
    setupUI()
    segmentControl.addTarget(self, action: #selector(didChangeSegmentValue(_ :)), for: .valueChanged)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  public func setup(importance: Importance) {
    currentImportance = importance
    segmentControl.selectedSegmentIndex = currentImportance.segmentValue
  }
  
  private func setupUI() {
    addSubview(importanceLabel)
    addSubview(segmentControl)
    
    NSLayoutConstraint.activate([
      importanceLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
      importanceLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
      importanceLabel.trailingAnchor.constraint(equalTo: segmentControl.leadingAnchor, constant: -16),
      
      segmentControl.topAnchor.constraint(equalTo: topAnchor, constant: 10),
      segmentControl.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
      segmentControl.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -11),
      segmentControl.heightAnchor.constraint(equalToConstant: 36),
      segmentControl.widthAnchor.constraint(equalToConstant: 150)
    ])
  }
  
  @objc private func didChangeSegmentValue(_ target: UISegmentedControl) {
    guard let importance =  Importance.getImportance(by: target.selectedSegmentIndex) else { return }
    currentImportance = importance
  }
}
