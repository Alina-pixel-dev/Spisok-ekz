import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal(); // Создание единственного экземпляра класса (Singleton)
  static Database? _database; // Переменная для хранения экземпляра базы данных

  factory DatabaseHelper() => _instance; // Фабричный конструктор для возврата единственного экземпляра

  DatabaseHelper._internal(); // Приватный внутренний конструктор

  Future<Database> get database async {
    if (_database != null) return _database!; // Если база данных уже инициализирована, возвращаем её
    _database = await _initDatabase(); // Иначе инициализируем базу данных
    return _database!; // Возвращаем экземпляр базы данных
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'todo_database.db'); // Путь к файлу базы данных
    return await openDatabase(
      path, // Путь к файлу базы данных
      version: 1, // Версия базы данных
      onCreate: _onCreate, // Метод, вызываемый при создании базы данных
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    // Создание таблицы пользователей
    await db.execute('''
      CREATE TABLE users(
        id INTEGER PRIMARY KEY AUTOINCREMENT, // Уникальный идентификатор пользователя
        username TEXT UNIQUE, // Уникальное имя пользователя
        password TEXT // Пароль пользователя
      )
    ''');

    // Создание таблицы категорий
    await db.execute('''
      CREATE TABLE categories(
        id INTEGER PRIMARY KEY AUTOINCREMENT, // Уникальный идентификатор категории
        name TEXT, // Название категории
        user_id INTEGER, // Идентификатор пользователя, которому принадлежит категория
        FOREIGN KEY (user_id) REFERENCES users (id) // Внешний ключ для связи с таблицей пользователей
      )
    ''');

    // Создание таблицы задач
    await db.execute('''
      CREATE TABLE todos(
        id INTEGER PRIMARY KEY AUTOINCREMENT, // Уникальный идентификатор задачи
        title TEXT, // Название задачи
        description TEXT, // Описание задачи
        is_completed INTEGER, // Флаг завершённости задачи (0 или 1)
        category_id INTEGER, // Идентификатор категории, к которой относится задача
        FOREIGN KEY (category_id) REFERENCES categories (id) // Внешний ключ для связи с таблицей категорий
      )
    ''');
  }
}