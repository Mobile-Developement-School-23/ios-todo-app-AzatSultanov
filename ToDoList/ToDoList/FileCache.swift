
import Foundation

private enum FileFormat: String {
    case json = ".json"
    case csv = ".csv"
}

extension FileCache {
    func loadFromJSON(name: String) {
        if let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let pathToFile = documentDirectory.appendingPathComponent(name + FileFormat.json.rawValue)
            if let data = try? Data(contentsOf: pathToFile) {
                if let jsonFile = try? JSONSerialization.jsonObject(with: data) as? [Any] {
                    for jsonItem in jsonFile {
                        if let parsedItem = ToDoItem.parse(json: jsonItem) {
                            add(toDoItem: parsedItem)
                        }
                    }
                } else {
                    print("Не можем распарсить")
                }
            } else {
                print("Файл поврежден")
            }
        } else {
            print("Файл не найден")
        }
    }
    
    func saveToJSON(name: String) {
        if let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let pathToFile = documentDirectory.appendingPathComponent(name + FileFormat.json.rawValue)
            let jsonItem = dictToDo.map {
                $0.value.json
            }
            if let data = try? JSONSerialization.data(withJSONObject: jsonItem) {
                guard ((try? data.write(to: pathToFile)) != nil) else {
                    print("Ошибка при сохранении файла")
                    return
                }
            } else {
                print("Ошибка преобразования в json")
            }
        } else {
            print("Директория не найдена")
        }
    }
}

class FileCache {
    private(set) var dictToDo: [String: ToDoItem] = [:]
    
    func add(toDoItem: ToDoItem) {
        dictToDo[toDoItem.id] = toDoItem
    }
    func remove(id: String) {
        dictToDo[id] = nil
    }
}
