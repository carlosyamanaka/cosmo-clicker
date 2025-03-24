import 'package:cosmo_clicker/presentation/controllers/dust_controller.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final DustController controller = GetIt.instance<DustController>();
  CustomAppBar({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: Colors.purple,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(title,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold)),
          ),
          Row(
            children: [
              const Text('DUST: '),
              ListenableBuilder(
                listenable: Listenable.merge([controller]),
                builder: (context, __) {
                  return Text('${controller.value}',
                      style:
                          const TextStyle(color: Colors.white70, fontSize: 14));
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(70);
}
