import 'package:intl/intl.dart';

final List<String> next6Days = List.generate(
  6,
  (index) {
    final nextDay = DateTime.now().add(Duration(days: index + 1));
    print(DateFormat('EEEE').format(nextDay)); // prints Tuesday
    return "${DateFormat('EEEE').format(nextDay)}";
  },
);
