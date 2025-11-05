import 'dart:io';

Future<void> main() async {
  final result = await Process.start(
    'watchexec',
    ['-r', '-w', 'bin', '-w', 'lib', 'dart run bin/server.dart'],
    mode: ProcessStartMode.inheritStdio,
  );

  await result.exitCode;
}
