//
//  BusSeatBookingViewModel.swift
//  BusSeat
//
//  Created by Dkatalis on 13/02/22.
//

import UIKit

enum Compartment: CaseIterable {
    case driverSeat
    case passengerSeat
}

class BusSeatBookingViewModel {
    
    var sections : [Compartment] = [.driverSeat, .passengerSeat]
    
    func numberOfSeat(compartment: Compartment) -> Int {
        switch compartment {
        case .driverSeat:
            return 1
        case .passengerSeat:
            return 33
        }
    }
}
