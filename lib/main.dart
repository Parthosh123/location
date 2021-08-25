// import 'package:flutter/material.dart';
// import 'package:flutter_neat_and_clean_calendar/flutter_neat_and_clean_calendar.dart';
//
// void main() => runApp(MyApp());
//
// class MyApp extends StatelessWidget {
//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Clean Calendar Demo',
//       home: CalendarScreen(),
//     );
//   }
// }
//
// class CalendarScreen extends StatefulWidget {
//   @override
//   State<StatefulWidget> createState() {
//     return _CalendarScreenState();
//   }
// }
//
// class _CalendarScreenState extends State<CalendarScreen> {
//
//   final Map<DateTime, List<NeatCleanCalendarEvent>> _events = {
//     // DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day): [
//     //   NeatCleanCalendarEvent('Event A',
//     //       startTime: DateTime(DateTime.now().year, DateTime.now().month,
//     //           DateTime.now().day, 10, 0),
//     //       endTime: DateTime(DateTime.now().year, DateTime.now().month,
//     //           DateTime.now().day, 12, 0),
//     //       description: 'A special event',
//     //       color: Colors.blue[700]),
//     // ],
//   };
//
//   @override
//   void initState() {
//     super.initState();
//     // Force selection of today on first load, so that the list of today events gets shown.
//     _handleNewDate(DateTime(
//         DateTime.now().year, DateTime.now().month, DateTime.now().day));
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: Calendar(
//           startOnMonday: true,
//           weekDays: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'],
//           events: _events,
//           isExpandable: true,
//           //eventDoneColor: Colors.green,
//           selectedColor: Colors.pink,
//           todayColor: Colors.blue,
//           // eventColor: Colors.grey,
//           locale: 'en_US',
//           todayButtonText: 'Calender',
//           isExpanded: true,
//           expandableDateFormat: 'EEEE, dd. MMMM yyyy',
//           dayOfWeekStyle: TextStyle(
//               color: Colors.black, fontWeight: FontWeight.w800, fontSize: 11),
//         ),
//       ),
//     );
//   }
//
//   void _handleNewDate(date) {
//     print('Date selected: $date');
//   }
// }
import 'package:cell_calendar/cell_calendar.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'cell_calendar example'),
    );
  }
}

class MyHomePage extends StatelessWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  Widget build(BuildContext context) {
    List<CalendarEvent> _events;
    final cellCalendarPageController = CellCalendarPageController();
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: CellCalendar(
        cellCalendarPageController: cellCalendarPageController,
        events:_events ,
        daysOfTheWeekBuilder: (dayIndex) {
          final labels = ["S", "M", "T", "W", "T", "F", "S"];
          return Padding(
            padding: const EdgeInsets.only(bottom: 4.0),
            child: Text(
              labels[dayIndex],
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          );
        },
        monthYearLabelBuilder: (datetime) {
          final year = datetime.year.toString();
          final month = datetime.month.monthName;
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 3),
            child: Row(
              children: [
                SizedBox(width: 16),
                Text(
                  "$month  $year",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                IconButton(
                  padding: EdgeInsets.zero,
                  icon: Icon(Icons.calendar_today),
                  onPressed: () {
                    cellCalendarPageController.animateToDate(
                      DateTime.now(),
                      curve: Curves.linear,
                      duration: Duration(milliseconds: 300),
                    );
                  },
                )
              ],
            ),
          );
        },
        onCellTapped: (date) {
          final eventsOnTheDate = _events.where((event) {
            final eventDate = event.eventDate;
            return eventDate.year == date.year &&
                eventDate.month == date.month &&
                eventDate.day == date.day;
          }).toList();
          showDialog(
              context: context,
              builder: (_) => AlertDialog(
                title:
                Text(date.month.monthName + " " + date.day.toString()),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: eventsOnTheDate
                      .map(
                        (event) => Container(
                      width: 300.0,
                      padding: EdgeInsets.all(4),
                      margin: EdgeInsets.only(bottom: 12),
                      color: event.eventBackgroundColor,
                      child: Text(
                        event.eventName,
                        style: TextStyle(color: event.eventTextColor),
                      ),
                    ),
                  )
                      .toList(),
                ),
              ));
        },
        onPageChanged: (firstDate, lastDate) {
          /// Called when the page was changed
          /// Fetch additional events by using the range between [firstDate] and [lastDate] if you want
        },
      ),
    );
  }
}