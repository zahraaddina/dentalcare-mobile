import 'package:flutter_test/flutter_test.dart';
import 'package:dentalcare_mobile/core/app_theme.dart';

void main() {
  test('Tema RSGM COMAL menggunakan Material 3', () {
    final theme = appTheme();
    expect(theme.useMaterial3, isTrue);
    expect(theme.colorScheme.primary, C.green);
  });
}
