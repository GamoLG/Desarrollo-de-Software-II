import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import '../services/graphql_service.dart';

class GraphQLScreen extends StatelessWidget {
  const GraphQLScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('GraphQL Demo (Countries API)'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Query(
        options: QueryOptions(
          document: gql(getCountryQuery),
          pollInterval: const Duration(seconds: 30),
        ),
        builder: (QueryResult result, {VoidCallback? refetch, FetchMore? fetchMore}) {
          if (result.hasException) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text('Error GraphQL: ${result.exception.toString()}'),
              ),
            );
          }

          if (result.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          final country = result.data?['country'];
          if (country == null) {
            return const Center(child: Text('No se encontraron datos'));
          }

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          country['emoji'] ?? '🇵🇪',
                          style: const TextStyle(fontSize: 32),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          country['name'] ?? 'N/A',
                          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const Divider(height: 24),
                    Text('Nombre nativo: ${country['native'] ?? 'N/A'}'),
                    const SizedBox(height: 8),
                    Text('Capital: ${country['capital'] ?? 'N/A'}'),
                    const SizedBox(height: 8),
                    Text('Moneda: ${country['currency'] ?? 'N/A'}'),
                    const SizedBox(height: 20),
                    Align(
                      alignment: Alignment.centerRight,
                      child: OutlinedButton.icon(
                        onPressed: refetch,
                        icon: const Icon(Icons.refresh),
                        label: const Text('Refetch Query'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}