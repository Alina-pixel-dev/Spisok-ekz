import 'package:notes/core/helpers/database_helper.dart';
import 'package:notes/features/categories/models/category_model.dart';

class CategoryRepository {
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  Future<List<Category>> getCategoriesForUser(int userId) async {
    final db = await _databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'categories',
      where: 'user_id = ?',
      whereArgs: [userId],
    );

    return List.generate(maps.length, (i) => Category.fromMap(maps[i]));
  }

  Future<Category> createCategory(Category category) async {
    final db = await _databaseHelper.database;
    final id = await db.insert('categories', category.toMap());
    return Category(
      id: id,
      name: category.name,
      userId: category.userId,
    );
  }

  Future<void> deleteCategory(int id) async {
    final db = await _databaseHelper.database;
    await db.delete('categories', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> updateCategory(Category category) async {
    final db = await _databaseHelper.database;
    await db.update(
      'categories',
      category.toMap(),
      where: 'id = ?',
      whereArgs: [category.id],
    );
  }
}