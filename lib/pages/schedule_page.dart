import 'package:BetaFitness/arguments/event_arguments.dart';
import 'package:BetaFitness/storage/event_storage.dart';
import 'package:BetaFitness/storage/singleton_storage.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:BetaFitness/utilities/utils_for_schedule_page.dart';
import 'package:BetaFitness/utilities/utils_for_schedule_page.dart' hide Event;
import '../utilities/routes.dart';
import 'package:BetaFitness/models/Save_Data_model.dart';


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
            print("test, next line should print list of events");
            StoreDateTime test = new StoreDateTime(
              storage: widget.storage,
              eventStorage: eventStorage
            );
            /*for(int i = 0; i < widget.storage.events.length; i++) { //loop thru list of events
              if (_selectedDay!.day ==
                  widget.storage.events[i].date.day && _selectedDay!.month == widget.storage.events[i].date.month && _selectedDay!.year == widget.storage.events[i].date.year) { //compare selectedDay to list
                print(widget.storage.events[i].eventName);
                test.storeEventName = widget.storage.events[i].eventName;
                print(widget.storage.events[i].description);
                test.storeDescription = widget.storage.events[i].description;
                print(widget.storage.events[i].date);
                test.storeDate = widget.storage.events[i].date;
                print("test, next three line should be printed from the storeDateTime method");
                print(test.getStoreEventName);
                print(test.getStoreDescription);
                print(test.getStoreDate);
                print("test, next print should be from storedEvent in singleton");
                widget.storage.storedEventName = test.getStoreEventName as String;
                print(widget.storage.storedEventName);
              }
            } */
            print("start test");
            test.iterateEventItems(selectedDay);
            print("Test over");
            widget.storage.updateEventData();



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
          final args = EventArguments(eventStorage: eventStorage);
          Navigator.pushNamed(context, listedEventsMapWorkoutsPageRoute, arguments: args);
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.blueGrey,
      ),
    );
  }
}



