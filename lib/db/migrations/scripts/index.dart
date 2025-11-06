import 'package:store_api_rest/db.dart';
import 'package:store_api_rest/db/migrations/001_create_users_table.dart';
import 'package:store_api_rest/db/migrations/scripts/migrate_up.dart';
import 'package:store_api_rest/db/migrations/scripts/migrate_down.dart';
import 'package:store_api_rest/db/migrations/scripts/migrate_fresh.dart';

Future<void> main(List<String> args) async {
  final command = args.isNotEmpty ? args.first : 'up';
  final conn = await getConnection();

  final migrations = [
    Migration0001CreateUsersTable(conn),
  ];

  switch (command) {
    case 'up':
      await migrateUp(conn, migrations);
      break;
    case 'down':
      await migrateDown(conn, migrations);
      break;
    case 'fresh':
      await migrateFresh(conn, migrations);
      break;
    default:
      print('⚠️ Unrecognized command. Use: up | down | fresh');
  }

  await conn.close();
}
