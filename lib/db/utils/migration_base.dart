import 'package:postgres/postgres.dart';

abstract class MigrationBase {
  final Connection conn;
  final String name;

  MigrationBase(this.conn, this.name);

  Future<void> up();

  Future<void> down() async {
    print('⚠️ Migration $name has no rollback defined.');
  }
}
