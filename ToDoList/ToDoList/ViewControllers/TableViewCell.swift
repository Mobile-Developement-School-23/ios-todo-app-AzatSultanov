//
//  TableViewCell.swift
//  ToDoList
//
//  Created by Азат Султанов on 30.06.2023.
//

import UIKit

class TableViewCell: UITableViewCell {
  let textItem = UILabel()
  let deadlineLabel = UILabel()
  let isDoneButton = UIButton(type: .system)
  let labelsStack = UIStackView()
  
  private var importance = Importance.normal
  private var isDone = false
  private var text: String?
  private let deadlineView = DeadlineView()
  
  public var isDoneButtonCompletion: ((Bool) -> Void)?

  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    
    setupUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    textItem.attributedText = NSAttributedString(string: text ?? "", attributes: [NSAttributedString.Key.strikethroughStyle: 0])
  }
  
  private func setupUI() {
    setupIsDoneButton()
    setupLabelsStack()
    setupConstraints()
  }
  
  private func setupText() {
    textItem.font = .systemFont(ofSize: 17)
    textItem.numberOfLines = 3
    textItem.translatesAutoresizingMaskIntoConstraints = false
  }
  
  private func setupDeadlineLabel() {
    
    deadlineLabel.font = .systemFont(ofSize: 14)
    
    deadlineLabel.translatesAutoresizingMaskIntoConstraints = false
    deadlineLabel.isHidden = true
  }
  
  private func setupLabelsStack() {
    setupText()
    setupDeadlineLabel()
    
    labelsStack.addArrangedSubview(textItem)
    labelsStack.addArrangedSubview(deadlineLabel)
    
    labelsStack.spacing = 5
    labelsStack.axis = .vertical
    labelsStack.alignment = .leading
    
    labelsStack.translatesAutoresizingMaskIntoConstraints = false
    contentView.addSubview(labelsStack)
  }
  
  private func setupIsDoneButton() {
    isDoneButton.setImage(Images.isDoneButton.circle, for: .normal)
    
    isDoneButton.addTarget(self, action: #selector(changeIsDoneState), for: .touchUpInside)
    isDoneButton.translatesAutoresizingMaskIntoConstraints = false
    contentView.addSubview(isDoneButton)
  }
  
  @objc private func changeIsDoneState() {
    isDone = !isDone
    isDoneButtonCompletion?(isDone)
    checkState()
  }
  
  private func checkState() {
    guard let text = text,
          let highPriorityImage = Images.imageSegment3,
          let lowPriorityImage = Images.imageSegment1 else { return }
//    textItem.attributedText = NSAttributedString(string: text, attributes: [NSAttributedString.Key.strikethroughStyle: 0])
    
    switch (isDone, importance) {
    case (true, _):
      isDoneButton.setImage(Images.isDoneButton.doneCircle, for: .normal)
      isDoneButton.tintColor = .systemGreen
    
      let attributtedString = NSAttributedString(string: text, attributes: [
        NSAttributedString.Key.strikethroughStyle: NSUnderlineStyle.single.rawValue
      ])
      textItem.attributedText = attributtedString
      
    case (false, .unimportant):
      isDoneButton.setImage(Images.isDoneButton.circle, for: .normal)
      isDoneButton.tintColor = .gray
      
//      let attributtedString = NSMutableAttributedString(string: text)
//      attributtedString.removeAttribute(.strikethroughStyle, range: NSRange(location: 0, length: attributtedString.length))
      textItem.attributedText = NSAttributedString(string: text)
      textItem.attributedText = addImageString(text: text, image: lowPriorityImage)
      
    case (false, .normal):
      isDoneButton.setImage(Images.isDoneButton.circle, for: .normal)
      isDoneButton.tintColor = .gray
      
//      let attributtedString = NSMutableAttributedString(string: text)
//      attributtedString.removeAttribute(.strikethroughStyle, range: NSRange(location: 0, length: attributtedString.length))
      textItem.attributedText = NSAttributedString(string: text)
      
//      let attributedString = NSAttributedString(string: text)
//      textItem.attributedText = attributedString
      
    case (false, .important):
      isDoneButton.setImage(Images.isDoneButton.redCircle, for: .normal)
      isDoneButton.tintColor = .red
      
//      let attributtedString = NSMutableAttributedString(string: text)
//      attributtedString.removeAttribute(.strikethroughStyle, range: NSRange(location: 0, length: attributtedString.length))
//      textItem.attributedText = NSAttributedString(string: text)
      
      textItem.attributedText = addImageString(text: text, image: highPriorityImage)
    }
  }
  
  private func addImageString(text: String, image: UIImage) -> NSAttributedString {
    let attributes: [NSAttributedString.Key: Any] = [.paragraphStyle: NSTextAlignment.center]
    let attributtedString = NSMutableAttributedString(string: "", attributes: attributes)
    
    let attachment = NSTextAttachment(image: image)
    let imageString = NSMutableAttributedString(attachment: attachment)
    imageString.append(NSAttributedString(string: "\u{2002}"))
    attributtedString.append(imageString)
    
    attributtedString.append(NSAttributedString(string: text))
    
    return attributtedString
  }
  
  
  
  private func setupConstraints() {
    NSLayoutConstraint.activate([
      isDoneButton.heightAnchor.constraint(equalToConstant: 24),
      isDoneButton.widthAnchor.constraint(equalToConstant: 24),
      
      isDoneButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
      isDoneButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
      isDoneButton.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -16),
      
      labelsStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
      labelsStack.leadingAnchor.constraint(equalTo: isDoneButton.trailingAnchor, constant: 12),
      labelsStack.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -39),
      labelsStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
    ])
  }
  
  func configure(item: ToDoItem) {
    textItem.text = item.text
    self.text = item.text
    importance = item.importance
    isDone = item.isDone
    if let date = item.deadLine,
       let image = Images.calendarImage {
      deadlineLabel.isHidden = false
      deadlineLabel.attributedText = addImageString(text: formatDateWithoutYearToString(date), image: image)
    } else {
      deadlineLabel.isHidden = true
    }
    checkState()
//    deadlineView.switchOffCompletion = { [weak self] in
//      self?.deadlineLabel.isEnabled = false
//    }
  }
}

extension UITableViewCell {
  static var identifire: String {
    return String(describing: Self.self)
  }
}

