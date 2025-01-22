import 'package:flutter/material.dart';
import 'package:notes/core/models/user_model.dart';
import 'package:notes/features/categories/models/category_model.dart';
import 'package:notes/features/categories/repositories/category_repository.dart';
import 'package:notes/features/login/pages/login_page.dart';
import 'package:notes/features/todos/pages/todos_page.dart';

class CategoriesPage extends StatefulWidget {
  final User user;

  const CategoriesPage({super.key, required this.user});

  @override
  State<CategoriesPage> createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  final _categoryRepository = CategoryRepository();
  final _nameController = TextEditingController();

  Future<void> _addCategory() async {
    final name = _nameController.text;
    if (name.isNotEmpty) {
      final category = Category(
        name: name,
        userId: widget.user.id!,
      );
      await _categoryRepository.createCategory(category);
      _nameController.clear();
      setState(() {});
    }
  }

  void _editCategory(BuildContext context, Category category) {
    final editController = TextEditingController(text: category.name);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit Category'),
        content: TextField(
          controller: editController,
          decoration: InputDecoration(labelText: 'Category Name'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              if (editController.text.isNotEmpty) {
                await _categoryRepository.updateCategory(Category(
                  id: category.id,
                  name: editController.text,
                  userId: category.userId,
                ));
                setState(() {});
                Navigator.pop(context);
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
        title: Text('Categories'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => LoginPage(),
                ),
              );
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Category>>(
        future: _categoryRepository.getCategoriesForUser(widget.user.id!),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          final categories = snapshot.data!;
          return ListView.builder(
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];
              return ListTile(
                title: Text(category.name),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TodosPage(category: category),
                    ),
                  );
                },
                trailing: PopupMenuButton<String>(
                  icon: Icon(Icons.more_vert),
                  onSelected: (String value) async {
                    switch (value) {
                      case 'edit':
                        _editCategory(context, category);
                        break;
                      case 'delete':
                        await _categoryRepository.deleteCategory(category.id!);
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
              title: Text('Add Category'),
              content: TextField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Category Name'),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    _addCategory();
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
