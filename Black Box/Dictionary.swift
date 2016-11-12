import Foundation

extension Dictionary {

    static func loadJSONFromBundle(filename: String) -> Dictionary<String, AnyObject>? {
        if let path = Bundle.main.path(forResource: filename, ofType: "json") {

            var error: NSError?
            let data: Data?
            do {
                data = try Data(contentsOf: URL(fileURLWithPath: path),
                                options: NSData.ReadingOptions())
            } catch let error1 as NSError {
                error = error1
                data = nil
            }
            if let data = data {

                let json: Any?
                do {
                    json = try JSONSerialization.jsonObject(with: data,
                        options: JSONSerialization.ReadingOptions())
                } catch let error1 as NSError {
                    error = error1
                    json = nil
                }
                if let dictionary = json as? Dictionary<String, AnyObject> {
                    return dictionary
                } else {
                    print("File '\(filename)' is not valid JSON: \(error!)")
                    return nil
                }
            } else {
                print("Could not load file: \(filename), error: \(error!)")
                return nil
            }
        } else {
            print("Could not find file: \(filename)")
            return nil
        }
    }

}
