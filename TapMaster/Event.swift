//
//  Event.swift
//  TapMaster
//
//  Created by Daniel Thompson on 7/14/17.
//  Copyright © 2017 Seth Bishop. All rights reserved.
//

import Foundation

enum TapEventType {
    case buff
    case freeze
}

struct Event {
    let type: TapEventType
    // rest of event logic
}
