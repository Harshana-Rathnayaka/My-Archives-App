import 'package:flutter/material.dart';

import '../constants/fonts.dart';

class CustomLoader extends StatefulWidget {
  final bool isLoading;
  final double opacity;
  final Color? progressBgColor;
  final double? progressValue;
  final Widget child;

  const CustomLoader({
    Key? key,
    required this.isLoading,
    required this.child,
    this.opacity = 0.4,
    this.progressBgColor,
    this.progressValue,
  }) : super(key: key);

  @override
  _CustomLoaderState createState() => _CustomLoaderState();
}

class _CustomLoaderState extends State<CustomLoader> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool? _overlayVisible;

  _CustomLoaderState();

  @override
  void initState() {
    super.initState();
    _overlayVisible = false;
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 300));
    _animation = Tween(begin: 0.0, end: 1.0).animate(_controller);
    _animation.addStatusListener((status) {
      if (status == AnimationStatus.forward) setState(() => {_overlayVisible = true});
      if (status == AnimationStatus.dismissed) setState(() => {_overlayVisible = false});
    });
    if (widget.isLoading) _controller.forward();
  }

  @override
  void didUpdateWidget(CustomLoader oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!oldWidget.isLoading && widget.isLoading) _controller.forward();

    if (oldWidget.isLoading && !widget.isLoading) _controller.reverse();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var widgets = <Widget>[];
    widgets.add(widget.child);

    if (_overlayVisible == true) {
      final modal = FadeTransition(
        opacity: _animation,
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Opacity(child: ModalBarrier(dismissible: false, color: Theme.of(context).backgroundColor), opacity: widget.opacity),
            SizedBox(
              width: double.infinity,
              height: 100,
              child: Column(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
                CircularProgressIndicator(value: widget.progressValue, backgroundColor: widget.progressBgColor),
                Visibility(
                  visible: widget.progressValue != null,
                  child: Center(
                      child: Text(
                    widget.progressValue != null ? '${(widget.progressValue! * 100).toStringAsFixed(0)}%' : '',
                    style: TextStyle(fontWeight: FontWeight.bold, fontFamily: fontSemiBold),
                  )),
                ),
                Visibility(
                  visible: widget.progressValue != null,
                  child: Center(
                      child: Text(
                    widget.progressValue != null ? 'Uploading images..' : '',
                    style: TextStyle(fontWeight: FontWeight.bold, fontFamily: fontRegular),
                  )),
                ),
              ]),
            )
          ],
        ),
      );
      widgets.add(modal);
    }

    return Stack(children: widgets);
  }
}
