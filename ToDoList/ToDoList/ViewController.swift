

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let fileCache1 = FileCache()
        let fileCache2 = FileCache()
        let toDoItem = ToDoItem(text: "Ilgam", importance: .important, isDone: true)
        let toDoItem2 = ToDoItem(text: "Krasava", importance: .normal, isDone: false)
        fileCache1.add(toDoItem: toDoItem)
        fileCache1.add(toDoItem: toDoItem2)
        fileCache1.saveToJSON(name: "jsonTest")
        fileCache2.loadFromJSON(name: "jsonTest")
        print(fileCache2.dictToDo)
        print(getDocumentsDirectory())
    }
    
    func getDocumentsDirectory() -> URL {
            let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
            let documentsDirectory = paths[0]
            return documentsDirectory
        }


}

