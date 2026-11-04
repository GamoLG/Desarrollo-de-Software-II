import 'package:flutter_test/flutter_test.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:practica_09/services/graphql_service.dart';

void main() {
  test('Consulta GraphQL retorna datos tipados válidos', () async {
    final client = GraphQLConfig.initializeClient().value;
    final QueryResult result = await client.query(
      QueryOptions(
        document: gql(getCountryQuery),
        fetchPolicy: FetchPolicy.networkOnly,
      ),
    );

    expect(result.hasException, false, reason: result.exception.toString());
    expect(result.data, isNotNull);
    expect(result.data?['country']['name'], 'Peru');
    expect(result.data?['country']['capital'], 'Lima');
  });
}