import 'package:notes/core/helpers/database_helper.dart';
import 'package:notes/features/todos/models/todo_model.dart';

class TodoRepository {
  final DatabaseHelper _databaseHelper = DatabaseHelper(); // Инициализация помощника для работы с базой данных

  Future<List<Todo>> getTodosForCategory(int categoryId) async {
    final db = await _databaseHelper.database; // Получение экземпляра базы данных
    final List<Map<String, dynamic>> maps = await db.query(
      'todos', // Таблица, из которой запрашиваются данные
      where: 'category_id = ?', // Условие для выборки задач по ID категории
      whereArgs: [categoryId], // Аргумент для условия (ID категории)
    );

    return List.generate(maps.length, (i) => Todo.fromMap(maps[i])); // Преобразование списка Map в список объектов Todo
  }

  Future<Todo> createTodo(Todo todo) async {
    final db = await _databaseHelper.database; // Получение экземпляра базы данных
    final id = await db.insert('todos', todo.toMap()); // Вставка новой задачи в таблицу и получение её ID
    return Todo(
      id: id, // Возвращаем новый объект Todo с присвоенным ID
      title: todo.title,
      description: todo.description,
      isCompleted: todo.isCompleted,
      categoryId: todo.categoryId,
    );
  }

  Future<void> updateTodo(Todo todo) async {
    final db = await _databaseHelper.database; // Получение экземпляра базы данных
    await db.update(
      'todos', // Таблица, в которой обновляются данные
      todo.toMap(), // Данные для обновления
      where: 'id = ?', // Условие для обновления задачи по её ID
      whereArgs: [todo.id], // Аргумент для условия (ID задачи)
    );
  }

  Future<void> deleteTodo(int id) async {
    final db = await _databaseHelper.database; // Получение экземпляра базы данных
    await db.delete(
      'todos', // Таблица, из которой удаляются данные
      where: 'id = ?', // Условие для удаления задачи по её ID
      whereArgs: [id], // Аргумент для условия (ID задачи)
    );
  }
}