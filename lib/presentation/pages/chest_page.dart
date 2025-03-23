import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class ChestPage extends StatefulWidget {
  const ChestPage({super.key});

  @override
  State<ChestPage> createState() => _ChestPageState();
}

class _ChestPageState extends State<ChestPage> {
  ValueNotifier<DateTime> date = ValueNotifier(DateTime.now());
  updateTime() async {
    setState(() {
      date.value = DateTime.now();
    });
    await Future.delayed(const Duration(seconds: 1), updateTime());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ListenableBuilder(
          listenable: Listenable.merge([date]),
          builder: (context, _) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text('${DateFormat('MMM y').format(date.value)}',
                    style: const TextStyle(fontSize: 24)),
                const SizedBox(height: 20),
                // InkWell(
                //   onTap: () {},
                //   child: const Image(
                //     image: AssetImage('assets/images/estrela.png'),
                //   ),
                // ),
              ],
            );
          },
        ),
      ),
    );
  }
}
