//
//  Enviorment.swift
//  zala
//
//  Created by Kyle Carriedo on 4/5/24.
//

import Foundation
import ZalaAPI

let isProd = true

struct Enviorment {
    static let stripeURL = isProd ? "https://zala-stripe-microservice-3f368ebe5f4c.herokuapp.com/" : "https://zala-stripe-microservice-stg-f5a95892cd61.herokuapp.com/"
    static let graphQL = isProd ? "https://zala-prod-ad856199b736.herokuapp.com/gql" : "https://zala-stg.herokuapp.com/gql"
    static let eventApi = isProd ? "https://zala-events-api.herokuapp.com/" : "https://zala-events-api.herokuapp.com/"
    static let zalaContent = isProd ? "https://content-microservice-prod-80cf8d069f08.herokuapp.com/" : "https://content-microservice-stg-613843a26cb6.herokuapp.com/"
    static let zalaMessages = isProd ? "https://messaging-microservice-prod-034b50e762e1.herokuapp.com/" : "https://messaging-microservice-stg-022ac415e1e4.herokuapp.com/"
    static let stripeToken = isProd ? "pk_test_51MyfsyIUsgzTHJE03A6XH90kSzOEoFJZ7DyYu3TwyGfKat5Ha594d9fce44kzK9y4fKMaOwONewDgbdbq9valBFV00WD5x5G3l" : "pk_test_51MyfsyIUsgzTHJE03A6XH90kSzOEoFJZ7DyYu3TwyGfKat5Ha594d9fce44kzK9y4fKMaOwONewDgbdbq9valBFV00WD5x5G3l"
    
    static let terraURL = isProd ? "https://zala-terra-microservice-2c4cb7b467c5.herokuapp.com/terra/connect-device" : "https://zala-terra-microservice-stg-154bdaa62030.herokuapp.com/terra/connect-device"
    
    static let squareURL = isProd ? "https://connect.squareupsandbox.com/v2" : "https://connect.squareupsandbox.com/v2"
    

//    static let zalaOrg = isProd ? "5" : "1"
}

extension ID {
    static let zalaOrg = isProd ? "5" : "5"
}
