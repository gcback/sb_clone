import 'package:mylib/mylib.dart';

class AppTapBar extends HookWidget implements PreferredSizeWidget {
  const AppTapBar({
    super.key,
    required this.size,
    required this.shadow,
    required this.backgroundColor,
  });

  final Size size;
  final ValueNotifier<double> shadow;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade400.withOpacity(shadow.value),
            offset: const Offset(0.0, 2),
            blurRadius: 0.8,
            spreadRadius: 0.25,
          )
        ],
      ),
      child: Row(
        children: [
          TextButton.icon(
              onPressed: noop,
              icon: const Icon(Icons.mail_outline),
              label: const Text('What\'s New')),
          TextButton.icon(
              onPressed: noop,
              icon: const Icon(Icons.movie_creation_outlined),
              label: const Text('Coupon')),
          const Expanded(
              child: Align(
            alignment: Alignment.centerRight,
            child: IconButton(
              onPressed: noop,
              icon: Icon(Icons.notifications_none_outlined),
            ),
          )),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => size;
}
