import 'package:flutter_test/flutter_test.dart';
import 'package:practica_09/main.dart';
import 'package:practica_09/screens/posts_screen.dart';

void main() {
  testWidgets('Carga inicial de la app muestra PostsScreen', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    expect(find.byType(PostsScreen), findsOneWidget);
  });
}