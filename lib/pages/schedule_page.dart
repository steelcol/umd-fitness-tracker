import 'package:BetaFitness/arguments/event_arguments.dart';
import 'package:BetaFitness/storage/event_storage.dart';
import 'package:BetaFitness/storage/singleton_storage.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:BetaFitness/utilities/utils_for_schedule_page.dart';
import 'package:BetaFitness/utilities/utils_for_schedule_page.dart' hide Event;
import '../utilities/routes.dart';
import 'package:BetaFitness/models/save_data_model.dart';


class SchedulePage extends StatefulWidget {
  const SchedulePage({Key? key, required this.storage}) : super(key: key);

  final SingletonStorage storage;

  State<SchedulePage> createState() => _SchedulePageState();
}




class _SchedulePageState extends State<SchedulePage> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  EventStorage eventStorage = new EventStorage();


  get args => null;

  @override
  Widget build(BuildContext context) {
    StoreDateTime test = new StoreDateTime(
        storage: widget.storage,
        eventStorage: eventStorage
    );
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Calendar'),
      ),
      body: TableCalendar(

        firstDay: kFirstDay,
        lastDay: kLastDay,
        focusedDay: _focusedDay,
        calendarFormat: _calendarFormat,
        selectedDayPredicate: (day) {
          return isSameDay(_selectedDay, day);
        },
        onDaySelected: (selectedDay, focusedDay) {
          setState(() {
            _selectedDay = selectedDay;
            _focusedDay = focusedDay; // update `_focusedDay` here as well
            //StoreDateTime test = new StoreDateTime(
            //  storage: widget.storage,
            //  eventStorage: eventStorage
            //);
            test.iterateEventItems(selectedDay);
            print("iteration done");
            if(test.checkSelectedDayIsNotNull() == true) {
              final args = EventArguments(eventStorage: eventStorage);
              Navigator.pushNamed(
                  context, listedEventsMapWorkoutsPageRoute, arguments: args);
            }
          });
        },
        onFormatChanged: (format) {
          if (_calendarFormat != format) {
            // Call `setState()` when updating calendar format
            setState(() {
              _calendarFormat = format;
            });
          }
        },

        onPageChanged: (focusedDay) {
          // No need to call `setState()` here
          _focusedDay = focusedDay;
        },

        ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
            final arguments = EventArguments(eventStorage: eventStorage);
            Navigator.pushNamed(context, eventsPageRoute, arguments: arguments);
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.blueGrey,
      ),
    );
  }
}