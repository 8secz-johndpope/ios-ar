//
//  Player.swift
//  WatchOut
//
//  Created by Guest User on 13/01/2020.
//  Copyright © 2020 iOS1920. All rights reserved.
//

import UIKit

class Player {
   
    var id: Int?
    var limit: Double?
    
    var newTestA: Int = 0
    
    init(id: Int, limit: Double) {
        self.id = id
        self.limit = limit
    }
}
