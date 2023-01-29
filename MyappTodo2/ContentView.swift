//
//  ContentView.swift
//  MyappTodo
//
//  Created by 009kin on 2023/01/28.
//

import SwiftUI
import CoreData

struct ContentView: View {
    ///被管理オブジェクトコンテキストの取得
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
                        Spacer()
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
    @State private var date = Date()
    
    var body: some View {
        Form {
            Section() {
                TextField("タスクを入力", text: $task)
            } header: {
                Text("タスク名")
            }
            DatePicker("日付を選択", selection: $date, displayedComponents: .date)
 
            Section() {
                TextField("タスク内容を入力", text: $content)
            } header: {
                Text("タスク内容")
            }
            
        }
        .navigationTitle("タスク追加")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("保存") {
                    /// タスク新規登録処理
                    let newTodo = Todo(context: context)
                    newTodo.timestamp = Date()
                    newTodo.checked = false
                    newTodo.task = task
                    newTodo.deadline = date
                    
                    try? context.save()
 
                    /// 現在のViewを閉じる
                    presentationMode.wrappedValue.dismiss()
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
