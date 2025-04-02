//
//  SquareService.swift
//  zala
//
//  Created by Kyle Carriedo on 9/7/24.
//

import Foundation
import Alamofire
import Combine
import SwiftUI
import ZalaAPI

//curl https://connect.squareupsandbox.com/v2/catalog/list \
//  -H 'Square-Version: 2024-08-21' \
//  -H 'Authorization: Bearer EAAAl8UrfwGl9Dk0gVtXP9qcH3Xd8Zo2yT4bjFWYuiHG6Bvk4EzeWO0DJFYvhzyI' \
//  -H 'Content-Type: application/json'

struct RefreshTokenResponse: Decodable {
    let access_token: String
    let token_type: String
    let expires_at: String
    let refresh_token: String
    let merchant_id: String
}


struct SquarePriceMoney: Codable {
    var amount: Int // 9400,
    var currency: String // "USD"
}

struct SquareItemVariationData: Codable {
    var itemId: String //6VPOIOKQ5XPZOS5MPXZ2GCLE
    var priceMoney: SquarePriceMoney?
    
    enum CodingKeys: String, CodingKey {
        case itemId = "item_id"
        case priceMoney = "price_money"
    }
}

struct SquareItemVariation: Codable {
    var id: String //"LY4WCZW5B4LX2HHIDNK5XUAS",
    var customAttributeValues: [String: [String: String]]?
    var itemVariationData: SquareItemVariationData?
    
    enum CodingKeys: String, CodingKey {
        case id
        case customAttributeValues = "custom_attribute_values"
        case itemVariationData  = "item_variation_data"
    }
    
    func url() -> String? {
        if let customAttributeValues, let key = customAttributeValues.keys.first,
            let json = customAttributeValues[key], let url = json["string_value"] {
            return url
        } else {
            return nil
        }
    }
}

struct SquareItemData: Codable {
    var name: String
    var description: String?
    var variations: [SquareItemVariation]?
    var imageIds: [String]?
    
    enum CodingKeys: String, CodingKey {
        case name
        case description
        case variations
        case imageIds = "image_ids"
    }
}

extension KeyedDecodingContainer {
    func decodeWithLogging<T: Decodable>(_ type: T.Type, forKey key: K) throws -> T {
        do {
            return try decode(T.self, forKey: key)
        } catch DecodingError.keyNotFound(let key, let context) {
            // Log the missing key and context
            throw DecodingError.keyNotFound(key, context)  // Properly rethrow the specific error
        } catch {
            // Re-throw any other errors
            throw error
        }
    }
    
    func decodeIfPresentWithLogging<T: Decodable>(_ type: T.Type, forKey key: K) throws -> T? {
         do {
             return try decodeIfPresent(T.self, forKey: key)
         } catch DecodingError.keyNotFound(_, _) {
             return nil  // Return nil since it's optional
         } catch {
             throw error
         }
     }
}

struct SquareImage: Codable {
    var name: String
    var url: String
}

struct SquareItem: Codable, Hashable {
    
    var id: String //"6VPOIOKQ5XPZOS5MPXZ2GCLE",
    var type: String // "IMAGE" "ITEM",
    var itemData: SquareItemData?
    var imageData: SquareImage?
    
    enum CodingKeys: String, CodingKey {
        case id
        case type
        case itemData = "item_data"
        case imageData = "image_data"
    }
    
    func formattedPrice() -> String {
        if let amount = itemData?.variations?.last?.itemVariationData?.priceMoney?.amount {
            let dollars = Double(amount) / 100  // Convert cents to dollars
            
            let formatter = NumberFormatter()
            formatter.numberStyle = .currency  // Set the style to currency
            formatter.locale = Locale.current   // Use the current locale for currency symbol
            
            // Return formatted string or a fallback in case of failure
            return formatter.string(from: NSNumber(value: dollars)) ?? "\(dollars)"
        } else {
            return "free"
        }
    }
    
