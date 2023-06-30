//
//  DetailViewController.swift
//  ToDoList
//
//  Created by Азат Султанов on 22.06.2023.
//

import UIKit

class DetailViewController: UIViewController {
  
  enum OpenType {
    case add
    case edit
  }
  
  // MARK: - Properties
  private let openType: OpenType
  private let item: ToDoItem?
  private let dateFormatter: DateFormatter = {
    let dateFormat = DateFormatter()
    dateFormat.locale = Locale(identifier: "Ru_ru")
    dateFormat.dateFormat = "dd LLLL YYYY"
    return dateFormat
  }()
  
  private var currentSelected: Date?
  
  public var saveCompletion: ((ToDoItem) -> Void)?
  public var removeCompletion: ((String) -> Void)?

  // MARK: - UI Elements
  private let scrollView = UIScrollView()
  
  private let textView: UITextView = {
    let textView = UITextView()
    textView.layer.cornerRadius = 16
    textView.translatesAutoresizingMaskIntoConstraints = false
    textView.backgroundColor = .white
    textView.textContainer.lineBreakMode = .byWordWrapping
    textView.font = UIFont.systemFont(ofSize: 17)
    textView.text = "Что надо сделать?"
    textView.textColor = UIColor.lightGray
    textView.isScrollEnabled = false
    textView.textContainerInset = UIEdgeInsets(top: 17, left: 16, bottom: 12, right: 16)
    return textView
  }()
  
  private let importanceView = ImportanceView()
  private let deadLineView = DeadlineView()
  
  private let calendarSeparator: SeparatorView = {
    let separator = SeparatorView()
    separator.isHidden = true
    return separator
  }()
  
  private let calendarView: CalendarView = {
    let view = CalendarView()
    view.isHidden = true
    return view
  }()
  
  // MARK: button property
  private let removeButton: UIButton = {
    let button = UIButton()
    button.setTitle("Удалить", for: .normal)
    button.setTitleColor(.red, for: .normal)
    button.setTitleColor(Colors.LightTheme.labelTertiary, for: .disabled)
    button.layer.cornerRadius = 16
    button.backgroundColor = .white
    button.translatesAutoresizingMaskIntoConstraints = false
    return button
  }()
  
  // MARK: stacks
  private let impAndDeadStack: UIStackView = {
    let stack = UIStackView()
    stack.axis = .vertical
    stack.translatesAutoresizingMaskIntoConstraints = false
    stack.backgroundColor = .white
    stack.layer.cornerRadius = 16
    stack.spacing = 0
    return stack
  }()
  
  private let contentStack: UIStackView = {
    let stack = UIStackView()
    stack.axis = .vertical
    stack.translatesAutoresizingMaskIntoConstraints = false
    stack.spacing = 16
    return stack
  }()
  
  private let saveButton: UIButton = {
    let button = UIButton()
    button.setTitle("Сохарнить", for: .normal)
    button.setTitleColor(Colors.LightTheme.blue, for: .normal)
    button.setTitleColor(Colors.LightTheme.labelTertiary, for: .disabled)
    button.titleLabel?.font = .systemFont(ofSize: 17)
    return button
  }()
  
  // MARK: - Init
  
