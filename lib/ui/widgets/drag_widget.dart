import 'dart:math';

import 'package:flutter/material.dart';

class TUIKitDragArea extends StatefulWidget {
  final Widget child;
  final Offset? initOffset;
  final VoidCallback? closeFun;
  final bool isAllowDrag;
  final Color? backgroundColor;

  const TUIKitDragArea(
      {Key? key,
      required this.child,
      this.initOffset,
      this.closeFun,
      this.isAllowDrag = false, this.backgroundColor})
      : super(key: key);

  @override
  _DragAreaStateStateful createState() => _DragAreaStateStateful();
}

class _DragAreaStateStateful extends State<TUIKitDragArea> {
  late Offset position;
  double prevScale = 1;
  double scale = 1;

  @override
  void initState() {
    super.initState();
    position = widget.initOffset ?? const Offset(0, 200);
  }

  void updateScale(double zoom) => setState(() => scale = prevScale * zoom);

  void commitScale() => setState(() => prevScale = scale);

  void updatePosition(Offset newPosition) {
    final maxY = MediaQuery.of(context).size.height - 100;
    final maxX = MediaQuery.of(context).size.width - 100;

    final rebuildPosition = Offset(
        max(0, min(newPosition.dx, maxX)), max(0, min(newPosition.dy, maxY)));
    position = rebuildPosition;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: widget.backgroundColor,
      child: Stack(
        children: [
          Row(
            children: [
              Expanded(
                  child: Column(
                    children: [
                      Expanded(
                          child: GestureDetector(
                            onTap: () {
                              if (widget.closeFun != null) {
                                widget.closeFun!();
                              }
                            },
                            child: Container(
                              color: Colors.transparent,
                            ),
                          )
                      )
                    ],
                  ))
            ],
          ),
          if (widget.isAllowDrag)
            Positioned(
              left: position.dx,
              top: position.dy,
              child: Draggable(
                maxSimultaneousDrags: 1,
                feedback: widget.child,
                childWhenDragging: Container(),
                onDragEnd: (details) => updatePosition(details.offset),
                child: widget.child,
              ),
            ),
          if (!widget.isAllowDrag)
            Positioned(
              left: position.dx,
              top: position.dy,
              child: widget.child,
            )
        ],
      ),
    );
  }
}
