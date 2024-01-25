import 'package:flutter/services.dart';
import 'package:mylib/mylib.dart';

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
      themeMode: ThemeMode.system,
      home: const HomePage(),
    );
  }
}

class HomePage extends HookWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (_) {
                    return const TestWidget();
                  }));
                },
                child: const Text('Press'))
          ],
        ),
      ),
    );
  }
}

class TestWidget extends HookWidget {
  const TestWidget({super.key});

  static String title = 'Home';

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        if (didPop) return;

        final NavigatorState navigator = Navigator.of(context);
        final bool? shouldPop = await showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text('저장할까요?'),
                content: const Text(
                  'A dialog is a type of modal window that\n'
                  'for a decision to be made.',
                ),
                actions: [
                  TextButton(
                      child: const Text('Cancel'),
                      onPressed: () => navigator.pop(false)),
                  TextButton(
                      child: const Text('Save'),
                      onPressed: () => navigator.pop(true)),
                ],
              );
            });

        if (shouldPop ?? false) {
          if (navigator.canPop()) {
            navigator.pop();
          } else {
            SystemNavigator.pop();
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('popscope'),
        ),
        body: const Center(child: Text('some widgets')),
      ),
    );
  }
}
