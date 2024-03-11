//
//  ContentView.swift
//  iExpense
//
//  Created by Jamila Ruzimetova on 2/21/24.
//

import SwiftUI
import Observation

struct ExpenseItem: Identifiable, Codable, Equatable {
    var id = UUID()
    let name: String
    let type: String
    let amount: Double
}

@Observable
class Expenses {
    var items = [ExpenseItem]() {
        didSet {
            if let encoded = try? JSONEncoder().encode(items) {
                UserDefaults.standard.set(encoded, forKey: "Items")
            }
        }
    }
    
    var personalItems: [ExpenseItem] {
        items.filter { $0.type == "Personal"}
    }
    
    var businessItems: [ExpenseItem] {
        items.filter { $0.type == "Business"}
    }
    
    init() {
        if let savedItems = UserDefaults.standard.data(forKey: "Items") {
            if let decodedItems = try? JSONDecoder().decode([ExpenseItem].self, from: savedItems) {
                items = decodedItems
                return
            }
        }
        items = []
    }
}

struct ContentView: View {
    @State private var expenses = Expenses()
    @State private var showAddExpense = false
    
    var body: some View {
        NavigationStack {
            List {
                ExpenseSection(title: "Business", expenses: expenses.businessItems, deleteItems: removeBusinessItems)
                ExpenseSection(title: "Personal", expenses: expenses.personalItems, deleteItems: removePersonalItems)
            }
            .navigationTitle("iExpenses")
            .toolbar {
                Button("add Expenses", systemImage: "plus") {
                    showAddExpense = true
                }
            }
            .sheet(isPresented: $showAddExpense) {
                AddView(expenses: expenses)
            }
        }
    }
    
//    offsets of the specific array (all personal offsets)
    func removeItems(at offsets: IndexSet, in inputArray: [ExpenseItem]) {
//        creating empty indexes array
        var objectsToDelete = IndexSet()
//        run through indexes in personal array
        for offset in offsets {
            let item = inputArray[offset]
//            take one item, find the index of this item and put this index to index array
            if let index = expenses.items.firstIndex(of: item) {
                objectsToDelete.insert(index)
            }
        }
        expenses.items.remove(atOffsets: objectsToDelete)
    }
    
    func removePersonalItems(at offsets: IndexSet) {
        removeItems(at: offsets, in: expenses.personalItems)
    }
    
    func removeBusinessItems(at offsets: IndexSet) {
        removeItems(at: offsets, in: expenses.businessItems)
    }
    
    func addExpense() {
        let expense = ExpenseItem(name: "Test", type: "Personal", amount: 12.5)
        expenses.items.append(expense)
    }
}

#Preview {
    ContentView()
}
