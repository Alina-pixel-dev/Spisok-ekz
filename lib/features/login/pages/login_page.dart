import 'package:flutter/material.dart';
import 'package:notes/core/repositories/user_repository.dart';
import 'package:notes/features/categories/pages/categories_page.dart';
import 'package:notes/features/registration/pages/category_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key}); // Конструктор страницы входа, принимающий необязательный ключ

  @override
  State<LoginPage> createState() => _LoginPageState(); // Создание состояния для страницы входа
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>(); // Ключ для управления состоянием формы
  final _usernameController = TextEditingController(); // Контроллер для поля ввода имени пользователя
  final _passwordController = TextEditingController(); // Контроллер для поля ввода пароля
  final _userRepository = UserRepository(); // Репозиторий для работы с данными пользователя

  bool _obscurePassword = true; // Флаг для скрытия/отображения пароля

  Future<void> _login(BuildContext context) async {
    if (_formKey.currentState!.validate()) { // Проверка валидности формы
      final user = await _userRepository.login( // Вызов метода входа в репозитории
        _usernameController.text, // Передача введенного имени пользователя
        _passwordController.text, // Передача введенного пароля
      );

      if (user != null) { // Если пользователь найден
        Navigator.pushReplacement( // Переход на страницу категорий
          context,
          MaterialPageRoute(
            builder: (context) => CategoriesPage(
              user: user, // Передача данных пользователя
            ),
          ),
        );
      } else { // Если пользователь не найден
        ScaffoldMessenger.of(context).showSnackBar( // Показ уведомления об ошибке
          SnackBar(content: Text('Пользователь не найден')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'), // Заголовок страницы
        centerTitle: true, // Выравнивание заголовка по центру
        leading: IconButton( // Кнопка с иконкой информации
          icon: Icon(Icons.info),
          onPressed: () => showDialog( // Показ диалога с информацией о проекте
            context: context,
            builder: (context) => AlertDialog(
              title: Text('О проекте'), // Заголовок диалога
              content: Text(
                'Проект был разработан студенткой 2 курса, cпециальности ПИ,\nРоманович Алиной Александровной', // Описание проекта
              ),
              actions: [
                TextButton(
                  onPressed: () => showLicensePage(context: context), // Кнопка для показа лицензии
                  child: Text('Лицензия'),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context), // Кнопка закрытия диалога
                  child: Text('Ок'),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0), // Отступы вокруг содержимого
        child: Form(
          key: _formKey, // Привязка ключа формы
          child: Column(
            children: [
              TextFormField(
                controller: _usernameController, // Привязка контроллера к полю ввода
                decoration: InputDecoration(
                  labelText: 'Username', // Метка для поля ввода
                  prefixIcon: Icon(Icons.person), // Иконка перед полем ввода
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12), // Скругление углов
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade300), // Цвет границы по умолчанию
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.blue, width: 2), // Цвет границы при фокусе
                  ),
                  filled: true, // Заливка фона
                  fillColor: Colors.grey.shade100, // Цвет фона
                ),
                validator: (value) { // Валидация поля ввода
                  if (value?.isEmpty ?? true) {
                    return 'Please enter username'; // Сообщение об ошибке, если поле пустое
                  }
                  return null;
                },
              ),
              SizedBox(height: 16), // Отступ между полями ввода
              TextFormField(
                controller: _passwordController, // Привязка контроллера к полю ввода пароля
                decoration: InputDecoration(
                  labelText: 'Password', // Метка для поля ввода пароля
                  prefixIcon: Icon(Icons.lock), // Иконка перед полем ввода
                  suffixIcon: IconButton( // Кнопка для переключения видимости пароля
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword; // Переключение состояния видимости пароля
                      });
                    },
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12), // Скругление углов
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade300), // Цвет границы по умолчанию
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.blue, width: 2), // Цвет границы при фокусе
                  ),
                  filled: true, // Заливка фона
                  fillColor: Colors.grey.shade100, // Цвет фона
                ),
                obscureText: _obscurePassword, // Скрытие текста пароля
                validator: (value) { // Валидация поля ввода пароля
                  if (value?.isEmpty ?? true) {
                    return 'Please enter password'; // Сообщение об ошибке, если поле пустое
                  }
                  return null;
                },
              ),
              SizedBox(height: 16), // Отступ между полями ввода и кнопкой
              ElevatedButton(
                onPressed: () async => await _login(context), // Обработчик нажатия на кнопку входа
                child: Text('Login'), // Текст на кнопке
              ),
              TextButton(
                onPressed: () {
                  Navigator.push( // Переход на страницу регистрации
                      context,
                      MaterialPageRoute(
                          builder: (context) => RegistrationPage()));
                },
                child: Text('Register'), // Текст на кнопке регистрации
              ),
            ],
          ),
        ),
      ),
    );
  }
}