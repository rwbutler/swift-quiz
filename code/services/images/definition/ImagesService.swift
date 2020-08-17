//
//  ImagesService.swift
//  
//
//  Created by Ross Butler on 14/08/2020.
//

import Foundation

public protocol ImagesService {
    func showImage(questionId: UUID,  image: Data)
}
