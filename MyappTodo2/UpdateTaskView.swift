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
    @Environment(\.presentationMode) var presentationMode
    @State private var task = ""
    @State private var content = ""
    @State private var deadline = Date()
    @State private var date = Date()
    private var todo: Todo
    
    init(todo: Todo) {
        self.todo = todo
        _task = State(initialValue: todo.task ?? "")
        _content = State(initialValue: todo.content ?? "")
        _deadline = State(initialValue: todo.deadline ?? Date())
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
            .onAppear {
                task = todo.task ?? ""
                deadline = todo.deadline ?? Date()
                content = todo.content ?? ""
            }
            .navigationTitle("タスク編集")
            .navigationBarItems(
                leading: Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text("キャンセル")
                },
                trailing: Button(action: {
                    saveTask()
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text("保存")
                }.disabled(task.isEmpty)
            )
        }
    }
    
    func saveTask() {
        todo.task = task
        todo.deadline = deadline
        todo.content = content
        try? context.save()
    }
}

struct UpdateTaskView_Previews: PreviewProvider {
    static var previews: some View {
        UpdateTaskView(todo: Todo())
    }
}
