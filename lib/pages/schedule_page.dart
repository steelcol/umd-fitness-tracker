import 'package:BetaFitness/storage/singleton_storage.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:BetaFitness/utilities/utils_for_schedule_page.dart';
import 'package:BetaFitness/models/event_model.dart';
import 'package:BetaFitness/pages/events_page.dart';
import '../controllers/event_controller.dart';
import 'package:BetaFitness/utilities/utils_for_schedule_page.dart' hide Event;


class SchedulePage extends StatefulWidget {
  const SchedulePage({Key? key, required this.storage}) : super(key: key);

  final SingletonStorage storage;

  State<SchedulePage> createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

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
            for(int i = 0; i < widget.storage.events.length; i++) { //loop thru list of events
              if (_selectedDay!.day ==
                  widget.storage.events[i].date.day && _selectedDay!.month == widget.storage.events[i].date.month && _selectedDay!.year == widget.storage.events[i].date.year) { //compare selectedDay to list
                print(widget.storage.events[i].eventName);
                print(widget.storage.events[i].description);
                print(widget.storage.events[i].date);
              }
            }
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

        /*
          Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }
   ElevatedButton(
            onPressed: () => _selectDate(context), // calls the selectedDate method
            child: const Text('Select date'),
          ),

          //when i select a day use the widget.storage.events to return the list of events,
          //then use for loop to search for event.date(returns datetime )

        */
        onPageChanged: (focusedDay) {
          // No need to call `setState()` here
          _focusedDay = focusedDay;
        },
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
  //          printEventDates();
            setState(() {
              //?
            });
          },
          child: Icon(Icons.add),
      backgroundColor: Colors.blueGrey,
      ),
    );
  }
}


