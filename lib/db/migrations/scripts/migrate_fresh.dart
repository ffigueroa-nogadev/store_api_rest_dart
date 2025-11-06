import 'package:postgres/postgres.dart';
import 'package:store_api_rest/db/utils/migration_base.dart';
import 'package:store_api_rest/db/migrations/scripts/migrate_up.dart';

Future<void> migrateFresh(Connection conn, List<MigrationBase> migrations) async {
  print('⚠️ Dropping all tables...');

  await conn.execute('SET session_replication_role = replica;');
  final tables = await conn.execute("SELECT tablename FROM pg_tables WHERE schemaname = 'public';");

  for (final row in tables) {
    final tableName = row[0] as String;
    await conn.execute('DROP TABLE IF EXISTS "$tableName" CASCADE;');
    print('🧨 Table dropped: $tableName');
  }

  await conn.execute('SET session_replication_role = DEFAULT;');
  print('✅ All tables dropped.');

  print('🚀 Running fresh migrations...');
  await migrateUp(conn, migrations);
}
