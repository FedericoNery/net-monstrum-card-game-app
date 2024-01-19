import '../domain/data/user.dart';

class UsersService {
  List<User> _usersList = [];

  UsersService() {
    _usersList.add(User(1, 'Usuario1', 'Apellido1', 'user1', 'usuario1@email.com', 100, 'password1', [1, 2]));
    _usersList.add(User(2, 'Usuario2', 'Apellido2', 'user2', 'usuario2@email.com', 200, 'password2', [1, 2]));
    _usersList.add(User(3, 'Usuario3', 'Apellido3', 'user3', 'usuario3@email.com', 300, 'password3', [1, 2]));
  }

  List<User> getUsers() {
    return _usersList;
  }

  User getUserById(int id) {
    return _usersList.firstWhere((usuario) => usuario.id == id);
  }
}