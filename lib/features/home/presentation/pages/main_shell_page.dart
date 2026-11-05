import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../../../app/localization/l10n.dart';
import '../../../../app/router/app_router.dart';

/// Bottom navigation: Home, Search, Publish, My trips, Profile.
@RoutePage()
class MainShellPage extends StatelessWidget {
  const MainShellPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return AutoTabsRouter(
      routes: const [HomeRoute(), SearchRoute(), PublishTripRoute(), MyTripsRoute(), ProfileRoute()],
      builder: (context, child) {
        final tabs = AutoTabsRouter.of(context);
        return Scaffold(
          body: child,
          bottomNavigationBar: NavigationBar(
            selectedIndex: tabs.activeIndex,
            onDestinationSelected: tabs.setActiveIndex,
            destinations: [
              NavigationDestination(icon: const Icon(Icons.home_outlined), selectedIcon: const Icon(Icons.home_rounded), label: l.navHome),
              NavigationDestination(icon: const Icon(Icons.search_rounded), label: l.navSearch),
              NavigationDestination(icon: const Icon(Icons.add_circle_outline_rounded), selectedIcon: const Icon(Icons.add_circle_rounded), label: l.navPublish),
              NavigationDestination(icon: const Icon(Icons.directions_car_outlined), selectedIcon: const Icon(Icons.directions_car_rounded), label: l.navMyTrips),
              NavigationDestination(icon: const Icon(Icons.person_outline_rounded), selectedIcon: const Icon(Icons.person_rounded), label: l.navProfile),
            ],
          ),
        );
      },
    );
  }
}
