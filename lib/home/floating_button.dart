import 'package:mylib/mylib.dart';

class ExpandedFloatingButton extends HookWidget {
  const ExpandedFloatingButton(
      {super.key, required this.expandState, required this.onTap});

  final ValueNotifier<bool> expandState;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isExpanded = useValueListenable(expandState);

    return Material(
      borderRadius: BorderRadius.circular(32.0),
      // type: MaterialType.circle,
      // color: Theme.of(context).scaffoldBackgroundColor,
      clipBehavior: Clip.hardEdge,
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: 12.0.allInsets,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(Icons.pedal_bike, size: 28.0),
              AnimatedContainer(
                duration: 250.msecs,
                width: isExpanded ? 80.0 : 0.0,
                height: 24.0,
                alignment: Alignment.center,
                child: const Text(
                  'Delivers',
                  softWrap: false,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class FabTransitionAnimation extends FloatingActionButtonAnimator {
  @override
  Offset getOffset({
    required Offset begin,
    required Offset end,
    required double progress,
  }) =>
      Offset.lerp(begin, end, progress)!;

  @override
  Animation<double> getRotationAnimation({required Animation<double> parent}) =>
      Tween<double>(begin: 0.0, end: 1.0).animate(parent);

  @override
  Animation<double> getScaleAnimation({required Animation<double> parent}) =>
      Tween<double>(begin: 1.0, end: 1.0).animate(parent);
}
