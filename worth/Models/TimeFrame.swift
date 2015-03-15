//
//  TimeFrame.swift
//  worth
//
//  Created by Matt Bridges on 3/14/15.
//  Copyright (c) 2015 Matt Bridges. All rights reserved.
//

import Foundation

enum TimeFrame: Int {
    case Year, Month, Week, Day
    static let allValues = [Year, Month, Week, Day]
}