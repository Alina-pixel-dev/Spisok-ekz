import 'package:notes/core/helpers/database_helper.dart';
import 'package:notes/core/models/user_model.dart';

class UserRepository {
  final DatabaseHelper _databaseHelper = DatabaseHelper(); // Инициализация помощника для работы с базой данных

  Future<User?> login(String username, String password) async {
    final db = await _databaseHelper.database; // Получение экземпляра базы данных

    final List<Map<String, dynamic>> maps = await db.query(
      'users', // Таблица, из которой запрашиваются данные
      where: 'username = ? AND password = ?', // Условие для поиска пользователя
      whereArgs: [username, password], // Аргументы для условия (имя пользователя и пароль)
    );

    if (maps.isEmpty) return null; // Если пользователь не найден, возвращаем null
    return User.fromMap(maps.first); // Преобразование данных из Map в объект User
  }

  Future<bool> register(User user) async {
    try {
      final db = await _databaseHelper.database; // Получение экземпляра базы данных
      await db.insert('users', user.toMap()); // Вставка данных пользователя в таблицу
      return true; // Возвращаем true, если регистрация прошла успешно
    } catch (e) {
      return false; // Возвращаем false, если произошла ошибка
    }
  }
}