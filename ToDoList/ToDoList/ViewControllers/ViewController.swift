

import UIKit

class ViewController: UIViewController {
  
  let fileCache = FileCache()
  let jsonName = "Some name"
  var items: [ToDoItem] = []
  var doneItems: [ToDoItem] = []
  
  let titleLabel = UILabel()
  let doneTaskCountLabel = UILabel()
  let showButton = UIButton(type: .system)
  let horizontalStack = UIStackView()
  
  let tableView = UITableView()
  let itemStack = UIStackView()
  let addButton = UIButton(type: .system)
  
  var isDoneCounter: Int = 0
  let tableViewCell = TableViewCell()

  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .systemGray5
    
    updateItems()
    setupNavigationBar()
    setupHorizontalStack()
    setupTableView()
    setupAddButton()
    setupConstraints()
    
  }
  
  private func updateItems() {
    fileCache.loadFromJSON(name: jsonName)
    items = Array(fileCache.dictToDo.values).sorted(by: { $0.creationDate > $1.creationDate})
    isDoneCounter = 0
    checkCounter()
  }
  
  private func setupNavigationBar() {
    navigationController?.navigationBar.prefersLargeTitles = true
    navigationItem.title = "Мои дела"
  }
  
  private func setupDoneTaskCountLabel() {
    doneTaskCountLabel.text = "Выполнено - \(isDoneCounter)"
    
    doneTaskCountLabel.font = .systemFont(ofSize: 17, weight: .regular)
    
    doneTaskCountLabel.translatesAutoresizingMaskIntoConstraints = false
  }
  
  private func setupShowButton() {
    showButton.setTitle("Скрыть", for: .normal)
    
    showButton.titleLabel?.font = .systemFont(ofSize: 15, weight: .medium)
    
    
    showButton.addTarget(self, action: #selector(didTapShowButton), for: .touchUpInside)
    
    showButton.translatesAutoresizingMaskIntoConstraints = false
  }
  
  @objc func didTapShowButton() {
    if showButton.titleLabel?.text == "Показать" {
      showButton.setTitle("Скрыть", for: .normal)
      addDoneItems()
      tableView.reloadData()
    } else {
      showButton.setTitle("Показать", for: .normal)
      removeDoneItems()
      tableView.reloadData()
    }
  }
  
  private func setupHorizontalStack() {
    setupDoneTaskCountLabel()
    setupShowButton()
    
    horizontalStack.addArrangedSubview(doneTaskCountLabel)
    horizontalStack.addArrangedSubview(showButton)
    
    horizontalStack.distribution = .fill
    horizontalStack.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(horizontalStack)
  }
  
  private func setupAddButton() {
    addButton.backgroundColor = .white
    addButton.setImage(Images.addButton, for: .normal)
    
    if traitCollection.userInterfaceStyle == .dark {
      addButton.layer.shadowColor = UIColor.systemBlue.cgColor
    } else {
      addButton.layer.shadowColor = UIColor.black.cgColor
    }
    addButton.layer.shadowOpacity = 0.2
    addButton.layer.shadowOffset = CGSize(width: 0, height: 22)
    addButton.layer.shadowRadius = 22
    addButton.layer.cornerRadius = 22
    
    addButton.addTarget(self, action: #selector(displayDetailVC), for: .touchUpInside)
    
    addButton.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(addButton)
  }
  
  @objc func displayDetailVC() {
    let vc = DetailViewController(openType: .add, item: nil)
    presentDetailts(vc: vc)
  }
  
  private func setupTableView() {
    tableView.backgroundColor = .clear
    
    tableView.layer.cornerRadius = 16
    
    tableView.delegate = self
    tableView.dataSource = self
    
    tableView.register(TableViewCell.self, forCellReuseIdentifier: TableViewCell.identifire)
    tableView.register(UITableViewCell.self, forCellReuseIdentifier: "AddNewCell")
    
    tableView.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(tableView)
  }
  
  private func setupConstraints() {
    NSLayoutConstraint.activate([
      addButton.heightAnchor.constraint(equalToConstant: 44),
      addButton.widthAnchor.constraint(equalToConstant: 44),
      
      horizontalStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
      horizontalStack.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
      horizontalStack.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
      horizontalStack.bottomAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
      
      tableView.topAnchor.constraint(equalTo: horizontalStack.bottomAnchor, constant: 16),
      tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
      tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
      tableView.bottomAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.bottomAnchor),
      
      addButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      addButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
    ])
  }
  
//  @objc func didTapIsDoneButton() {
//    tableViewCell.isDoneButtonCompletion = { [weak self] n in
//      self?.isDoneCounter = (self?.isDoneCounter ?? 0) + n
//      self?.doneTaskCountLabel.text = "Выполнено - \(self!.isDoneCounter)"
//    }
//  }
  
  private func removeDoneItems() {
    var items: [ToDoItem] = []
    var doneItems: [ToDoItem] = []
    if self.items.count > 0 {
      for i in 0..<self.items.count {
        if self.items[i].isDone {
          doneItems.append(self.items[i])
        } else {
          items.append(self.items[i])
        }
      }
    }
    self.doneItems = doneItems.sorted(by: { $0.creationDate > $1.creationDate })
    self.items = items.sorted(by: { $0.creationDate > $1.creationDate })
  }
  
  private func addDoneItems() {
    var items = self.items
    
    if doneItems.count > 0 {
      for i in 0...doneItems.count - 1 {
        items.append(doneItems[i])
      }
    }
    self.items = items.sorted(by: { $0.creationDate > $1.creationDate })
    doneItems = []
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
      self?.showButton.titleLabel?.text = "Скрыть"
      self?.addDoneItems()
      self?.fileCache.add(toDoItem: item)
      self?.fileCache.saveToJSON(name: self?.jsonName ?? "hui")
      self?.updateItems()
      self?.tableView.reloadData()
    }
  }
  
  private func updateItem(isDone: Bool, index: Int) {
    items[index] = ToDoItem(id: items[index].id,
                            text: items[index].text,
                            importance: items[index].importance,
                            deadLine: items[index].deadLine,
                            isDone: isDone,
                            creationDate: items[index].creationDate,
                            changeDate: Date())
    fileCache.remove(id: items[index].id)
    fileCache.add(toDoItem: items[index])
    fileCache.saveToJSON(name: jsonName)
//    updateItems()
  }
  
  private func checkCounter() {
    for item in items {
      if item.isDone {
        isDoneCounter += 1
      }
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

extension ViewController: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return items.count + 1
  }
  
  // MARK: data source table view
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    switch indexPath.row {
    case items.count:
      let cell = tableView.dequeueReusableCell(withIdentifier: "AddNewCell", for: indexPath)
      var config = cell.defaultContentConfiguration()

      config.text = "Новое"
      config.textProperties.font = .systemFont(ofSize: 17)
      config.textProperties.color = .gray

      config.image = UIImage()
      config.imageToTextPadding = 33

      cell.contentConfiguration = config
      
      cell.layer.cornerRadius = 16
      cell.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]

      cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)
      
      return cell

    default:
      let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.identifire, for: indexPath) as! TableViewCell

      cell.configure(item: items[indexPath.row])

      cell.accessoryType = .disclosureIndicator
      cell.separatorInset = UIEdgeInsets(top: 0, left: 52, bottom: 0, right: .leastNormalMagnitude)
      
      cell.isDoneButtonCompletion = { [weak self] isDone in
        if isDone {
          self?.isDoneCounter += 1
        } else {
          self?.isDoneCounter -= 1
        }
        self?.doneTaskCountLabel.text = "Выполнено - \(self!.isDoneCounter)"
        self?.updateItem(isDone: isDone, index: indexPath.row)
      }
      
