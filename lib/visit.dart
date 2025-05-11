import 'package:flutter/material.dart';

class Visit {
  final DateTime date;
  final TimeOfDay startTime;
  final TimeOfDay endTime;
  final String title;
  final String location;
  final String visitor;
  final String address;

  Visit({
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.title,
    required this.location,
    required this.visitor,
    required this.address,
  });
}

List<Visit> mockVisits = [
  Visit(
    date: DateTime(2025, 5, 13),
    startTime: TimeOfDay(hour: 9, minute: 0),
    endTime: TimeOfDay(hour: 10, minute: 0),
    title: "Visite Client",
    location: "Clinique El Amen",
    visitor: "Foulen Ben foulen",
    address: "Rue de la Liberté, Tunis",
  ),
  Visit(
    date: DateTime(2025, 5, 13),
    startTime: TimeOfDay(hour: 11, minute: 30),
    endTime: TimeOfDay(hour: 13, minute: 30),
    title: "Maintenance",
    location: "Centre de Traumatologie",
    visitor: "Ali Bn Ali",
    address: "Avenue Habib Bourguiba, Tunis",
  ),
  Visit(
    date: DateTime(2025, 5, 14),
    startTime: TimeOfDay(hour: 14, minute: 0),
    endTime: TimeOfDay(hour: 15, minute: 30),
    title: "Visite Prospect",
    location: "Hôpital Charles Nicolle",
    visitor: "Sami Trabelsi",
    address: "Beb Saadoun, Tunis",
  ),
  Visit(
    date: DateTime(2025, 5, 15),
    startTime: TimeOfDay(hour: 10, minute: 0),
    endTime: TimeOfDay(hour: 11, minute: 30),
    title: "Visite Prospect",
    location: "Clinique Les Berges du Lac",
    visitor: "Leila Zmerli",
    address: "Lac 1, Tunis",
  ),
];

final Map<String, Color> visitTitleColors = {
  "Visite Client": Colors.blue,
  "Maintenance": Colors.green,
  "Visite Prospect": Colors.orange,
  "Aucune visite": Colors.grey,
};
