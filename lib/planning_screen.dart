import 'package:flutter/material.dart';
import 'package:visit_scheduler/visit.dart';

class PlanningScreen extends StatelessWidget {
  final List<Visit> visits;
  final DateTime selectedDate;

  PlanningScreen({required this.visits, required this.selectedDate});

  @override
  Widget build(BuildContext context) {
    final sortedVisits = [...visits]..sort((a, b) => a.startTime.compareTo(b.startTime));

    return Scaffold(
      appBar: AppBar(
        leading: BackButton(),
        title: Text('Votre Planning', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Icon(Icons.search),
          )
        ],
      ),
      body: Column(
        children: [
          _buildDateSelector(),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.symmetric(vertical: 16),
              itemCount: sortedVisits.length,
              itemBuilder: (context, index) {
                final visit = sortedVisits[index];
                return _buildVisitRow(context, visit, index == 0);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateSelector() {
    final days = List.generate(7, (i) => selectedDate.add(Duration(days: i - 3)));

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: days.map((date) {
          final isSelected = date.day == selectedDate.day &&
              date.month == selectedDate.month &&
              date.year == selectedDate.year;
          return Column(
            children: [
              Text(
                _getWeekday(date),
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: isSelected ? Colors.black : Colors.grey,
                ),
              ),
              const SizedBox(height: 4),
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.blue : Colors.grey[200],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  "${date.day}",
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildVisitRow(BuildContext context, Visit visit, bool isHighlighted) {
    final timeRange = "${visit.startTime.format(context)}\n${visit.endTime.format(context)}";
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 60,
            child: Text(
              timeRange,
              textAlign: TextAlign.right,
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 13),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: isHighlighted ? Colors.blue : Colors.grey[200],
                borderRadius: BorderRadius.circular(12),
              ),
              padding: EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    visit.title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: isHighlighted ? Colors.white : Colors.black,
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    visit.location,
                    style: TextStyle(
                      color: isHighlighted ? Colors.white : Colors.black87,
                    ),
                  ),
                  SizedBox(height: 6),
                  Row(
                    children: [
                      Icon(Icons.person,
                          size: 16,
                          color: isHighlighted ? Colors.white : Colors.black54),
                      SizedBox(width: 4),
                      Text(
                        visit.visitor,
                        style: TextStyle(
                          color: isHighlighted ? Colors.white : Colors.black87,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.location_on,
                          size: 16,
                          color: isHighlighted ? Colors.white : Colors.black54),
                      SizedBox(width: 4),
                      Text(
                        "Adresse",
                        style: TextStyle(
                          color: isHighlighted ? Colors.white : Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getWeekday(DateTime date) {
    const weekdays = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
    return weekdays[date.weekday % 7];
  }
}
