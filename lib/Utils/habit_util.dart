import 'package:hebit_tracker_app/Modal/habit.dart';

bool isHabitCompletedToday(List<DateTime>completedDays) {
  final today = DateTime.now();
  return completedDays.any((date) => date.year == today.year&&date.month == today.month&&date.day == today.day);
}
Map<DateTime, int> prepareHeatMapDataset(List<Habit> habits) {
  Map<DateTime, int> dataset = {};

  for (var habit in habits) {
    for (var date in habit.completedDays) {
      // normalize date to avoid time mismatch
      final normalizedDate = DateTime(date.year, date.month, date.day);

      // if the date already exists in the dataset, increment it's count
      if (dataset.containsKey(normalizedDate)) {
        dataset[normalizedDate] = dataset[normalizedDate]! + 1;
      } else {
        // else initialize it with a count of 1
        dataset[normalizedDate] = 1;
      }
    }
  }
  return dataset;
}