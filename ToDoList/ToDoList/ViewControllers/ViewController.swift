

import UIKit

class ViewController: UIViewController {
  
  let fileCache = FileCache()
  let jsonName = "Some name"
  
  let createNewButton: UIButton = {
    let button = UIButton(type: .system)
    button.setTitle("Create new", for: .normal)
    return button
  }()
  
  let editButton: UIButton = {
    let button = UIButton(type: .system)
    button.setTitle("Edit first", for: .normal)
    return button
  }()
  
  let saveButton: UIButton = {
    let button = UIButton(type: .system)
    button.setTitle("Save to JSON", for: .normal)
    return button
  }()
  
  let printButton: UIButton = {
    let button = UIButton(type: .system)
    button.setTitle("Print to console", for: .normal)
    return button
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let stack = UIStackView(arrangedSubviews: [createNewButton, editButton, saveButton, printButton])
    stack.translatesAutoresizingMaskIntoConstraints = false
    stack.axis = .vertical
    stack.spacing = 10
    view.addSubview(stack)
    fileCache.loadFromJSON(name: jsonName)
    
    createNewButton.addTarget(self, action: #selector(displayDetailVC(paramSender: )), for: .touchUpInside)
    saveButton.addTarget(self, action: #selector(didTapSaveButton), for: .touchUpInside)
    editButton.addTarget(self, action: #selector(didTapEditButton), for: .touchUpInside)
    printButton.addTarget(self, action: #selector(didTapPrintButton), for: .touchUpInside)
    
    NSLayoutConstraint.activate([
      stack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      stack.centerYAnchor.constraint(equalTo: view.centerYAnchor),
    ])
  }
  
  @objc func displayDetailVC(paramSender: Any) {
    let vc = DetailViewController(openType: .add, item: nil)
    presentDetailts(vc: vc)
  }
  
  @objc private func didTapSaveButton() {
    fileCache.saveToJSON(name: jsonName)
  }
  
  @objc private func didTapEditButton() {
    guard let item = fileCache.dictToDo.first?.value else { return }
    let vc = DetailViewController(openType: .edit, item: item)
    vc.removeCompletion = { [weak self] id in
      self?.fileCache.remove(id: id)
    }
    presentDetailts(vc: vc)
  }
  
  @objc private func didTapPrintButton() {
    print(fileCache.dictToDo)
  }
  
  private func presentDetailts(vc: DetailViewController) {
    let nav = UINavigationController(rootViewController: vc)
    navigationController?.present(nav, animated: true)
    
    vc.saveCompletion = { [weak self] item in
      self?.fileCache.add(toDoItem: item)
    }
  }
}

extension UIViewController {
  func hideKeyboardWhenTappedAround() {
    let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
    tap.cancelsTouchesInView = false
    view.addGestureRecognizer(tap)
  }
  
  @objc func dismissKeyboard() {
    view.endEditing(true)
  }
}

