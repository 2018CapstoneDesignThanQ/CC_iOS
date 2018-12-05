//
//  DecodingService.swift
//  CC
//
//  Created by 이혜진 on 2018. 12. 5..
//  Copyright © 2018년 LeeHyeJin. All rights reserved.
//

import Foundation
import SwiftyJSON

public typealias DateFormat = JSONDecoder.DateDecodingStrategy

protocol DecodingService {}

extension DecodingService {
    func decodeJSONData<T: Codable>(_ type: T.Type,
                                    dateFormatter: DateFormatter? = nil,
                                    dateDecodingStrategy: JSONDecoder.DateDecodingStrategy? = nil,
                                    data: Data) -> Result<T> {
        let decoder = JSONDecoder()
        do {
            if let dateFormat = dateFormatter {
                decoder.dateDecodingStrategy = .formatted(dateFormat)
            } else if let dateFormat = dateDecodingStrategy {
                decoder.dateDecodingStrategy = dateFormat
            }
            
            let decodeData = try decoder.decode(T.self, from: data)
            return .success(decodeData)
            
        } catch let err {
            guard let message = JSON(data)["message"].string else {
                return .error(ErrorMessage.parameterEncodeError(err))
            }
            return .error(ErrorMessage.errorMessage(message))
        }
    }
}
