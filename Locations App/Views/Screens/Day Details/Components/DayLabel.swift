//
//  DayLabel.swift
//  Locations App
//
//  Created by Kevin Li on 2/1/20.
//  Copyright © 2020 Kevin Li. All rights reserved.
//

import SwiftUI

struct DayLabel: View {
    let date: Date
    
    var body: some View {
        VStack {
            dayOfMonthText
            fullMonthWithDayText
        }
    }
}

// MARK: Content
private extension DayLabel {
    private var dayOfMonthText: some View {
        Text(date.dayOfWeekBasedOnCurrentDay.uppercased())
            .font(.system(size: 22))
            .fontWeight(.bold)
            .tracking(5)
    }
    
    private var fullMonthWithDayText: some View {
        Text(date.fullMonthWithDay.uppercased())
            .font(.caption)
    }
}

struct DayLabel_Previews: PreviewProvider {
    static var previews: some View {
        DayLabel(date: Date())
    }
}
