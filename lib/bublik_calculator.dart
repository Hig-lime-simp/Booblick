class BublikCalculator {
  static double calculatePercent({
    required String name,
    required double sleep,
    required double games,
  }) {
    final bool nameCondition = name.trim() == "Гриша";
    final bool sleepCondition = sleep == 2.0;
    final bool gamesCondition = games == 22.0;

    int flagsCount = 0;
    if (nameCondition) flagsCount++;
    if (sleepCondition) flagsCount++;
    if (gamesCondition) flagsCount++;

    switch (flagsCount) {
      case 1:
        return 33.0;
      case 2:
        return 66.0;
      case 3:
        return 100.0;
      default:
        return 0.0;
    }
  }
}