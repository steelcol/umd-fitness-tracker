import 'package:BetaFitness/storage/singleton_storage.dart';

class EventPageArguments {
  //HomeArguments homeArguments = new HomeArguments(updatePage: updatePage)
  final SingletonStorage storage;
  final Function updatePage;

  const EventPageArguments({
    required this.storage,
    required this.updatePage
  });
}
