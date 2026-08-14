import 'dart:convert';
import 'dart:io';

void main(List<String> arguments) {
  final errors = <String>[];
  final root = Directory.current;
  _validateRequiredFiles(root, errors);
  final english = _readArb(File('lib/l10n/app_en.arb'), errors);
  final hindi = _readArb(File('lib/l10n/app_hi.arb'), errors);
  _validateTranslations(english, hindi, errors);
  _validateBranding(errors);
  _validateVersion(errors);

  if (arguments.contains('--pseudo')) {
    final pseudo = <String, Object?>{'@@locale': 'en_XA'};
    for (final entry in english.entries) {
      if (entry.key.startsWith('@')) continue;
      pseudo[entry.key] = _pseudolocalize(entry.value as String);
    }
    stdout.writeln(const JsonEncoder.withIndent('  ').convert(pseudo));
  }

  if (errors.isNotEmpty) {
    for (final error in errors) {
      stderr.writeln('ERROR: $error');
    }
    exitCode = 1;
    return;
  }
  stdout.writeln(
    'CueVerse validation passed: ${english.keys.where(_isMessageKey).length} '
    'localized messages and all required repository files are present.',
  );
}

void _validateRequiredFiles(Directory root, List<String> errors) {
  const required = <String>[
    'LICENSE',
    'NOTICE',
    'README.md',
    'CHANGELOG.md',
    'ROADMAP.md',
    'CONTRIBUTING.md',
    'CODE_OF_CONDUCT.md',
    'SECURITY.md',
    'PRIVACY_POLICY.md',
    'TERMS_AND_CONDITIONS.md',
    'THIRD_PARTY_NOTICES.md',
    'what_changed.md',
    'PROJECT_STATUS.md',
    'assets/branding/bmc_support_card.svg',
    'assets/branding/bmc_support_card_dark.svg',
    'docs/architecture/technology_decision.md',
    'docs/development/continuation_ledger.md',
    'docs/development/phase_status.md',
    'docs/development/known_issues.md',
    'docs/development/test_matrix.md',
    'docs/monetization/fairness.md',
    'docs/privacy/data_map.md',
    'docs/release/release_checklist.md',
    'docs/security/threat_model.md',
    'docs/testing/test_matrix.md',
    'docs/ui_ux/accessibility.md',
    'docs/upcoming/feature_status.md',
    'docs/users_suggest/README.md',
    '.github/workflows/ci.yml',
    '.github/PULL_REQUEST_TEMPLATE.md',
  ];
  for (final relativePath in required) {
    if (!File('${root.path}/$relativePath').existsSync()) {
      errors.add('Missing required file: $relativePath');
    }
  }
}

Map<String, Object?> _readArb(File file, List<String> errors) {
  try {
    return (jsonDecode(file.readAsStringSync()) as Map<String, Object?>);
  } on Object catch (error) {
    errors.add('Invalid ARB ${file.path}: $error');
    return <String, Object?>{};
  }
}

void _validateTranslations(
  Map<String, Object?> english,
  Map<String, Object?> hindi,
  List<String> errors,
) {
  final englishKeys = english.keys.where(_isMessageKey).toSet();
  final hindiKeys = hindi.keys.where(_isMessageKey).toSet();
  for (final key in englishKeys.difference(hindiKeys)) {
    errors.add('Hindi translation missing key: $key');
  }
  for (final key in hindiKeys.difference(englishKeys)) {
    errors.add('Hindi catalog has unknown key: $key');
  }
  for (final key in englishKeys.intersection(hindiKeys)) {
    final source = english[key];
    final translation = hindi[key];
    if (source is! String || source.trim().isEmpty) {
      errors.add('English message $key is empty or not text.');
      continue;
    }
    if (translation is! String || translation.trim().isEmpty) {
      errors.add('Hindi message $key is empty or not text.');
      continue;
    }
    final sourcePlaceholders = _placeholders(source);
    final translatedPlaceholders = _placeholders(translation);
    if (!sourcePlaceholders.containsAll(translatedPlaceholders) ||
        !translatedPlaceholders.containsAll(sourcePlaceholders)) {
      errors.add(
        'Placeholder mismatch for $key: $sourcePlaceholders vs '
        '$translatedPlaceholders',
      );
    }
  }
}

bool _isMessageKey(String key) => !key.startsWith('@');

Set<String> _placeholders(String message) {
  return RegExp(
    r'(?<![=A-Za-z0-9])\{([A-Za-z][A-Za-z0-9_]*)',
  ).allMatches(message).map((match) => match.group(1)!).toSet();
}

void _validateBranding(List<String> errors) {
  for (final path in <String>[
    'assets/branding/bmc_support_card.svg',
    'assets/branding/bmc_support_card_dark.svg',
  ]) {
    final source = File(path).readAsStringSync();
    if (!source.contains('<title') ||
        !source.contains('<desc') ||
        !source.contains('role="img"')) {
      errors.add('$path lacks accessible SVG title/description/role metadata.');
    }
    if (!source.contains('buy') && !source.contains('Buy')) {
      errors.add('$path lacks the support action label.');
    }
  }
}

void _validateVersion(List<String> errors) {
  final pubspec = File('pubspec.yaml').readAsStringSync();
  final versionMatch = RegExp(
    r'^version:\s*(\S+)',
    multiLine: true,
  ).firstMatch(pubspec);
  final identity = File(
    'lib/core/constants/project_identity.dart',
  ).readAsStringSync();
  if (versionMatch == null) {
    errors.add('pubspec.yaml has no version.');
    return;
  }
  final version = versionMatch.group(1)!;
  if (!identity.contains("static const version = '$version';")) {
    errors.add(
      'ProjectIdentity.version does not match pubspec version $version.',
    );
  }
  if (!File('PROJECT_STATUS.md').readAsStringSync().contains('`$version`')) {
    errors.add('PROJECT_STATUS.md does not report version $version.');
  }
}

String _pseudolocalize(String input) {
  const accents = <String, String>{
    'a': 'å',
    'e': 'ë',
    'i': 'ï',
    'o': 'ø',
    'u': 'ü',
    'A': 'Å',
    'E': 'Ë',
    'I': 'Ï',
    'O': 'Ø',
    'U': 'Ü',
  };
  final buffer = StringBuffer('⟦');
  var braceDepth = 0;
  for (final rune in input.runes) {
    final character = String.fromCharCode(rune);
    if (character == '{') braceDepth++;
    if (braceDepth == 0) {
      buffer.write(accents[character] ?? character);
    } else {
      buffer.write(character);
    }
    if (character == '}') braceDepth--;
  }
  buffer.write(' ···⟧');
  return buffer.toString();
}
