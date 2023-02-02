import 'dart:io';

import 'package:args/args.dart';

void main(List<String> arguments) {
  exitCode = 0;

  final parser = ArgParser()
    ..addOption('path', abbr: 'p')
    ..addOption('name', abbr: 'n')
    ..addOption('layer', abbr: 'L', defaultsTo: '0');

  // Layers domain 0 / external 1 / infra 2

  final argResults = parser.parse(arguments);

  _generateFiles(argResults);
}

Future<void> _generateFiles(ArgResults args) async {
  if (args['path'] == null || args['path'].isEmpty) {
    stderr.writeln('É necessário passar o caminho da pasta / -p \$path');
    return;
  }

  if (args['name'] == null || args['name'].isEmpty) {
    stderr.writeln('É necessário passar o nome base / -n \$name');
    return;
  }

  int _layerNumber = int.tryParse(args['layer']) ?? -1;
  if (_layerNumber < 0 || _layerNumber > 2) {
    stderr.writeln('A layer inserida foi inválida / -L \$layer');
    stderr.writeln('0 - domain');
    stderr.writeln('1 - external');
    stderr.writeln('2 - infra');
    return;
  }

  String _path = args['path'];
  String _name = args['name'];
  String _layer = '';
  switch (_layerNumber) {
    case 0:
      _layer = 'domain';
      break;
    case 1:
      _layer = 'external';
      break;
    default:
      _layer = 'infra';
      break;
  }

  stdout.writeln(
    'Create files "${_name}_${_layer}_..." on $_path\n',
  );

  Directory _current = Directory.current;

  final _directories = _getDirectoriesNamesByLayer(_layerNumber);
  final _projectPath = '${_current.path}\\$_path';

  for (String directory in _directories) {
    String _subname = '';
    if (directory.endsWith('ies')) {
      _subname = directory.replaceFirst('ies', 'y');
    } else {
      if (directory == 'params') {
        _subname = directory;
      } else {
        _subname = directory.substring(0, directory.length - 1);
      }
    }

    final _completeName = _getCompleteName(_subname, _name);
    final _completePath = '$_projectPath\\$_layer\\$directory\\$_completeName.dart';

    final _file = File(_completePath);
    _file.createSync();
    stdout.writeln(_completePath);
  }

  stdout.writeln('\nCONCLUIDO COM SUCESSO');
}

String _getCompleteName(String subname, String name) {
  if (subname.contains('_')) {
    return subname.replaceFirst('_', '_${name}_');
  } else {
    return '${name}_$subname';
  }
}

List<String> _getDirectoriesNamesByLayer(int layer) {
  List<String> directories = [];

  switch (layer) {
    case 0:
      directories.add('i_repositories');
      directories.add('params');
      directories.add('usecases');
      break;
    case 1:
      directories.add('datasources');
      break;
    default:
      directories.add('i_datasources');
      directories.add('repositories');
      break;
  }

  return directories;
}
