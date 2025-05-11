import 'dart:async';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:visit_scheduler/visit.dart';
import 'planning_screen.dart';

class CalendarScreen extends StatefulWidget {
  final List<Visit> allVisits;

  CalendarScreen({super.key, required this.allVisits});

  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime? selectedDate;
  int _tapCount = 0;
  DateTime? _lastTappedDate;
  Timer? _tapTimer;

  List<Visit> get selectedVisits {
    if (selectedDate == null) return [];
    return widget.allVisits.where((visit) {
      return visit.date.year == selectedDate!.year &&
          visit.date.month == selectedDate!.month &&
          visit.date.day == selectedDate!.day;
    }).toList();
  }

  @override
  void dispose() {
    _tapTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calendrier'),
        backgroundColor: const Color(0xFFFAF9F9),
      ),
      body: Column(
        children: [
          Container(
            height: 480,
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            color: const Color(0xFFFAF9F9),
            child: SfCalendar(
              view: CalendarView.month,
              dataSource: VisitDataSource(widget.allVisits),
              initialSelectedDate: DateTime.now(),
              backgroundColor: const Color(0xFFFAF9F9),
              headerStyle: CalendarHeaderStyle(
                textAlign: TextAlign.center,
                backgroundColor: const Color(0xFFFAF9F9),
                textStyle: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              viewHeaderStyle: ViewHeaderStyle(
                backgroundColor: const Color(0xFFFAF9F9),
                dayTextStyle: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  color: Colors.grey[800],
                ),
              ),
              todayHighlightColor: Color(0xFF146FB7),
              selectionDecoration: BoxDecoration(
                border: Border.all(color: Color(0xFF146FB7), width: 2),
                borderRadius: BorderRadius.circular(6),
                color: Colors.transparent,
              ),
              monthViewSettings: MonthViewSettings(
                appointmentDisplayMode: MonthAppointmentDisplayMode.indicator,
                showAgenda: false,
                dayFormat: 'EEE',
                monthCellStyle: MonthCellStyle(
                  textStyle: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  trailingDatesTextStyle: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade400,
                  ),
                  leadingDatesTextStyle: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade400,
                  ),
                ),
                showTrailingAndLeadingDates: true,
              ),
              onTap: (CalendarTapDetails details) {
                if (details.targetElement == CalendarElement.calendarCell &&
                    details.date != null) {
                  _tapCount++;
                  _lastTappedDate = details.date;

                  _tapTimer?.cancel();
                  _tapTimer = Timer(Duration(milliseconds: 300), () {
                    if (_tapCount == 1) {
                      setState(() {
                        selectedDate = _lastTappedDate;
                      });
                    } else if (_tapCount == 2) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => PlanningScreen(
                            visits: selectedVisits,
                            selectedDate: _lastTappedDate!,
                          ),
                        ),
                      );
                    }
                    _tapCount = 0;
                  });
                }
              },
            ),
          ),
          Expanded(
            child: selectedDate != null
                ? (selectedVisits.isNotEmpty
                ? ListView.builder(
              itemCount: selectedVisits.length,
              itemBuilder: (context, index) {
                final visit = selectedVisits[index];
                return VisitCard(
                  visit: visit,
                  context: context,
                  color: visitTitleColors[visit.title] ?? Colors.grey,
                );
              },
            )
                : VisitCard(
              visit: Visit(
                title: "Aucune visite",
                location: "—",
                visitor: "—",
                date: selectedDate!,
                startTime: TimeOfDay(hour: 0, minute: 0),
                endTime: TimeOfDay(hour: 0, minute: 0),
                address: '',
              ),
              context: context,
              color: Colors.grey,
            ))
                : SizedBox(),
          ),
        ],
      ),
      backgroundColor: const Color(0xFFFAF9F9),
    );
  }
}

class VisitCard extends StatelessWidget {
  final Visit visit;
  final BuildContext context;
  final Color color;

  const VisitCard({
    required this.visit,
    required this.context,
    required this.color,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
        border: Border(
          left: BorderSide(color: color, width: 6),
        ),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        title: Text(
          visit.title,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 6),
            Row(
              children: [
                Icon(Icons.location_on, size: 18, color: Colors.grey[700]),
                SizedBox(width: 6),
                Expanded(child: Text(visit.location)),
              ],
            ),
            SizedBox(height: 4),
            Row(
              children: [
                Icon(Icons.person, size: 18, color: Colors.grey[700]),
                SizedBox(width: 6),
                Expanded(child: Text(visit.visitor)),
              ],
            ),
            SizedBox(height: 4),
            Row(
              children: [
                Icon(Icons.access_time, size: 18, color: Colors.grey[700]),
                SizedBox(width: 6),
                Text(
                  "${visit.startTime.format(context)} - ${visit.endTime.format(context)}",
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class VisitDataSource extends CalendarDataSource {
  VisitDataSource(List<Visit> source) {
    appointments = source;
  }

  @override
  DateTime getStartTime(int index) {
    final Visit visit = appointments![index];
    return DateTime(
      visit.date.year,
      visit.date.month,
      visit.date.day,
      visit.startTime.hour,
      visit.startTime.minute,
    );
  }

  @override
  DateTime getEndTime(int index) {
    final Visit visit = appointments![index];
    return DateTime(
      visit.date.year,
      visit.date.month,
      visit.date.day,
      visit.endTime.hour,
      visit.endTime.minute,
    );
  }

  @override
  String getSubject(int index) {
    return appointments![index].title;
  }

  @override
  Color getColor(int index) {
    final Visit visit = appointments![index];
    return visitTitleColors[visit.title] ?? Colors.grey;
  }
}
