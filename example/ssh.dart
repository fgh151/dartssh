// Copyright 2019 dartssh developers
// Use of this source code is governed by a MIT-style license that can be found in the LICENSE file.

import 'dart:convert';
import 'dart:io';

import 'package:args/args.dart';

import 'package:dartssh/client.dart';

void main(List<String> arguments) async {
  exitCode = 0;

  final argParser = ArgParser()
    ..addOption('login', abbr: 'l')
    ..addOption('port', abbr: 'p');
  final ArgResults argResults = argParser.parse(arguments);

  if (argResults.rest.length != 1) {
    print('ssh: <host> [args]');
    print(argParser.usage);
    exitCode = 1;
    return;
  }

  final String host = argResults.rest.first;
  final String port = argResults['port'];

  try {
    final SSHClient ssh = SSHClient(
        hostport: 'ssh://' + host + (port != null ? ':$port' : ''),
        print: print,
        debugPrint: print,
        tracePrint: print);

    stdin.lineMode = false;
    await for (String input in stdin.transform(utf8.decoder)) {
      print('read $input');
    }

  } catch (error, stacktrace) {
    print('ssh: exception: $error: $stacktrace');
    exitCode = -1;
  }
}