    static func == (lhs: SquareItem, rhs: SquareItem) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

struct SquareItemResponse: Codable {
    var objects: [SquareItem]
}

struct SquareAuthCheckResponse: Codable {
    var scopes: [String]?
    var expires_at: String?
}

protocol SquareServiceAPIProtocol {
    func fetchSquareItems() -> AnyPublisher<SquareItemResponse, AFError>
    func checkAuthStatus() -> AnyPublisher<SquareAuthCheckResponse, AFError>
}

struct SquareServiceAPI: SquareServiceAPIProtocol {
    func fetchSquareItems() -> AnyPublisher<SquareItemResponse, AFError> {
        let url = "\(Enviorment.squareURL)/catalog/list?types=IMAGE%2CITEM"
        return AF.request(url, method: .get, encoding: JSONEncoding.default, headers: SquareAPI.headers)
            .validate()
            .publishDecodable(type:SquareItemResponse.self)
            .value()
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    func checkAuthStatus() -> AnyPublisher<SquareAuthCheckResponse, AFError> {
        let url = "https://connect.squareupsandbox.com/oauth2/token/status"
        return AF.request(url, method: .post, encoding: JSONEncoding.default, headers: SquareAPI.headers)
            .validate()
            .publishDecodable(type:SquareAuthCheckResponse.self)
            .value()
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}

struct SquareAPI {
    static let headers: HTTPHeaders = [
        "Square-Version": "2024-08-21",
        "Authorization" : "Bearer EAAAl-B0uQfHfotrDsKSTLRONNkWSH4GPH03l4jEWoD4Y22IpNDo3lf62SUWORKJ"]
}

@Observable class SquareService {
    private var subs: Set<AnyCancellable> = []
    private let networking: SquareServiceAPIProtocol = SquareServiceAPI()
    var storeItems: Set<SquareItem> = []
    var squareImage: [String: SquareImage] = [:]
    
        
    let clientId = "sq0idp-tCHntDwK27jCpZ-5AecLBQ" //stg
    let clientSecret = "MzNlQrJppmJqZgH8Gcz"
    let refreshToken = "EQAAEJoOUy0s5liogtXDCNkFP52068Rr47bo-RJVn9yp1IM2M_gvVosm7hierfRm"
    let isSandbox = true // Change to false for production
    
    func fetchStoreItems() {
        networking.fetchSquareItems().sink { completion in
//            guard let self = self else { return }
            switch completion {
            case .failure(_): break
                
                
            case .finished:()
            }
            
        } receiveValue: { [weak self] response in
            guard let self = self else { return }
            response.objects.forEach { item in
                if item.type.lowercased() == "image" {
                    self.squareImage[item.id] = item.imageData
                } else {
                    self.storeItems.insert(item)
                }
            }
        }
        .store(in: &subs)
    }
    
    func imgFor(_ item: SquareItem) -> String? {
        return squareImage[item.itemData?.imageIds?.first ?? ""]?.url
    }

    func refreshAuthToken(clientId: String,
                          clientSecret: String,
                          refreshToken: String,
                          isSandbox: Bool,
                          completion: @escaping (Result<RefreshTokenResponse, Error>) -> Void) {
        
        let urlString = isSandbox
            ? "https://connect.squareupsandbox.com/oauth2/token"
            : "https://connect.squareup.com/oauth2/token"
        
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "Invalid URL", code: 0, userInfo: nil)))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: Any] = [
            "client_id": clientId,
            "client_secret": clientSecret,
            "grant_type": "refresh_token",
            "refresh_token": refreshToken
        ]
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])
        } catch {
            completion(.failure(error))
            return
        }

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                completion(.failure(NSError(domain: "Invalid response", code: 0, userInfo: nil)))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "No data", code: 0, userInfo: nil)))
                return
            }
            
            do {
                let refreshTokenResponse = try JSONDecoder().decode(RefreshTokenResponse.self, from: data)
                completion(.success(refreshTokenResponse))
            } catch {
                completion(.failure(error))
            }
        }
        
        task.resume()
    }

}


extension Optional where Wrapped == Int {
    // Method to format the price
    var formattedPrice: String {
        guard let cents = self else { return "N/A" }  // Handle nil case
        let dollars = cents / 100  // Convert cents to dollars
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency  // Set the style to currency
        formatter.locale = Locale.current   // Use the current locale for currency symbol
        
        // Return formatted string or a fallback in case of failure
        return formatter.string(from: NSNumber(value: dollars)) ?? "\(dollars)"
    }
}
func isDateExpired(dateString: String) -> Bool {
    let iso8601Formatter = ISO8601DateFormatter()
    iso8601Formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
    
    guard let utcDate = iso8601Formatter.date(from: dateString) else {
        return true // Assume expired if the date format is invalid
    }
    
    // Convert to the desired time zone
    var calendar = Calendar.autoupdatingCurrent
    calendar.timeZone = .current
       
       // Compare the converted date to the current date in the same time zone
    let currentDate = Date()
    return currentDate > utcDate
}
