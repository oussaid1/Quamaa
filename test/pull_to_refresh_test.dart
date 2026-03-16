import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:quamaa/src/features/shopping/domain/shopping_item.dart';
import 'package:quamaa/src/features/shopping/presentation/shopping_screen.dart';
import 'package:quamaa/src/features/shopping/providers/shopping_controllers.dart';

void main() {
  testWidgets('Shopping screen exposes pull-to-refresh', (tester) async {
    late _FakeShoppingController controller;
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          shoppingControllerProvider.overrideWith(() {
            controller = _FakeShoppingController();
            return controller;
          }),
        ],
        child: const MaterialApp(home: Scaffold(body: ShoppingListScreen())),
      ),
    );

    await tester.pumpAndSettle();
    expect(find.byType(RefreshIndicator), findsOneWidget);

    await tester.drag(find.text('حليب 2L'), const Offset(0, 300));
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    expect(controller.refreshCount, 1);
  });
}

class _FakeShoppingController extends ShoppingController {
  int refreshCount = 0;

  @override
  Future<List<ShoppingItem>> build() async {
    return _demoItems;
  }

  @override
  Future<void> refresh() async {
    refreshCount++;
    state = const AsyncValue.data(_demoItems);
  }
}

const _demoItems = [
  ShoppingItem(
    id: '1',
    name: 'حليب 2L',
    qty: 'x2',
    category: 'أطعمة',
    store: 'كارفور',
    expiry: 'ينتهي خلال 2 يوم',
    status: 'منخفض',
    autoAdd: true,
  ),
];
