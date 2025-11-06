import 'package:postgres/postgres.dart';
import 'dart:async';

/// DB field type
class DbField {
  final String name;
  final String type;
  final bool isPrimary;
  final bool isRequired;
  final bool isUnique;
  final dynamic defaultValue;

  const DbField({
    required this.name,
    required this.type,
    this.isPrimary = false,
    this.isRequired = false,
    this.isUnique = false,
    this.defaultValue,
  });

  String get sqlDefinition {
    final buffer = StringBuffer('$name $type');
    if (isPrimary) buffer.write(' PRIMARY KEY');
    if (isUnique) buffer.write(' UNIQUE');
    if (isRequired) buffer.write(' NOT NULL');
    if (defaultValue != null) buffer.write(' DEFAULT $defaultValue');
    return buffer.toString();
  }
}

/// Model Builder
abstract class DbModelsFactory {
  final String tableName;
  final List<DbField> fields;
  final Connection conn;

  DbModelsFactory({
    required this.tableName,
    required this.fields,
    required this.conn,
  });

  String get name => tableName;

  /// Create the table if it doesn't exist
  Future<void> createTable() async {
    final columnsSql = fields.map((f) => f.sqlDefinition).join(', ');
    final sql = 'CREATE TABLE IF NOT EXISTS $tableName ($columnsSql);';
    await conn.execute(Sql.named(sql));
    print('✅ Table "$tableName" verified/created.');
  }

  /// Insert a record
  Future<void> create(Map<String, dynamic> values) async {
    final keys = values.keys.join(', ');
    final placeholders = values.keys.map((k) => '@$k').join(', ');
    final sql = 'INSERT INTO $tableName ($keys) VALUES ($placeholders);';
    await conn.execute(Sql.named(sql), parameters: values);
  }

  /// Find a record by id
  Future<Map<String, dynamic>?> findById(dynamic id) async {
    final idField = fields.firstWhere((f) => f.isPrimary).name;
    final sql = 'SELECT * FROM $tableName WHERE $idField = @id LIMIT 1;';
    final result = await conn.execute(Sql.named(sql), parameters: {'id': id});
    return result.isEmpty ? null : result.first.toColumnMap();
  }

  /// Find multiple records
  Future<List<Map<String, dynamic>>> findMany() async {
    final sql = 'SELECT * FROM $tableName;';
    final result = await conn.execute(Sql.named(sql));
    return result.map((r) => r.toColumnMap()).toList();
  }

  /// Update a record by id
  Future<void> updateById(dynamic id, Map<String, dynamic> updates) async {
    final idField = fields.firstWhere((f) => f.isPrimary).name;
    final setSql = updates.keys.map((k) => '$k = @$k').join(', ');
    final sql = 'UPDATE $tableName SET $setSql WHERE $idField = @id;';
    await conn.execute(Sql.named(sql), parameters: {...updates, 'id': id});
  }

  /// Delete a record by id
  Future<void> deleteById(dynamic id) async {
    final idField = fields.firstWhere((f) => f.isPrimary).name;
    final sql = 'DELETE FROM $tableName WHERE $idField = @id;';
    await conn.execute(Sql.named(sql), parameters: {'id': id});
  }
}
