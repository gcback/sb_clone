import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:mylib/mylib.dart';

import 'home/flexible_space.dart';
import 'home/floating_button.dart';
import 'home/navigation_bar.dart';
import 'home/tap_bar.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      showPerformanceOverlay: false,
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: ThemeMode.light,
      home: const HomePage(),
    );
  }
}

class HomePage extends HookWidget {
  const HomePage({super.key});

  static String title = 'Home';
  static const double frontHeight = 250.0;
  static final segments = SegmentEnum.toSet;

  @override
  Widget build(BuildContext context) {
    final scaffoldBackgroundColor = Theme.of(context).scaffoldBackgroundColor;

    final pageIndex = useState(0);
    final scroller = useScrollController();
    final lerp = useState(0.0);
    final isVisible = useState(true);
    final selected = useState(<String>{'day'});

    useEffectOnce(() {
      scroller.addListener(() {
        // 0 ~ frontHeight --> 0.0 ~ 1.0로 매핑한다.
        lerp.value = (min(scroller.offset, frontHeight) / frontHeight).clamp(0.0, 1.0);

        // 스크롤을 내리면 ScrollDirection.reverse, 반대면 ScrollDirection.forward
        isVisible.value = switch (scroller.position.userScrollDirection) {
          ScrollDirection.reverse => false,
          ScrollDirection.forward => true,
          _ => isVisible.value,
        };
      });
    });

    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      body: CustomScrollView(
        controller: scroller,
        slivers: [
          SliverAppBar(
            pinned: true,
            floating: true,
            snap: true,
            toolbarHeight: 0.0,
            expandedHeight: frontHeight,
            backgroundColor: scaffoldBackgroundColor,
            surfaceTintColor: scaffoldBackgroundColor,
            flexibleSpace: AppFlexibleSpace(
              frontHeight: frontHeight,
              opacity: lerp,
              backgroundColor: scaffoldBackgroundColor,
            ),
            bottom: AppTapBar(
              size: const Size.fromHeight(kBottomNavigationBarHeight),
              opacity: lerp,
              backgroundColor: scaffoldBackgroundColor,
            ),
          ),
          buildSliverToSegmentedButton(segments, selected),
          buildDummyBox(Theme.of(context).scaffoldBackgroundColor),
          buildSliverList(),
        ],
      ),
      bottomNavigationBar: AppNavigationBar(
        scaffoldBackgroundColor: scaffoldBackgroundColor,
        pageIndex: pageIndex,
        visible: isVisible,
      ),

      ///
      /// FAB는 NavigationBar의 visibility에 따라 위치가 이동한다.
      floatingActionButtonAnimator: FabTransitionAnimation(),
      floatingActionButtonLocation: isVisible.value
          ? FloatingActionButtonLocation.endFloat
          : FloatingActionButtonLocation.endContained,
      floatingActionButton: ExpandedFloatingButton(
          expandState: isVisible,
          onTap: () {
            scroller
                .animateTo(0.0, duration: 100.msecs, curve: Curves.easeInOutCubic)
                .then((_) => isVisible.value = true);
          }),
    );
  }

  Widget buildSliverList() {
    return SliverList.builder(
      itemCount: 10,
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
          height: 150.0,
          decoration: BoxDecoration(
            color: (index + 5).color.withAlpha(150),
            borderRadius: BorderRadius.circular(16.0),
          ),
        );
      },
    );
  }

  Widget buildDummyBox(Color surface) {
    return SliverToBoxAdapter(
      child: Center(
        child: Padding(
          padding: 24.0.allInsets,
          child: Container(
            height: 100.0,
            width: 100.0,
            decoration: BoxDecoration(
              color: surface,
              borderRadius: BorderRadius.circular(4.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade400,
                  offset: const Offset(2.5, 2.0),
                  blurRadius: 5.0,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildSliverToSegmentedButton(
    Set<SegmentEnum> sements,
    ValueNotifier<Set<String>> selected,
  ) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: SegmentedButton(
          segments: sements
              .map((e) => ButtonSegment(
                    value: e.value,
                    label: Text(e.label),
                    icon: Icon(e.icon),
                  ))
              .toList(),
          selected: selected.value,
          onSelectionChanged: (set) {
            selected.value = set;
          },
        ),
      ),
    );
  }
}

enum SegmentEnum {
  day('day', 'Day', Icons.calendar_view_day_outlined),
  week('week', 'Week', Icons.calendar_view_week_outlined),
  month('month', 'Month', Icons.calendar_view_month_outlined);

  final String value;
  final String label;
  final IconData icon;

  const SegmentEnum(this.value, this.label, this.icon);

  static Set<SegmentEnum> get toSet => {day, week, month};
}