//      if items[indexPath.row].isDone {
//        cell.isHidden = true
//      } else {
//        cell.isHidden = false
//      }

      return cell
    }
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    guard indexPath.row != items.count
    else {
      displayDetailVC()
      return
    }
    
    let selectedItem = items[indexPath.row]
    let vc = DetailViewController(openType: .edit, item: selectedItem)
    vc.removeCompletion = { [weak self] id in
      self?.fileCache.remove(id: id)
      self?.fileCache.saveToJSON(name: self?.jsonName ?? "hui")
      self?.updateItems()
      self?.tableView.reloadData()
    }
    presentDetailts(vc: vc)
  }
  
  func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
    let deleteAction = UIContextualAction(style: .normal, title:  "Delete", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
//      if self.showButton.titleLabel?.text == "Показать" {
//        self.fileCache.remove(id: self.items[indexPath.row].id)
//      } else {
//        self.fileCache.remove(id: self.doneItems[indexPath.row].id)
//      }
      self.showButton.titleLabel?.text = "Скрыть"
      self.addDoneItems()
      self.fileCache.remove(id: self.items[indexPath.row].id)
      self.tableView.reloadData()
      self.fileCache.saveToJSON(name: self.jsonName)
      self.updateItems()
      self.tableView.deleteRows(at: [indexPath], with: .fade)
      self.tableView.reloadData()
      success(true)
        })
    if indexPath.row != self.items.count {
      deleteAction.backgroundColor = .systemRed
      
      return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    return nil
  }
  
  func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
    let modifyAction = UIContextualAction(style: .normal, title:  "Update", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
      self.isDoneCounter += 1
      self.doneTaskCountLabel.text = "Выполнено - \(self.isDoneCounter)"
      self.updateItem(isDone: true, index: indexPath.row)
      self.tableView.reloadData()
      success(true)
      })
    if indexPath.row != self.items.count {
      modifyAction.backgroundColor = .systemGreen
      return UISwipeActionsConfiguration(actions: [modifyAction])
    }
    return nil
  }
}
