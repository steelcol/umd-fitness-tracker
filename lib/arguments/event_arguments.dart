import 'package:BetaFitness/models/save_data_model.dart';

import '../storage/singleton_storage.dart';

class EventArguments {
  final StoreDateTime storeDateTime;
  final SingletonStorage storage;

  EventArguments({required this.storeDateTime, required this.storage});
}
