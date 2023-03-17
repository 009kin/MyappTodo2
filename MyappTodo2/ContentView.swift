//
//  ContentView.swift
//  MyappTodo
//
//  Created by 009kin on 2023/01/28.
//

import SwiftUI
import CoreData

struct ContentView: View {
    ///CoreDataのcontextを取得
    @Environment(\.managedObjectContext) private var context

    ///データ取得処理
    @FetchRequest(
        entity: Todo.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Todo.timestamp, ascending: true)],
        predicate: nil)
    private var todos: FetchedResults<Todo>

    var body: some View {
        NavigationStack {
            List {
                ForEach(todos) { todo in
                    HStack {
                        Image(systemName: todo.checked ? "checkmark.circle.fill" : "circle")
                            .onTapGesture {
                                todo.checked.toggle()
                                try? context.save()
                            }
                        NavigationLink {
                            UpdateTaskView(todo: todo)
                        } label: {
                            Text("\(todo.task!)")
                        }
                    }
                }
                .onDelete(perform: deleteTodos)
            }
            .navigationBarTitle("ToDoリスト")
            
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    EditButton()
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: AddTodoView()) {
                    Image(systemName: "plus")
                    }
                }
            }
        }
    }

    ///タスクの削除
    func deleteTodos(offsets: IndexSet) {
        for index in offsets {
            context.delete(todos[index])
        }
        try? context.save()
    }
}

///タスク追加View
struct AddTodoView: View {
    @Environment(\.managedObjectContext) private var context
    @Environment(\.presentationMode) var presentationMode
    @State private var task = ""
    @State private var content = ""
    @State private var deadline = Date()
    
    var body: some View {
        Form {
            Section(header: Text("タスクを入力")) {
                TextField("タスクを入力", text: $task)
            }
            Section(header: Text("期限")) {
                DatePicker("日付を選択", selection: $deadline, displayedComponents: .date)
            }
            Section(header: Text("タスク内容")) {
                TextField("タスク内容を入力", text: $content)
            }
            
        }
        .navigationTitle("タスク追加")
        .navigationBarItems(
            leading: Button(action: {
                presentationMode.wrappedValue.dismiss()
            }) {
                Text("キャンセル")
            },
            trailing: Button(action: {
                addTask()
                presentationMode.wrappedValue.dismiss()
            }) {
                Text("保存")
            }.disabled(task.isEmpty)
        )
    }
    
    func addTask() {
        let todo = Todo(context: context)
        todo.task = task
        todo.deadline = deadline
        todo.content = content
        try? context.save()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
