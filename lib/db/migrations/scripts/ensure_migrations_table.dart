import 'package:postgres/postgres.dart';

Future<void> ensureMigrationsTable(Connection conn) async {
  await conn.execute('''
    CREATE TABLE IF NOT EXISTS migrations (
      id SERIAL PRIMARY KEY,
      name TEXT UNIQUE NOT NULL,
      executed_at TIMESTAMP DEFAULT NOW()
    );
  ''');
}
