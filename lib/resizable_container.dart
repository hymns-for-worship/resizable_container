import 'package:flutter/material.dart';

class ResizableContainer extends StatefulWidget {
  const ResizableContainer({
    Key? key,
    required this.left,
    required this.right,
    this.width = 350,
  }) : super(key: key);

  final Widget left, right;
  final double width;

  @override
  State<ResizableContainer> createState() => _ResizableContainerState();
}

class _ResizableContainerState extends State<ResizableContainer> {
  double? detailsWidth;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, dimens) {
          double minWidth = widget.width;
          final maxWidth = dimens.maxWidth - minWidth;
          if (detailsWidth != null) {
            if (detailsWidth! > maxWidth) {
              detailsWidth = maxWidth;
            }
            if (detailsWidth! < minWidth) {
              detailsWidth = minWidth;
            }
          }
          return Row(
            children: [
              SizedBox(
                width: detailsWidth ?? maxWidth,
                height: double.infinity,
                child: widget.left,
              ),
              MouseRegion(
                cursor: SystemMouseCursors.resizeLeftRight,
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onHorizontalDragUpdate: (details) {
                    if (mounted) {
                      setState(() {
                        double w = detailsWidth ?? maxWidth;
                        w += details.delta.dx;
                        // Check for min width
                        if (w < minWidth) {
                          w = minWidth;
                        }
                        // Check for max width
                        if (w > maxWidth) {
                          w = maxWidth;
                        }
                        detailsWidth = w;
                      });
                    }
                  },
                  child: const SizedBox(
                    width: 5,
                    height: double.infinity,
                    child: VerticalDivider(),
                  ),
                ),
              ),
              Expanded(child: widget.right),
            ],
          );
        },
      ),
    );
  }
}
