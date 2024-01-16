import 'dart:ui';
import 'package:align_positioned/align_positioned.dart';
import 'package:mylib/mylib.dart';

class AppFlexibleSpace extends StatelessWidget {
  const AppFlexibleSpace({
    super.key,
    required this.frontHeight,
    required this.opacity,
    required this.backgroundColor,
  });

  final double frontHeight;
  final ValueNotifier<double> opacity;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return FlexibleSpaceBar(
      collapseMode: CollapseMode.pin,
      background: Stack(
        fit: StackFit.expand,
        children: [
          Opacity(
            opacity: 1.0 - opacity.value,
            child: SizedBox(
              height: frontHeight,
              child: DecoratedBox(
                position: DecorationPosition.foreground,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      const Color.fromARGB(20, 255, 255, 255),
                      const Color.fromARGB(210, 255, 255, 255),
                      backgroundColor,
                    ],
                    stops: const [0.5, 0.7, 0.8],
                  ),
                ),
                child: Image.network(
                  9.image('nature'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          AlignPositioned(
            alignment: Alignment.bottomCenter,
            dy: -kBottomNavigationBarHeight * 1.8,
            child: Text('Happy New Year!',
                style: TextStyle(
                    fontSize: 36.0,
                    color: Colors.grey.shade400,
                    fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}
