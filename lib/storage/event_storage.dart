import 'package:BetaFitness/storage/event_list_storage.dart';

class EventStorage {
  late String storedEventName; //after iteration function is called it stores the users selected event name in this String
  late String storedEventDescription; //after iteration function is called it stores the users selected event description in this String
  late bool storeCheck; // used in checking whether you can move to the next page or not
  late DateTime storedDate;//after iteration function is called it stores the users selected event DateTime in this dateTime
  late List<EventStorage> listOfEvents = [];
}