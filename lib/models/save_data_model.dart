import 'package:BetaFitness/storage/singleton_storage.dart';
import 'package:BetaFitness/storage/event_storage.dart';
import 'package:BetaFitness/storage/event_list_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';



class StoreDateTime {
  String? storeEventName;
  String? storeDescription;
  DateTime? storeDate;
  bool? storeCheck;
  GeoPoint? storeGeoPoint;

  final SingletonStorage storage;
  final EventStorage eventStorage;
  StoreDateTime({required this.storage, required this.eventStorage});

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
  GeoPoint? get getStoreGeoPoint {
    return storeGeoPoint;
  }

  void iterateEventItems(selectedDay, EventStorage eventListStorageInstance) {
    eventStorage.listOfEvents.clear();//at start of iterate function clear the list
    storeCheck = false;
    for (int i = 0; i < storage.events
        .length; i++) { //loop thru list of events, check if there are events on selected day
      if (selectedDay!.day ==
          storage.events[i].date.day &&
          selectedDay!.month == storage.events[i].date.month &&
          selectedDay!.year ==
              storage.events[i].date.year) { //compare selectedDay to list

        EventListStorage newEventListStorageInstance = new EventListStorage();

        storeEventName = storage.events[i].eventName;
        storeDescription = storage.events[i].description;
        storeDate = storage.events[i].date;
        storeGeoPoint = storage.events[i].location;

        newEventListStorageInstance.storedEventListName = storage.events[i].eventName;
        newEventListStorageInstance.storedEventListDate = storage.events[i].date;
        newEventListStorageInstance.storedEventListDescription = storage.events[i].description;
        newEventListStorageInstance.storedGeoPointList = storage.events[i].location;


        eventStorage.storedEventName =
        getStoreEventName as String; // put events name into storage to be displayed in the ListedEventsMapWorkoutsPage
        eventStorage.storedEventDescription =
        getStoreDescription as String; // put events description into storage to be displayed in the ListedEventsMapWorkoutsPage
        eventStorage.storedDate =
        getStoreDate as DateTime; // put events DateTime into storage to be displayed in the ListedEventsMapWorkoutsPage
        eventStorage.storedGeoPoint =
        getStoreGeoPoint as GeoPoint;

        eventStorage.listOfEvents.insert(0, newEventListStorageInstance); //put instance of EventListStorage class into listOfEvents for listview builder


        storeCheck = true;
        eventStorage.storeCheck =
        getStoreCheck as bool;
      }
    }
  }

  bool checkSelectedDayIsNotNull() {
    print(storeCheck);
    if (storeCheck == true) {
      return true;
    }
    else  {
      return false;
    }
  }
}

