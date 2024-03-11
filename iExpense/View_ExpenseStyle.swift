//
//  View_ExpenseStyle.swift
//  iExpense
//
//  Created by Jamila Ruzimetova on 3/10/24.
//

import SwiftUI

extension View {
    func style(for item: ExpenseItem) -> some View {
        if item.amount < 10 {
            return self.font(.body)
        } else if item.amount > 100 {
            return self.font(.title)
        } else {
            return self.font(.title3)
        }
    }
}
