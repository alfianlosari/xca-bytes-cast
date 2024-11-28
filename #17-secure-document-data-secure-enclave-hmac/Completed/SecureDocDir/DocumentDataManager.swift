
import Foundation

struct DocumentDataManager {
      
    var url: URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
    
    func save(data: Data, filename: String) throws {
        let fileURL = url.appendingPathComponent(filename)
        try data.write(to: fileURL)
    }
    
    func load(filename: String) throws -> Data {
        let fileURL = url.appendingPathComponent(filename)
        return try Data(contentsOf: fileURL)
    }
}


