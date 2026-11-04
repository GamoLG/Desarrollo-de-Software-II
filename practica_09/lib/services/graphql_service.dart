import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class GraphQLConfig {
  // Endpoint público y estable sin autenticación
  static final HttpLink httpLink = HttpLink(
    'https://countries.trevorblades.com/',
  );

  static ValueNotifier<GraphQLClient> initializeClient() {
    return ValueNotifier(
      GraphQLClient(
        link: httpLink,
        cache: GraphQLCache(store: InMemoryStore()),
      ),
    );
  }
}

// Query tipada que solicita datos puntuales de Perú (evita over-fetching)
const String getCountryQuery = """
  query GetCountry {
    country(code: "PE") {
      name
      native
      capital
      currency
      emoji
    }
  }
""";