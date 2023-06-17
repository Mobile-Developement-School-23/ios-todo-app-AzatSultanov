
import Foundation

protocol JsonFunc {
    var dictToDo: [String: ToDoItem] { get }
    func add(toDoItem: ToDoItem)
    
    func remove(id: String)
}

private enum FileFormat: String {
    case json = ".json"
    case csv = ".csv"
}

class FileCache: JsonFunc {
    private(set) var dictToDo: [String: ToDoItem] = [:]
    
    func add(toDoItem: ToDoItem) {
        dictToDo[toDoItem.id] = toDoItem
    }
    func remove(id: String) {
        dictToDo[id] = nil
    }
}

extension FileCache {
    func loadFromJSON(name: String) {
        guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            print("Файл не найден")
            return
        }
        let pathToFile = documentDirectory.appendingPathComponent(name + FileFormat.json.rawValue)
        guard let data = try? Data(contentsOf: pathToFile) else {
            print("Файл поврежден")
            return
        }
        guard let jsonFile = try? JSONSerialization.jsonObject(with: data) as? [Any] else {
            print("Не можем распарсить")
            return
        }

        for jsonItem in jsonFile {
            if let parsedItem = ToDoItem.parse(json: jsonItem) {
                add(toDoItem: parsedItem)
            }
        }
    }
    
    func saveToJSON(name: String) {
        guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            print("Директория не найдена")
            return
        }
        let pathToFile = documentDirectory.appendingPathComponent(name + FileFormat.json.rawValue)
        let jsonItem = dictToDo.map {
            $0.value.json
        }
        guard let data = try? JSONSerialization.data(withJSONObject: jsonItem) else {
            print("Ошибка преобразования в json")
            return
        }
        guard ((try? data.write(to: pathToFile)) != nil) else {
            print("Ошибка при сохранении файла")
            return
        }
    }
}
