import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_constants.dart';
import '../../core/providers/app_providers.dart';
import '../../core/theme/app_theme.dart';
import '../../shared/extensions/localized_text.dart';
import '../../shared/widgets/main_shell.dart';
import '../../shared/widgets/primary_button.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  String? _selectedDisco;
  ConsumerCategory? _selectedCategory;
  var _restoredSession = false;

  Future<void> _onNext() async {
    final l10n = context.l10n;
    if (_selectedDisco == null || _selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.selectDiscoAndCategory)),
      );
      return;
    }

    await ref.read(billSessionProvider.notifier).setSelection(
          disco: _selectedDisco!,
          category: _selectedCategory!,
        );
    if (!mounted) return;
    context.push('/units');
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final session = ref.watch(billSessionProvider);

    if (!_restoredSession) {
      _selectedDisco = session.disco;
      _selectedCategory = session.category;
      _restoredSession = true;
    }

    final canProceed =
        _selectedDisco != null && _selectedCategory != null;

    return MainShell(
      currentIndex: 0,
      body: RefreshIndicator(
        onRefresh: () async {
          await ref.read(tariffRepositoryProvider).refreshTariffs();
          ref.invalidate(tariffsProvider);
        },
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
                decoration: AppTheme.heroGradient(context),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.appName,
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      context.isUrdu
                          ? l10n.selectProviderUrdu
                          : l10n.selectProvider,
                      style: context.localizedStyle(
                        theme.textTheme.titleMedium?.copyWith(
                          color: theme.colorScheme.onSurface
                              .withValues(alpha: 0.75),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 1.55,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final disco = AppConstants.discos[index];
                    final selected = _selectedDisco == disco;
                    return _DiscoCard(
                      disco: disco,
                      selected: selected,
                      onTap: () => setState(() => _selectedDisco = disco),
                    );
                  },
                  childCount: AppConstants.discos.length,
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
                child: Text(
                  l10n.consumerCategory,
                  style: context.localizedStyle(theme.textTheme.titleMedium),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: SegmentedButton<ConsumerCategory?>(
                  segments: [
                    ButtonSegment(
                      value: ConsumerCategory.protected,
                      label: Text(l10n.protected),
                    ),
                    ButtonSegment(
                      value: ConsumerCategory.unprotected,
                      label: Text(l10n.unprotected),
                    ),
                  ],
                  selected: {_selectedCategory},
                  onSelectionChanged: (value) {
                    setState(() => _selectedCategory = value.first);
                  },
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 12, 24, 0),
                child: Opacity(
                  opacity: 0.5,
                  child: SegmentedButton<ConsumerCategory?>(
                    segments: [
                      ButtonSegment(
                        value: null,
                        enabled: false,
                        label: Text(l10n.commercialComingSoon),
                      ),
                    ],
                    selected: const {},
                    onSelectionChanged: (_) {},
                  ),
                ),
              ),
            ),
            SliverFillRemaining(
              hasScrollBody: false,
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    PrimaryButton(
                      label: l10n.next,
                      enabled: canProceed,
                      onPressed: _onNext,
                      icon: Icons.arrow_forward_rounded,
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DiscoCard extends StatelessWidget {
  const _DiscoCard({
    required this.disco,
    required this.selected,
    required this.onTap,
  });

  final String disco;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          decoration: BoxDecoration(
            color: selected
                ? scheme.primary.withValues(alpha: 0.12)
                : theme.cardTheme.color,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: selected
                  ? scheme.primary
                  : theme.dividerTheme.color ?? Colors.grey.shade300,
              width: selected ? 2 : 1,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.electrical_services_rounded,
                color: selected ? scheme.primary : scheme.onSurfaceVariant,
                size: 28,
              ),
              const SizedBox(height: 8),
              Text(
                disco,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: selected ? scheme.primary : null,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
