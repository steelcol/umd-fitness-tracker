import 'package:BetaFitness/storage/singleton_storage.dart';
import 'package:BetaFitness/storage/event_storage.dart';
import 'package:BetaFitness/storage/event_list_storage.dart';



class StoreDateTime {
  String? storeEventName;
  String? storeDescription;
  DateTime? storeDate;
  bool? storeCheck;

  final SingletonStorage storage;
  final EventStorage eventStorage;
  StoreDateTime({required this.storage, required this.eventStorage});

  set setStoreCheckBool(bool check) {
    storeCheck = check;
  }

  set setStoreEventName(String eventName) {
    storeEventName = eventName;
  }

  set setStoreDescription(String description) {
    storeDescription = description;
  }

  set setStoreDate(DateTime date) {
    storeDate = date;
  }

  bool? get getStoreCheck {
    return storeCheck;
  }

  String? get getStoreEventName {
    return storeEventName;
  }

  String? get getStoreDescription {
    return storeDescription;
  }

  DateTime? get getStoreDate {
    return storeDate;
  }

  void iterateEventItems(selectedDay, EventStorage eventListStorageInstance) {
    storeCheck = false;
    for (int i = 0; i < storage.events
        .length; i++) { //loop thru list of events, check if there are events on selected day
      if (selectedDay!.day ==
          storage.events[i].date.day &&
          selectedDay!.month == storage.events[i].date.month &&
          selectedDay!.year ==
              storage.events[i].date.year) { //compare selectedDay to list

        storeEventName = storage.events[i].eventName;
        storeDescription = storage.events[i].description;
        storeDate = storage.events[i].date;

        eventStorage.storedEventName =
        getStoreEventName as String; // put events name into storage to be displayed in the ListedEventsMapWorkoutsPage
        eventStorage.storedEventDescription =
        getStoreDescription as String; // put events description into storage to be displayed in the ListedEventsMapWorkoutsPage
        eventStorage.storedDate =
        getStoreDate as DateTime; // put events DateTime into storage to be displayed in the ListedEventsMapWorkoutsPage

        eventStorage.listOfEvents.insert(0, eventListStorageInstance); //put instance of EventListStorage class into listOfEvents for listview builder


        storeCheck = true;
        print(storeCheck);
        eventStorage.storeCheck =
        getStoreCheck as bool;
        print("iteration Done"); //debugging purposes
      }
    }
    print("events in listOfEvents"); //debugging purpose
    for(int i = 0; i < eventStorage.listOfEvents.length; i++) {
      print(eventStorage.listOfEvents);
    }
  }

  bool checkSelectedDayIsNotNull() {
    print("check storeCheck");
    print(storeCheck);
    if (storeCheck == true) {
      return true;
    }
    else  {
      return false;
    }
  }
}

