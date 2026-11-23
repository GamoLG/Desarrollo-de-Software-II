import 'package:flutter/material.dart';

class RecommendationCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String body;
  final Color accentColor;

  const RecommendationCard({
    super.key,
    required this.icon,
    required this.title,
    required this.body,
    this.accentColor = const Color(0xFFE65100),
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: accentColor.withValues(alpha: 0.14),
          child: Icon(icon, color: accentColor),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(body),
        ),
      ),
    );
  }
}