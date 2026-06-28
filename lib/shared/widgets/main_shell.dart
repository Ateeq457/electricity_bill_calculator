import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../extensions/localized_text.dart';

class MainShell extends StatelessWidget {
  const MainShell({
    super.key,
    required this.currentIndex,
    required this.body,
    this.title,
    this.actions,
    this.showBackButton = false,
  });

  final int currentIndex;
  final Widget body;
  final String? title;
  final List<Widget>? actions;
  final bool showBackButton;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: title == null
          ? null
          : AppBar(
              leading: showBackButton
                  ? IconButton(
                      icon: const Icon(Icons.arrow_back_rounded),
                      onPressed: () => context.pop(),
                    )
                  : null,
              title: Text(title!, style: context.localizedStyle(null)),
              actions: actions,
            ),
      body: body,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: isDark
                  ? Colors.white.withValues(alpha: 0.07)
                  : Colors.black.withValues(alpha: 0.05),
            ),
          ),
        ),
        child: NavigationBar(
          selectedIndex: currentIndex,
          onDestinationSelected: (index) {
            switch (index) {
              case 0:
                context.go('/home');
              case 1:
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(l10n.historyComingSoon)),
                );
              case 2:
                context.go('/settings');
            }
          },
          destinations: [
            NavigationDestination(
              icon: const Icon(Icons.home_outlined),
              selectedIcon: const Icon(Icons.home_rounded),
              label: l10n.home,
            ),
            NavigationDestination(
              icon: const Icon(Icons.history_outlined),
              selectedIcon: const Icon(Icons.history_rounded),
              label: l10n.history,
            ),
            NavigationDestination(
              icon: const Icon(Icons.settings_outlined),
              selectedIcon: const Icon(Icons.settings_rounded),
              label: l10n.settings,
            ),
          ],
        ),
      ),
    );
  }
}