  init(openType: OpenType, item: ToDoItem?) {
    self.openType = openType
    self.item = item
    super.init(nibName: nil, bundle: nil)
    removeButton.isEnabled = openType == .edit
    
    if let date = item?.deadLine {
      currentSelected = date
      calendarSeparator.isHidden = false
      calendarView.isHidden = false
      deadLineView.setup(switchEnabled: true)
      deadLineView.changeDeadlineButton(title: dateFormatter.string(from: date))
    }
    
    if let text = item?.text {
      textView.text = text
      textView.textColor = .black
    }
    
    if let importance = item?.importance {
      importanceView.setup(importance: importance)
    }
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.hideKeyboardWhenTappedAround()
    textView.delegate = self
    calendarView.setCalendarDelegate(delegate: self)
    calendarView.setup(selectedDate: item?.deadLine)
    
    removeButton.addTarget(self, action: #selector(didTapRemoveButton), for: .touchUpInside)
    saveButton.addTarget(self, action: #selector(didTapSaveButton), for: .touchUpInside)
    navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Отменить", style: .plain, target: self, action: #selector(cancelButton))
    navigationItem.rightBarButtonItem = UIBarButtonItem(customView: saveButton)
    navigationItem.rightBarButtonItem?.isEnabled = openType == .edit
    
    self.title = "Дело"
    
    view.backgroundColor = .systemGray4

    impAndDeadStack.addArrangedSubview(importanceView)
    impAndDeadStack.addArrangedSubview(SeparatorView())
    impAndDeadStack.addArrangedSubview(deadLineView)
    impAndDeadStack.addArrangedSubview(calendarSeparator)
    impAndDeadStack.addArrangedSubview(calendarView)
    
    contentStack.addArrangedSubview(textView)
    contentStack.addArrangedSubview(impAndDeadStack)
    contentStack.addArrangedSubview(removeButton)
    
    deadLineView.dateButtonTapCompletion = { [weak self] in
      self?.calendarSeparator.isHidden = false
      self?.calendarView.isHidden = false
    }
    
    deadLineView.switchOffCompletion = { [weak self] in
      self?.calendarSeparator.isHidden = true
      self?.calendarView.isHidden = true
      self?.currentSelected = nil
    }
    
    setupScrollView()
    
    NSLayoutConstraint.activate([
      contentStack.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
      contentStack.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
      contentStack.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
      contentStack.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
      
      scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
      scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
      scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
      
      textView.heightAnchor.constraint(greaterThanOrEqualToConstant: 120),
      
      removeButton.heightAnchor.constraint(equalToConstant: 56),
    ])
  }
  
  // MARK: - Private
  private func setupScrollView() {
    scrollView.addSubview(contentStack)
    scrollView.alwaysBounceVertical = true
    scrollView.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(scrollView)
  }
  
  private func updateSaveButtonAvailability() {
    navigationItem.rightBarButtonItem?.isEnabled = !textView.text.isEmpty
  }
  
  // MARK: - Objc
  @objc private func didTapSaveButton() {
    let newItem: ToDoItem
    if let item = item {
      newItem = item.update(text: textView.text,
                                importance: importanceView.currentImportance,
                                deadline: currentSelected)
    } else {
      newItem = ToDoItem(text: textView.text,
                         importance: importanceView.currentImportance,
                         deadLine: currentSelected)
    }
    saveCompletion?(newItem)
    navigationController?.dismiss(animated: true)
  }
  
  @objc private func cancelButton() {
    dismiss(animated: true)
  }
  
  @objc private func didTapRemoveButton() {
    guard let id = item?.id else { return }
    removeCompletion?(id)
    dismiss(animated: true)
  }
}

// MARK: - UITextViewDelegate
extension DetailViewController: UITextViewDelegate {
  func textViewDidBeginEditing(_ textView: UITextView) {
    if textView.textColor == UIColor.lightGray {
      textView.text = nil
      textView.textColor = UIColor.black
    }
  }
  
  func textViewDidEndEditing(_ textView: UITextView) {
    if textView.text.isEmpty {
      textView.text = "Что надо сделать?"
      textView.textColor = UIColor.lightGray
    }
  }
  
  func textViewDidChange(_ textView: UITextView) {
    updateSaveButtonAvailability()
  }
}

// MARK: - UICalendarSelectionSingleDateDelegate
extension DetailViewController: UICalendarSelectionSingleDateDelegate {
  func dateSelection(_ selection: UICalendarSelectionSingleDate, didSelectDate dateComponents: DateComponents?) {
    let date = Calendar.current.date(from: dateComponents ?? DateComponents())
    let titleDate = dateFormatter.string(from: date ?? Date())
    currentSelected = date
    
    deadLineView.changeDeadlineButton(title: titleDate)
  }
}
