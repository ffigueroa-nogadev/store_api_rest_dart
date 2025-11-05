import 'package:postgres/postgres.dart';
import 'package:dotenv/dotenv.dart';

final env = DotEnv()..load();

Future<Connection> getConnection() async {

  try {
    final conn = await Connection.open(
      Endpoint(
        host: env['DATABASE_HOST'] ?? 'localhost',
        port: int.parse(env['DATABASE_PORT'] ?? '5432'),
        database: env['DATABASE_NAME'] ?? 'storedb',
        username: env['DATABASE_USER'] ?? 'postgres',
        password: env['DATABASE_PASSWORD'] ?? 'postgres',
      ),
      settings: ConnectionSettings(sslMode: SslMode.disable),
    );
    return conn;
  } catch (e, st) {
    print('❌ Error al conectar a la base de datos: $e');
    print(st);
    rethrow;
  }
}
