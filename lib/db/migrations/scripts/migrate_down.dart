import 'package:postgres/postgres.dart';
import 'package:store_api_rest/db/utils/migration_base.dart';
import 'package:store_api_rest/db/migrations/scripts/ensure_migrations_table.dart';

Future<void> migrateDown(Connection conn, List<MigrationBase> migrations) async {
  await ensureMigrationsTable(conn);

  final result = await conn.execute('SELECT name FROM migrations ORDER BY id DESC;');
  final executed = result.map((r) => r[0] as String).toList();

  final migrationsByName = {for (var m in migrations) m.name: m};

  for (final name in executed) {
    final migration = migrationsByName[name];
    if (migration == null) continue;

    print('⏬ Reverting migration: ${migration.name}');
    await migration.down();

    await conn.execute(
      Sql.named('DELETE FROM migrations WHERE name = @name'),
      parameters: {'name': migration.name},
    );
  }

  print('🏁 All migrations reverted.');
}
