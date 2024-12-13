import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:net_monstrum_card_game/infrastructure/env_service.dart';

class GraphQlClientManager {
  static HttpLink httpLink = HttpLink(EnvService.apiUrl);
  ValueNotifier<GraphQLClient>? _client;

  static final GraphQlClientManager _instance =
      GraphQlClientManager._internal();

  GraphQlClientManager._internal();

  factory GraphQlClientManager() {
    return _instance;
  }

  void initClient() {
    _client = ValueNotifier(
      GraphQLClient(
        link: httpLink,
        cache: GraphQLCache(store: HiveStore()),
      ),
    );
  }

  void setAccessToken(String accessToken) {
    _client?.value = GraphQLClient(
      link: HttpLink(
        EnvService.apiUrl,
        defaultHeaders: {
          'Authorization': 'Bearer $accessToken',
        },
      ),
      cache: GraphQLCache(store: HiveStore()),
    );
  }

  ValueNotifier<GraphQLClient> get client {
    if (_client == null) {
      initClient();
    }
    return _client!;
  }
}
