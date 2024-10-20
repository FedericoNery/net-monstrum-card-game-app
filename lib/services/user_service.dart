import 'package:net_monstrum_card_game/graphql/queries.dart';

import '../domain/data/user.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class UsersService {
  List<User> _usersList = [];

  UsersService() {
    _usersList.add(User(1, 'Usuario1', 'Apellido1', 'user1',
        'usuario1@email.com', 100, 'password1', [1, 2]));
    _usersList.add(User(2, 'Usuario2', 'Apellido2', 'user2',
        'usuario2@email.com', 200, 'password2', [1, 2]));
    _usersList.add(User(3, 'Usuario3', 'Apellido3', 'user3',
        'usuario3@email.com', 300, 'password3', [1, 2]));
  }

  List<User> getUsers() {
    return _usersList;
  }

  User getUserById(int id) {
    return _usersList.firstWhere((usuario) => usuario.id == id);
  }

  Future<Map<String, dynamic>?> fetchUserWithGoogleToken(
      String token, String email) async {
    final HttpLink httpLink = HttpLink('http://localhost:5000/graphql');

    // Agregar el token a los headers
    /* final AuthLink authLink = AuthLink(
      getToken: () async => 'Bearer $token',
    );

    final Link link = authLink.concat(httpLink); */

    final GraphQLClient client =
        GraphQLClient(cache: GraphQLCache(), link: httpLink
            /* link: link, */
            );

    final QueryOptions options = QueryOptions(
        document: gql(getUserByIdQuery),
        variables: {"id": "670f2cd4798b3b58a3eb08e3"});
    try {
      final QueryResult result = await client.query(options);
      if (result.hasException) {
        print(result.exception.toString());
        return null;
      } else {
        final userData = result.data?['getUserById'];
        print('User data: $userData');
        return userData;
      }
    } catch (error) {
      return null;
    }
  }
}
