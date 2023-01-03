import 'package:flutter/material.dart';
import 'package:flutter_layout_grid/flutter_layout_grid.dart';

class StreetStatus extends StatefulWidget {
  const StreetStatus({Key? key, required this.statusCode}) : super(key: key);

  final int statusCode;

  @override
  State<StreetStatus> createState() => _StreetStatusState();
}

class _StreetStatusState extends State<StreetStatus> {
  final MaterialColor defaultColor = Colors.grey;

  final List<TagToColor> tagsColors = [
    TagToColor('right_tilt', Colors.indigo, 0),
    TagToColor('left_tilt', Colors.indigo, 1),
    TagToColor('left_pit', Colors.yellow, 2, useDuration: true),
    TagToColor('right_pit', Colors.yellow, 3, useDuration: true),
    TagToColor('front_pit', Colors.yellow, 4, useDuration: true),
    TagToColor('back_tilt', Colors.red, 5),
    TagToColor('front_tilt', Colors.red, 6),
  ];

  bool checkStatus(int index) {
    return ((widget.statusCode >> index) & 1) == 1;
  }

  @override
  void didUpdateWidget(covariant StreetStatus oldWidget) {
    if (widget.statusCode != oldWidget.statusCode) {
      for (TagToColor ttc in tagsColors) {
        if (checkStatus(ttc.index)) {
          ttc.status = true;
          if (ttc.useDuration) {
            Future.delayed(const Duration(seconds: 1), () {
              ttc.status = false;
            });
          }
        } else {
          if (!ttc.useDuration) {
            ttc.status = false;
          }
        }
      }
    }

    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[200],
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: LayoutGrid(
          areas: '''
          . front_pit front_pit .
          . front_tilt front_tilt .
          left_pit left_tilt right_tilt right_pit
          . back_tilt back_tilt .
          ''',
          columnSizes: [
            1.fr,
            1.5.fr,
            1.5.fr,
            1.fr,
          ],
          rowSizes: [
            1.fr,
            1.fr,
            2.fr,
            1.fr,
          ],
          columnGap: 12,
          rowGap: 12,
          children: tagsColors
              .map(
                (e) => Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: e.status ? e.color : defaultColor,
                  ),
                  child: Center(
                    child: Text(
                      e.tagToText(),
                      style: const TextStyle(
                        fontSize: 25,
                      ),
                    ),
                  ),
                ).inGridArea(e.tag),
              )
              .toList(),
        ),
      ),
    );
  }
}

class TagToColor {
  final String tag;
  final MaterialColor color;
  final int index;
  bool status = false;
  bool useDuration = false;

  TagToColor(this.tag, this.color, this.index, {this.useDuration = false});

  String tagToText() {
    String output = tag;
    output = output.replaceAll('_', ' ');
    output = "${output[0].toUpperCase()}${output.substring(1).toLowerCase()}";
    return output;
  }
}
