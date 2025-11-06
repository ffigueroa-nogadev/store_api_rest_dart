import 'package:postgres/postgres.dart';
import 'package:store_api_rest/db/utils/migration_base.dart';
import 'package:store_api_rest/db/migrations/scripts/ensure_migrations_table.dart';

Future<void> migrateUp(Connection conn, List<MigrationBase> migrations) async {
  await ensureMigrationsTable(conn);

  final result = await conn.execute('SELECT name FROM migrations;');
  final executed = result.map((r) => r[0] as String).toSet();

  for (final migration in migrations) {
    if (executed.contains(migration.name)) {
      print('⏩ Migration ${migration.name} already executed, skipping.');
      continue;
    }

    print('🚀 Running migration: ${migration.name}');
    await migration.up();

    await conn.execute(
      Sql.named('INSERT INTO migrations (name) VALUES (@name)'),
      parameters: {'name': migration.name},
    );

    print('✅ Migration ${migration.name} completed.');
  }

  print('🏁 All migrations are up to date.');
}
