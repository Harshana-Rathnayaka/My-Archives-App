import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../components/theme.dart';
import '../../../../constants/colors.dart';

class DescriptionSection extends StatelessWidget {
  final List<Widget> children;
  const DescriptionSection({Key? key, required this.children}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeNotifier theme = Provider.of<ThemeNotifier>(context);

    return Expanded(
      child: Container(
        margin: const EdgeInsets.only(top: 20),
        width: double.infinity,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: children),
        decoration: BoxDecoration(color: theme.isDark ? Colors.black12 : colorWhite, borderRadius: BorderRadius.only(topLeft: Radius.circular(24), topRight: Radius.circular(24))),
      ),
    );
  }
}
