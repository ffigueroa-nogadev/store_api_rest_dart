import 'package:postgres/postgres.dart';
import 'package:store_api_rest/db/utils/db_models_factory.dart';

class UserModel extends DbModelsFactory {
  UserModel({required Connection conn})
      : super(
          conn: conn,
          tableName: 'users',
          fields: const [
            DbField(name: 'id', type: 'SERIAL', isPrimary: true),
            DbField(name: 'name', type: 'TEXT', isRequired: true),
            DbField(name: 'email', type: 'TEXT', isRequired: true, isUnique: true),
            DbField(name: 'password', type: 'TEXT', isRequired: true),
            DbField(name: 'age', type: 'INT'),
          ],
        );
}
