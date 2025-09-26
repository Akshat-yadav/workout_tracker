import 'package:flutter/material.dart';
import 'package:flutter_heatmap_calendar/flutter_heatmap_calendar.dart';
import 'package:workout_app/datetime/date_time.dart';

class MyHeatMap extends StatelessWidget {
  final Map<DateTime, int>? datasets;
  final String startDateYYYYMMDD;
  const MyHeatMap({
    super.key,
    required this.datasets,
    required this.startDateYYYYMMDD,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Color(0xFFDBDBDB),
      ),
      child: HeatMap(
        startDate: createDateTimeObject(startDateYYYYMMDD),
        endDate: DateTime.now().add(const Duration(days: 0)),
        datasets: datasets,
        colorMode: ColorMode.color,
        // use a neutral color for days with 0 (not completed) so green only shows for completed days
        defaultColor: Color(0xFFC7C7C7),
        textColor: Colors.white,
        showColorTip: false,
        showText: true,
        scrollable: true,
        size: 40,
        margin: EdgeInsets.all(3),
        colorsets: {1: Colors.green[300]!, 2: Colors.green[600]!},
      ),
    );
  }
}
