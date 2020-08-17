//
//  SlackMessagingService.swift
//  
//
//  Created by Ross Butler on 13/08/2020.
//

import Foundation

class SlackMessagingService {
    let hookURL: URL
    
    init(hookURL: URL) {
        self.hookURL = hookURL
    }
    
    func message(_ message: String, completion: @escaping () -> Void) {
        let characterSet = CharacterSet.alphanumerics.union(CharacterSet.whitespacesAndNewlines)
        let formattedMessage = "\(String(message.unicodeScalars.filter { characterSet.contains($0) }))\n"
        var request = URLRequest(url: hookURL)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        
        request.httpBody = "payload={\"text\": \"\(formattedMessage)\"}".data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print(String(describing: error))
                completion()
                return
            }
            if let httpStatus = response as? HTTPURLResponse,
                httpStatus.statusCode != 200 {
                let statusCode = httpStatus.statusCode
                let fullResponse = String(describing: response)
                print("Returned non-200 status code: \(statusCode)\n with response: \(fullResponse)")
                if let responseString = String(data: data, encoding: .utf8) {
                    print(responseString)
                }
            }
            completion()
        }
        task.resume()
    }
}
