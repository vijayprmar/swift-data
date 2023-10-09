//
//  ContentView.swift
//  SwiftDataExample
//
//  Created by Vijay Parmar on 09/10/23.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) var context
    @State private var isShowingItemSheet = false
    @Query(sort: \Expense.date) var expense : [Expense] = []
    @State private var expenseToEdit:Expense?
    
    var body: some View {
        NavigationStack{
            List{
                ForEach(expense){ expense in
                    ExpenseCell(expense:expense)
                        .onTapGesture {
                            expenseToEdit = expense
                        }
                }
                .onDelete(perform: { indexSet in
                    for index in indexSet{
                        context.delete(expense[index])
                    }
                })
            }
            .navigationTitle("Expense")
            .navigationBarTitleDisplayMode(.large)
            .sheet(isPresented: $isShowingItemSheet) {
                AddExpenseSheet()
            }
            .sheet(item: $expenseToEdit){ expense in
                UpdateExpenseSheet(expense: expense)
            }
            .toolbar{
                if !expense.isEmpty{
                    Button("Add Expense",systemImage: "plus"){
                        isShowingItemSheet = true
                    }
                }
            }
            .overlay {
                if expense.isEmpty{
                    
                    ContentUnavailableView(label: {
                        Label("No Expenses", systemImage: "list.bullet.rectangle.portrait")
                    }, description: {
                        Text("Start adding expenses to see your list.")
                    }, actions: {
                        Button(action: {}) {
                            Button("Add Expense"){
                                isShowingItemSheet = true
                            }
                        }
                    })
                    .offset(y:-60)
                }
            }
            
        }
    }
}


struct ExpenseCell:View {
    
    let expense:Expense
    
    var body: some View {
        HStack{
            Text(expense.date, format : .dateTime.month(.abbreviated).day())
                .frame(width: 70, alignment: .leading)
            Text(expense.name)
            Spacer()
            Text(expense.value,format: .currency(code: "USD"))
            
            
        }
    }
}


struct AddExpenseSheet:View {
    @Environment(\.modelContext) var context
    @Environment(\.dismiss) private var dismiss
    
    @State private var name:String = ""
    @State private var date:Date = .now
    @State private var value:String = ""
    
    
    var body: some View {
        NavigationStack{
            
            Form{
                TextField("Expense Name",text: $name)
                DatePicker("Date",selection: $date,displayedComponents: .date)
                TextField("Value",text: $value)
            }
            .navigationTitle("New Expense")
            .navigationBarTitleDisplayMode(.large)
            .toolbar(content: {
                ToolbarItemGroup(placement:.topBarLeading) {
                    Button("Cancel"){
                        dismiss()
                    }
                }
                
                ToolbarItemGroup(placement:.topBarTrailing) {
                    Button("Save"){
                        let expense = Expense(name: name, date: date, value: Double(value) ?? 0)
                        context.insert(expense)
                        dismiss()
                    }
                }
            })
        }
    }
}


struct UpdateExpenseSheet:View {
    
    @Environment(\.dismiss) private var dismiss
    @Bindable var expense:Expense
    
    var body: some View {
        NavigationStack{
            
            Form{
                TextField("Expense Name",text: $expense.name)
                DatePicker("Date",selection: $expense.date,displayedComponents: .date)
                TextField("Value",value:$expense.value,format:.currency(code: "USD")).keyboardType(.decimalPad)
            }
            .navigationTitle("Update Expense")
            .navigationBarTitleDisplayMode(.large)
            .toolbar(content: {
                ToolbarItemGroup(placement:.topBarLeading) {
                    Button("Done"){
                        dismiss()
                    }
                }
            })
        }
    }
}


#Preview {
    ContentView()
}


