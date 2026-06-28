import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_constants.dart';
import '../../core/providers/app_providers.dart';
import '../../shared/extensions/localized_text.dart';
import '../../shared/widgets/main_shell.dart';
import '../../shared/widgets/primary_button.dart';

// DISCO acronym → full name map
const _discoFullNames = {
  'LESCO': 'Lahore Electric Supply',
  'PESCO': 'Peshawar Electric Supply',
  'IESCO': 'Islamabad Electric Supply',
  'MEPCO': 'Multan Electric Power',
  'GEPCO': 'Gujranwala Electric Power',
  'FESCO': 'Faisalabad Electric Supply',
  'HESCO': 'Hyderabad Electric Supply',
  'SEPCO': 'Sukkur Electric Power',
  'QESCO': 'Quetta Electric Supply',
  'TESCO': 'Tribal Area Electric Supply',
  'HAZECO': 'Hazara Electric Supply',
  'K-Electric': 'Karachi Electric Supply',
};

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
        SnackBar(
          content: Text(l10n.selectDiscoAndCategory),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
      return;
    }
    await ref
        .read(billSessionProvider.notifier)
        .setSelection(disco: _selectedDisco!, category: _selectedCategory!);
    if (!mounted) return;
    context.push('/units');
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final session = ref.watch(billSessionProvider);

    if (!_restoredSession) {
      _selectedDisco = session.disco;
      _selectedCategory = session.category;
      _restoredSession = true;
    }

    final canProceed = _selectedDisco != null && _selectedCategory != null;

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
            // ── Header with Gradient Background ──────────────────
            SliverAppBar(
              pinned: true,
              expandedHeight: 180,
              backgroundColor: Colors.transparent,
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        scheme.primary,
                        scheme.primary.withValues(alpha: 0.7),
                        scheme.secondary.withValues(alpha: 0.3),
                      ],
                    ),
                  ),
                  child: SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(24, 20, 24, 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.2),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: Colors.white.withValues(alpha: 0.3),
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.bolt_rounded,
                                      size: 16,
                                      color: Colors.white,
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      'Pakistan',
                                      style: theme.textTheme.labelSmall
                                          ?.copyWith(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w700,
                                            letterSpacing: 0.5,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                              const Spacer(),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 5,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.update_rounded,
                                      size: 14,
                                      color: Colors.white70,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      'Updated Today',
                                      style: theme.textTheme.labelSmall
                                          ?.copyWith(
                                            color: Colors.white70,
                                            fontSize: 10,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text(
                            l10n.appName,
                            style: theme.textTheme.headlineMedium?.copyWith(
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                              fontSize: 28,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            context.isUrdu
                                ? l10n.selectProviderUrdu
                                : l10n.selectProvider,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: Colors.white.withValues(alpha: 0.85),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              toolbarHeight: 0,
            ),

            // ── Main Content with Rounded Top ──────────────────
            SliverToBoxAdapter(
              // In the SliverToBoxAdapter section, adjust the padding:
              child: Container(
                decoration: BoxDecoration(
                  color: theme.scaffoldBackgroundColor,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Selection Summary
                    if (_selectedDisco != null && _selectedCategory != null)
                      Padding(
                        padding: const EdgeInsets.fromLTRB(
                          20,
                          16,
                          20,
                          0,
                        ), // Reduced padding
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 10,
                          ), // Reduced padding
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                scheme.primary.withValues(alpha: 0.1),
                                scheme.primary.withValues(alpha: 0.05),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: scheme.primary.withValues(alpha: 0.2),
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.check_circle_rounded,
                                color: scheme.primary,
                                size: 18,
                              ), // Smaller icon
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '$_selectedDisco • ${_selectedCategory == ConsumerCategory.protected ? 'Protected' : 'Unprotected'}',
                                      style: theme.textTheme.bodyMedium
                                          ?.copyWith(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 13,
                                          ),
                                    ),
                                    Text(
                                      'Ready to calculate',
                                      style: theme.textTheme.bodySmall
                                          ?.copyWith(
                                            color: scheme.onSurface.withValues(
                                              alpha: 0.5,
                                            ),
                                            fontSize: 11,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: scheme.primary,
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Text(
                                  '✓',
                                  style: theme.textTheme.labelSmall?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    else
                      Padding(
                        padding: const EdgeInsets.fromLTRB(
                          20,
                          12,
                          20,
                          0,
                        ), // Reduced padding
                        child: Text(
                          'Select your provider to continue',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: scheme.onSurface.withValues(alpha: 0.4),
                            fontSize: 12,
                          ),
                        ),
                      ),

                    const SizedBox(height: 14), // Reduced spacing
                    // Section header
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                      ), // Reduced padding
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: scheme.primary.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Icon(
                              Icons.electrical_services_rounded,
                              size: 16,
                              color: scheme.primary,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Select DISCO',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                              fontSize: 15,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            '${AppConstants.discos.length} companies',
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: scheme.onSurface.withValues(alpha: 0.4),
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),

                    // DISCO Grid
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisSpacing: 8,
                              crossAxisSpacing: 8,
                              childAspectRatio: 2.4,
                            ),
                        itemCount: AppConstants.discos.length,
                        itemBuilder: (context, index) {
                          final disco = AppConstants.discos[index];
                          final selected = _selectedDisco == disco;
                          return _DiscoCard(
                            disco: disco,
                            fullName: _discoFullNames[disco] ?? disco,
                            selected: selected,
                            onTap: () => setState(() => _selectedDisco = disco),
                          );
                        },
                      ),
                    ),

                    const SizedBox(height: 16), // Reduced spacing
                    // Category section
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: scheme.primary.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Icon(
                              Icons.category_rounded,
                              size: 16,
                              color: scheme.primary,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Consumer Category',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                              fontSize: 15,
                            ),
                          ),
                          const Spacer(),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: scheme.primary.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              'Required',
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: scheme.primary,
                                fontSize: 8,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Category Cards
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        children: [
                          Expanded(
                            child: _CategoryCard(
                              label: 'Protected',
                              subtitle: '≤ 200 units',
                              description: 'Low consumption',
                              icon: Icons.shield_rounded,
                              selected:
                                  _selectedCategory ==
                                  ConsumerCategory.protected,
                              onTap: () => setState(
                                () => _selectedCategory =
                                    ConsumerCategory.protected,
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: _CategoryCard(
                              label: 'Unprotected',
                              subtitle: '> 200 units',
                              description: 'Standard consumption',
                              icon: Icons.electric_bolt_rounded,
                              selected:
                                  _selectedCategory ==
                                  ConsumerCategory.unprotected,
                              onTap: () => setState(
                                () => _selectedCategory =
                                    ConsumerCategory.unprotected,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Commercial Coming Soon
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              scheme.secondary.withValues(alpha: 0.08),
                              scheme.secondary.withValues(alpha: 0.02),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: scheme.secondary.withValues(alpha: 0.15),
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.storefront_rounded,
                              size: 18,
                              color: scheme.secondary.withValues(alpha: 0.5),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Commercial / Industrial',
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      fontWeight: FontWeight.w600,
                                      color: scheme.onSurface.withValues(
                                        alpha: 0.5,
                                      ),
                                      fontSize: 12,
                                    ),
                                  ),
                                  Text(
                                    'Coming in next update',
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: scheme.onSurface.withValues(
                                        alpha: 0.3,
                                      ),
                                      fontSize: 10,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    scheme.secondary,
                                    scheme.secondary.withValues(alpha: 0.7),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Text(
                                'Soon',
                                style: theme.textTheme.labelSmall?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 9,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 20), // Reduced spacing
                    // Calculate Button
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: canProceed ? _onNext : null,
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              vertical: 14,
                            ), // Reduced padding
                            backgroundColor: canProceed
                                ? scheme.primary
                                : scheme.onSurface.withValues(alpha: 0.12),
                            foregroundColor: canProceed
                                ? Colors.white
                                : scheme.onSurface.withValues(alpha: 0.3),
                            elevation: canProceed ? 4 : 0,
                            shadowColor: canProceed
                                ? scheme.primary.withValues(alpha: 0.3)
                                : Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Calculate Bill',
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 15,
                                  color: canProceed
                                      ? Colors.white
                                      : scheme.onSurface.withValues(alpha: 0.3),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Icon(
                                Icons.arrow_forward_rounded,
                                size: 20,
                                color: canProceed
                                    ? Colors.white
                                    : scheme.onSurface.withValues(alpha: 0.3),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
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
    required this.fullName,
    required this.selected,
    required this.onTap,
  });

  final String disco;
  final String fullName;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOutCubic,
      transform: Matrix4.identity()..scale(selected ? 1.02 : 1.0),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          splashColor: scheme.primary.withValues(alpha: 0.1),
          highlightColor: scheme.primary.withValues(alpha: 0.05),
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 12,
            ), // Reduced padding
            decoration: BoxDecoration(
              color: selected
                  ? scheme.primary.withValues(alpha: isDark ? 0.2 : 0.08)
                  : (isDark ? const Color(0xFF1A1D24) : Colors.white),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: selected
                    ? scheme.primary
                    : (isDark
                          ? Colors.white.withValues(alpha: 0.06)
                          : Colors.black.withValues(alpha: 0.06)),
                width: selected ? 2 : 1,
              ),
              boxShadow: selected
                  ? [
                      BoxShadow(
                        color: scheme.primary.withValues(alpha: 0.15),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ]
                  : isDark
                  ? [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ]
                  : [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
            ),
            child: Row(
              // Changed from Column to Row for better space usage
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  width: 32, // Smaller icon container
                  height: 32,
                  decoration: BoxDecoration(
                    color: selected
                        ? scheme.primary
                        : scheme.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.electrical_services_rounded,
                    color: selected ? Colors.white : scheme.primary,
                    size: 16, // Smaller icon
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        disco,
                        style: theme.textTheme.labelLarge?.copyWith(
                          // Smaller text
                          fontWeight: FontWeight.w800,
                          color: selected ? scheme.primary : null,
                          letterSpacing: -0.3,
                          fontSize: 13,
                        ),
                      ),
                      Text(
                        fullName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: scheme.onSurface.withValues(alpha: 0.4),
                          fontSize: 8, // Smaller text
                          letterSpacing: 0.2,
                        ),
                      ),
                    ],
                  ),
                ),
                if (selected)
                  Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: scheme.primary,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check_rounded,
                      color: Colors.white,
                      size: 12, // Smaller checkmark
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CategoryCard extends StatelessWidget {
  const _CategoryCard({
    required this.label,
    required this.subtitle,
    required this.description,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final String subtitle;
  final String description;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOutCubic,
      transform: Matrix4.identity()..scale(selected ? 1.02 : 1.0),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          splashColor: scheme.primary.withValues(alpha: 0.1),
          highlightColor: scheme.primary.withValues(alpha: 0.05),
          child: Container(
            padding: const EdgeInsets.all(14), // Reduced padding
            decoration: BoxDecoration(
              color: selected
                  ? scheme.primary.withValues(alpha: isDark ? 0.2 : 0.08)
                  : (isDark ? const Color(0xFF1A1D24) : Colors.white),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: selected
                    ? scheme.primary
                    : (isDark
                          ? Colors.white.withValues(alpha: 0.06)
                          : Colors.black.withValues(alpha: 0.06)),
                width: selected ? 2 : 1,
              ),
              boxShadow: selected
                  ? [
                      BoxShadow(
                        color: scheme.primary.withValues(alpha: 0.12),
                        blurRadius: 10,
                        offset: const Offset(0, 3),
                      ),
                    ]
                  : isDark
                  ? [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.2),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ]
                  : [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.04),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: selected
                            ? scheme.primary.withValues(alpha: 0.2)
                            : scheme.primary.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Icon(
                        icon,
                        color: selected ? scheme.primary : scheme.primary,
                        size: 16, // Smaller icon
                      ),
                    ),
                    const Spacer(),
                    if (selected)
                      Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: scheme.primary,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.check_rounded,
                          color: Colors.white,
                          size: 10, // Smaller checkmark
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 6), // Reduced spacing
                Text(
                  label,
                  style: theme.textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: selected ? scheme.primary : null,
                    fontSize: 13,
                  ),
                ),
                Text(
                  subtitle,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: scheme.onSurface.withValues(alpha: 0.5),
                    fontWeight: FontWeight.w600,
                    fontSize: 10,
                  ),
                ),
                const SizedBox(height: 1),
                Text(
                  description,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: scheme.onSurface.withValues(alpha: 0.3),
                    fontSize: 8,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
