class CompletedWorkout {
  final String uuid;
  final DateTime date;
  final Map<String, List<int>> exerciseWeights;

  CompletedWorkout({
    required this.uuid,
    required this.date,
    required this.exerciseWeights
  });
}
