import 'dart:ui';
import 'package:align_positioned/align_positioned.dart';
import 'package:mylib/mylib.dart';

class AppNavigationBar extends HookWidget {
  const AppNavigationBar({
    super.key,
    required this.scaffoldBackgroundColor,
    required this.pageIndex,
    required this.visible,
  });

  final Color scaffoldBackgroundColor;
  final ValueNotifier<int> pageIndex;
  final ValueNotifier<bool> visible;

  static const double navigationBarHeight = 114.0;
  // NavigationBar height : 80.0;
  // Padding.bottom 34.0;

  @override
  Widget build(BuildContext context) {
    final isVisible = useValueListenable(visible);

    return SizedBox(
      height: navigationBarHeight,
      child: Stack(
        fit: StackFit.expand,
        children: [
          AnimatedAlignPositioned(
            alignment: Alignment.bottomCenter,
            duration: 250.msecs,
            moveByChildHeight: isVisible ? 0.0 : 1.0,
            child: ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(24.0)),
              child: BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaX: 6.0,
                  sigmaY: 6.0,
                ),
                child: NavigationBar(
                  backgroundColor: scaffoldBackgroundColor.withOpacity(0.8),
                  selectedIndex: pageIndex.value,
                  onDestinationSelected: (index) {
                    pageIndex.value = index;
                  },
                  labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
                  destinations: [
                    NavigationDestination(
                      selectedIcon: Icons.explore_outlined.widget,
                      icon: Icons.explore.widget,
                      label: 'Explore',
                    ),
                    NavigationDestination(
                      selectedIcon: Icons.commute_outlined.widget,
                      icon: Icons.commute.widget,
                      label: 'Commute',
                    ),
                    NavigationDestination(
                      selectedIcon: Icons.bookmark_border.widget,
                      icon: Icons.bookmark.widget,
                      label: 'Saved',
                    ),
                    NavigationDestination(
                      selectedIcon: Icons.people_outline.widget,
                      icon: Icons.people.widget,
                      label: '계정',
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
