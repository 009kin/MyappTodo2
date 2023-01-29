//
//  UpdateTaskView.swift
//  MyappTodo2
//
//  Created by 009kin on 2023/01/28.
//

import SwiftUI
import CoreData

struct UpdateTaskView: View {
    
    @Environment(\.managedObjectContext) private var context
    @State private var task = ""
    @State private var content = ""
    @State private var deadline = Date()
    @State private var date = Date()
    private var todo: Todo
    
    init(todo: Todo) {
        self.todo = todo
        self.task = todo.task ?? ""
        self.content = todo.content ?? ""
        self.deadline = todo.deadline ?? Date()
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section() {
                    TextField(todo.task!, text: $task)
                } header: {
                    Text("タスク名")
                }
                DatePicker("日付を選択", selection: $date, displayedComponents: .date)
                
                Section() {
                    TextField(todo.content!, text: $content)
                } header: {
                    Text("タスク内容")
                }
                
            }
            .navigationTitle("タスク編集")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("保存") {
                        /// タスク編集処理
                        todo.task = task
                        todo.content = content
                        todo.timestamp = Date()
                        todo.checked = false
                        todo.deadline = date
                        
                        try? context.save()
                    }
                }
            }
        }
    }
}

struct UpdateTaskView_Previews: PreviewProvider {
    static var previews: some View {
        UpdateTaskView(todo: Todo())
    }
}
