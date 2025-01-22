import 'package:flutter/material.dart';
import 'package:notes/features/categories/models/category_model.dart';
import 'package:notes/features/todos/models/todo_model.dart';
import 'package:notes/features/todos/repositories/todo_repository.dart';

class TodosPage extends StatefulWidget {
  final Category category;

  const TodosPage({super.key, required this.category});

  @override
  State<TodosPage> createState() => _TodosPageState();
}

class _TodosPageState extends State<TodosPage> {
  final _todoRepository = TodoRepository();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  Future<void> _addTodo() async {
    final title = _titleController.text;
    final description = _descriptionController.text;

    if (title.isNotEmpty) {
      final todo = Todo(
        title: title,
        description: description,
        isCompleted: false,
        categoryId: widget.category.id!,
      );
      await _todoRepository.createTodo(todo);
      _titleController.clear();
      _descriptionController.clear();
      setState(() {});
    }
  }

  void _editTodo(BuildContext context, Todo todo) {
    final titleController = TextEditingController(text: todo.title);
    final descriptionController = TextEditingController(text: todo.description);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit Todo'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: descriptionController,
              decoration: InputDecoration(labelText: 'Description'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              if (titleController.text.isNotEmpty) {
                await _todoRepository.updateTodo(
                  Todo(
                    id: todo.id,
                    title: titleController.text,
                    description: descriptionController.text,
                    isCompleted: todo.isCompleted,
                    categoryId: todo.categoryId,
                  ),
                );
                Navigator.pop(context);
                setState(() {});
              }
            },
            child: Text('Save'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.category.name),
        centerTitle: true,
      ),
      body: FutureBuilder<List<Todo>>(
        future: _todoRepository.getTodosForCategory(widget.category.id!),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          final todos = snapshot.data!;
          return ListView.builder(
            itemCount: todos.length,
            itemBuilder: (context, index) {
              final todo = todos[index];
              return ListTile(
                title: Text(
                  todo.title,
                  style: TextStyle(
                    decoration: todo.isCompleted
                        ? TextDecoration.lineThrough
                        : TextDecoration.none,
                    color: todo.isCompleted ? Colors.grey : Colors.black,
                  ),
                ),
                subtitle: Text(
                  todo.description,
                  style: TextStyle(
                    decoration: todo.isCompleted
                        ? TextDecoration.lineThrough
                        : TextDecoration.none,
                    color: todo.isCompleted ? Colors.grey : Colors.black54,
                  ),
                ),
                onTap: () async {
                  await _todoRepository.updateTodo(
                    Todo(
                      id: todo.id,
                      title: todo.title,
                      description: todo.description,
                      isCompleted: !todo.isCompleted,
                      categoryId: todo.categoryId,
                    ),
                  );
                  setState(() {});
                },
                trailing: PopupMenuButton<String>(
                  icon: Icon(Icons.more_vert),
                  onSelected: (String value) async {
                    switch (value) {
                      case 'edit':
                        _editTodo(context, todo);
                        break;
                      case 'delete':
                        await _todoRepository.deleteTodo(todo.id!);
                        setState(() {});
                        break;
                    }
                  },
                  itemBuilder: (BuildContext context) => [
                    PopupMenuItem(
                      value: 'edit',
                      child: Row(
                        children: [
                          Icon(Icons.edit, color: Colors.blue),
                          SizedBox(width: 8),
                          Text('Edit'),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        children: [
                          Icon(Icons.delete, color: Colors.red),
                          SizedBox(width: 8),
                          Text('Delete'),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Add Todo'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: _titleController,
                    decoration: InputDecoration(labelText: 'Title'),
                  ),
                  TextField(
                    controller: _descriptionController,
                    decoration: InputDecoration(labelText: 'Description'),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    _addTodo();
                    Navigator.pop(context);
                  },
                  child: Text('Add'),
                ),
              ],
            ),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
