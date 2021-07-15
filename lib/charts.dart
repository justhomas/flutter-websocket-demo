import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'indicator.dart';

class Chart extends StatefulWidget {
  final Map data;
  Chart({required this.data});
  @override
  State<StatefulWidget> createState() => ChartState();
}

class ChartState extends State<Chart> {
  int touchedIndex = -1;
  List colors = [
    Colors.blue,
    const Color(0xff13d38e),
    const Color(0xfff8b250),
    const Color(0xff845bef),
    Colors.red,
    Colors.yellow
  ];
  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.3,
      child: Card(
        color: Colors.white,
        child: Row(
          children: <Widget>[
            const SizedBox(
              height: 18,
            ),
            Expanded(
              child: AspectRatio(
                aspectRatio: 1,
                child: PieChart(
                  PieChartData(
                      pieTouchData:
                          PieTouchData(touchCallback: (pieTouchResponse) {
                        setState(() {
                          final desiredTouch = pieTouchResponse.touchInput
                                  is! PointerExitEvent &&
                              pieTouchResponse.touchInput is! PointerUpEvent;
                          if (desiredTouch &&
                              pieTouchResponse.touchedSection != null) {
                            touchedIndex = pieTouchResponse
                                .touchedSection!.touchedSectionIndex;
                          } else {
                            touchedIndex = -1;
                          }
                        });
                      }),
                      borderData: FlBorderData(
                        show: false,
                      ),
                      sectionsSpace: 0,
                      centerSpaceRadius: 40,
                      sections: showingSections()),
                ),
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                for (var i = 0; i < widget.data.keys.length; i++)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Indicator(
                      color: colors[i],
                      text:
                          '${widget.data.values.elementAt(i)}-${widget.data.keys.elementAt(i)}',
                      isSquare: true,
                    ),
                  ),
              ],
            ),
            const SizedBox(
              width: 28,
            ),
          ],
        ),
      ),
    );
  }

  List<PieChartSectionData> showingSections() {
    var count = widget.data.entries.length;

    return List.generate(count, (i) {
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? 25.0 : 16.0;
      final radius = isTouched ? 60.0 : 50.0;
      return PieChartSectionData(
        color: colors[i % 5],
        value: widget.data.length *
            (int.parse(widget.data.values.elementAt(i).toString()) / 100),
        title: '${widget.data.keys.elementAt(i)} ',
        radius: radius,
        titleStyle: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
            color: Colors.white),
      );
    });
  }
}
