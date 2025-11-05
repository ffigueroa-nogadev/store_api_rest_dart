import 'dart:io';
import 'package:dotenv/dotenv.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as io;
import 'package:shelf_router/shelf_router.dart';
import 'package:store_api_rest/db.dart';

void main() async {
  final env = DotEnv()..load();
  final port = int.parse(env['PORT'] ?? '8080');

  final router = Router();

  router.get('/', (Request req) {
    return Response.ok('API Dart corriendo 🚀');
  });

  router.get('/test-db-connection', (Request req) async {
  try {
    final conn = await getConnection();
    
    final result = await conn.execute('SELECT NOW()');
    await conn.close();

    return Response.ok('✅ Conexión exitosa a la base de datos. Hora del servidor: ${result.first.first}', headers: {'content-type': 'text/plain; charset=utf-8'} );
  } catch (e) {
    return Response.internalServerError(body: '❌ Error al conectar a la base: $e');
  }
});


  final handler = Pipeline()
      .addMiddleware(logRequests())
      .addHandler(router);

  final server = await io.serve(handler, InternetAddress.anyIPv6, port);
  print('✅ Servidor escuchando en http://${server.address.host}:${server.port}');
}
