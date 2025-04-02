//
//  Address.swift
//  zala
//
//  Created by Kyle Carriedo on 4/29/24.
//

import Foundation
import ZalaAPI

extension AddressModel {
    func formattedAddressNewLines() ->  String {
        return "\(line1 ?? "")\n\(line2 ?? "")"
    }
}
