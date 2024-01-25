import 'package:flutter/rendering.dart';
import 'package:mylib/mylib.dart';

void main() {
  runApp(const MyApp());
}

class Themes {
  static double subTitleSize = 24.0;

  static AppBarTheme appbar(var context) => AppBarTheme(
        titleTextStyle: const TextStyle(
          color: Colors.black87,
          fontWeight: FontWeight.w600,
        ),
        centerTitle: true,
        surfaceTintColor: Theme.of(context).scaffoldBackgroundColor,
      );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const HomePage('Starbucks Online Store'),
      theme: ThemeData(
        appBarTheme: Themes.appbar(context),
      ),
    );
  }
}

class HomePage extends HookWidget {
  const HomePage(this.title, {super.key});

  final String title;

  @override
  Widget build(BuildContext context) {
    final titleStyle = Theme.of(context).appBarTheme.titleTextStyle!;
    final isVisible = useState(false);
    final scroller = useScrollController();
    useEffectOnce(
      () => scroller.addListener(() => isVisible.value =
          scroller.position.userScrollDirection == ScrollDirection.reverse),
    );

    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        title: AnimatedDefaultTextStyle(
          duration: 250.msecs,
          style: titleStyle.copyWith(
              color: isVisible.value ? null : Colors.transparent),
          child: Text(title),
        ),
        actions: appbarActions,
      ),
      body: CustomScrollView(
        controller: scroller,
        slivers: [
          SliverAppBar(
            floating: true,
            title: Align(
              alignment: Alignment.centerLeft,
              child: Text(title,
                  style: titleStyle.copyWith(fontSize: Themes.subTitleSize)),
            ),
          ),
          sliverList,
        ],
      ),
    );
  }

  get appbarActions => [
        IconButton(onPressed: noop, icon: Icons.notifications_none.widget),
        IconButton(onPressed: noop, icon: Icons.settings.widget)
      ];

  get sliverList => SliverList.builder(
        itemCount: 15,
        itemBuilder: (context, index) {
          return Container(
            height: 100.0,
            margin: (12.0, 4.0).insets,
            decoration: BoxDecoration(
                color: index.color, borderRadius: BorderRadius.circular(16.0)),
          );
        },
      );
}
