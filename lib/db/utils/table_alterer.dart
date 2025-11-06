import 'package:postgres/postgres.dart';
import 'package:store_api_rest/db/utils/db_models_factory.dart';

/// Utility class for altering existing tables
class TableAlterer {
  final Connection conn;
  final String tableName;

  TableAlterer({required DbModelsFactory model})
    : conn = model.conn,
      tableName = model.tableName;

  /// ✅ Add column
  Future<void> addColumn(DbField field) async {
    final sql = 'ALTER TABLE $tableName ADD COLUMN ${field.sqlDefinition};';
    await conn.execute(Sql.named(sql));
    print('🧱 Column "${field.name}" added to "$tableName".');
  }

  /// 🚮 Drop column
  Future<void> dropColumn(String columnName) async {
    final sql = 'ALTER TABLE $tableName DROP COLUMN IF EXISTS $columnName;';
    await conn.execute(Sql.named(sql));
    print('🧹 Column "$columnName" dropped from "$tableName".');
  }

  /// 🔄 Rename column
  Future<void> renameColumn(String oldName, String newName) async {
    final sql = 'ALTER TABLE $tableName RENAME COLUMN $oldName TO $newName;';
    await conn.execute(Sql.named(sql));
    print('✏️  Column "$oldName" renamed to "$newName" in "$tableName".');
  }

  /// ⚙️ Change data type
  Future<void> alterColumnType(
    String columnName,
    String newType, {
    String? using,
  }) async {
    var sql = 'ALTER TABLE $tableName ALTER COLUMN $columnName TYPE $newType';
    if (using != null) sql += ' USING $using';
    sql += ';';
    await conn.execute(Sql.named(sql));
    print('🔧 Column "$columnName" changed to type "$newType".');
  }

  /// 🌐 Add foreign key
  Future<void> addForeignKey({
    required String fromColumn,
    required String toTable,
    required String toColumn,
    String? constraintName,
    String? onDelete,
    String? onUpdate,
  }) async {
    final fkName = constraintName ?? 'fk_${tableName}_$fromColumn';
    final buffer = StringBuffer();
    buffer.write(
      'ALTER TABLE $tableName ADD CONSTRAINT $fkName FOREIGN KEY ($fromColumn) REFERENCES $toTable($toColumn)',
    );
    if (onDelete != null) buffer.write(' ON DELETE $onDelete');
    if (onUpdate != null) buffer.write(' ON UPDATE $onUpdate');
    buffer.write(';');

    await conn.execute(Sql.named(buffer.toString()));
    print('🔗 Foreign key "$fkName" added to "$tableName".');
  }

  /// ❌ Drop foreign key
  Future<void> dropForeignKey(String constraintName) async {
    final sql =
        'ALTER TABLE $tableName DROP CONSTRAINT IF EXISTS $constraintName;';
    await conn.execute(Sql.named(sql));
    print('⛓️  Foreign key "$constraintName" dropped from "$tableName".');
  }

  /// ➕ Add index
  Future<void> addIndex({
    required List<String> columns,
    bool unique = false,
    String? indexName,
  }) async {
    final idxName = indexName ?? 'idx_${tableName}_${columns.join('_')}';
    final cols = columns.join(', ');
    final uniqueSql = unique ? 'UNIQUE ' : '';
    final sql =
        'CREATE ${uniqueSql}INDEX IF NOT EXISTS $idxName ON $tableName($cols);';
    await conn.execute(Sql.named(sql));
    print('📈 Index "$idxName" created on "$tableName".');
  }

  /// ➖ Drop index
  Future<void> dropIndex(String indexName) async {
    final sql = 'DROP INDEX IF EXISTS $indexName;';
    await conn.execute(Sql.named(sql));
    print('📉 Index "$indexName" dropped.');
  }

  /// 🧰 Change default value
  Future<void> alterDefault(String columnName, dynamic defaultValue) async {
    final sql =
        'ALTER TABLE $tableName ALTER COLUMN $columnName SET DEFAULT $defaultValue;';
    await conn.execute(Sql.named(sql));
    print('⚙️  Default value of "$columnName" changed to "$defaultValue".');
  }

  /// 🧩 Remove default value
  Future<void> dropDefault(String columnName) async {
    final sql = 'ALTER TABLE $tableName ALTER COLUMN $columnName DROP DEFAULT;';
    await conn.execute(Sql.named(sql));
    print('⚙️  Default value of "$columnName" removed.');
  }

  /// ❗ Toggle NOT NULL
  Future<void> setNotNull(String columnName, {required bool required}) async {
    final action = required ? 'SET' : 'DROP';
    final sql =
        'ALTER TABLE $tableName ALTER COLUMN $columnName $action NOT NULL;';
    await conn.execute(Sql.named(sql));
    print(
      '🔒 Column "$columnName" is now ${required ? "NOT NULL" : "nullable"}.',
    );
  }
}
