import 'package:postgres/postgres.dart';
import 'package:store_api_rest/db/utils/migration_base.dart';

import '../models/user_model.dart';

class Migration0001CreateUsersTable extends MigrationBase {
  Migration0001CreateUsersTable(Connection conn)
    : super(conn, '0001_create_users_table');

  @override
  Future<void> up() async {
    final userModel = UserModel(conn: conn);
    await userModel.createTable();
  }

  @override
  Future<void> down() async {
    final userModel = UserModel(conn: conn);
    await conn.execute('DROP TABLE IF EXISTS ${userModel.name};'
    );
  }
}
