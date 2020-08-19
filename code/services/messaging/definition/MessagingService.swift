//
//  MessagingService.swift
//  
//
//  Created by Ross Butler on 17/08/2020.
//

import Foundation

protocol MessagingService {
    func message(_ message: String, completion: @escaping () -> Void)
}
