import 'package:net_monstrum_card_game/graphql/mutations.dart';
import 'package:net_monstrum_card_game/graphql/queries.dart';

import '../domain/data/user.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class UsersService {
  List<User> _usersList = [];
  late GraphQLClient client;

  UsersService() {
    _usersList.add(User(1, 'Usuario1', 'Apellido1', 'user1',
        'usuario1@email.com', 100, 'password1', [1, 2]));
    _usersList.add(User(2, 'Usuario2', 'Apellido2', 'user2',
        'usuario2@email.com', 200, 'password2', [1, 2]));
    _usersList.add(User(3, 'Usuario3', 'Apellido3', 'user3',
        'usuario3@email.com', 300, 'password3', [1, 2]));

    final HttpLink httpLink = HttpLink('http://localhost:5000/graphql');
    client = GraphQLClient(cache: GraphQLCache(), link: httpLink);
  }

  List<User> getUsers() {
    return _usersList;
  }

  User getUserById(int id) {
    return _usersList.firstWhere((usuario) => usuario.id == id);
  }

  Future<Object?> createUserWithEmail(
      String email, String username, String avatarUrlSelected) async {
    final MutationOptions options = MutationOptions(
        document: gql(createUserWithEmailAndUsername),
        variables: {
          "email": email,
          "username": username,
          "avatarUrl": avatarUrlSelected
        });
    final QueryResult result = await client.mutate(options);
    if (result.hasException) {
      print(result.exception.toString());
      return null;
    }

    final data = result.data?['createUserByEmail'];

    if (data["userAlreadyExist"]) {
      throw Exception("El usuario ya existe con ese email o username");
    }

    if (data["hasError"]) {
      throw Exception("Ocurrió un error");
    }

    print('data: $data');
    return data["result"];
  }

  Future<String?> fetchUserWithEmail(String email) async {
    // Agregar el token a los headers
    /* final AuthLink authLink = AuthLink(
      getToken: () async => 'Bearer $token',
    );

    final Link link = authLink.concat(httpLink); */

    final MutationOptions options = MutationOptions(
        document: gql(signInWithEmail), variables: {"email": email});
    final QueryResult result = await client.mutate(options);

    if (result.hasException) {
      throw Exception(result.exception.toString());
    }

    final userData = result.data?['signInWithEmail'];

    if (userData == null) {
      throw Exception("Error usuario no encontrado");
    }

    print('User data: $userData');
    return userData['access_token'];
  }

  Future<int> getCoinsByEmail(String email) async {
    final MutationOptions options = MutationOptions(
        document: gql(getCoinsByEmailQuery), variables: {"email": email});
    final QueryResult result = await client.mutate(options);

    if (result.hasException) {
      throw Exception(result.exception.toString());
    }

    final coinsData = result.data?['getCoinsByEmail'];

    if (coinsData == null) {
      throw Exception("Error usuario no encontrado");
    }

    return coinsData['coins'];
  }
}
