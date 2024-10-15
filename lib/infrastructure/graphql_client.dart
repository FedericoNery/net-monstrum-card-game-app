import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class GraphQlClientManager {
  //TODO HACER ENV
  static final HttpLink httpLink = HttpLink('http://localhost:5000/graphql');
  late ValueNotifier<GraphQLClient> _client;

  GraphQlClientManager() {
    initClient();
  }

  void initClient() {
    _client = ValueNotifier(
      GraphQLClient(
        link: httpLink,
        cache: GraphQLCache(store: HiveStore()),
      ),
    );
  }

  ValueNotifier<GraphQLClient> get client {
    if (_client == null) {
      initClient();
    }
    return _client;
  }
}
