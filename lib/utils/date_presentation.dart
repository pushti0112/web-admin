import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

abstract class DatePresentation {
  static String ddMMyyyyFormatter(String timeStamp) {
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(int.parse(timeStamp));
    return DateFormat('dd/MM/yyyy').format(dateTime);
  }

  static String yMMMdFormatter(String timeStamp) {
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(int.parse(timeStamp));
    return DateFormat('yMMMMd').format(dateTime);
  }

  static String yyyyMMddHHmmssFormatter(Timestamp timeStamp) {
    DateTime dateTime = timeStamp.toDate();
    return DateFormat('yyyy-MM-dd HH:mm:ss').format(dateTime);
  }

  static String yyyyMMddFormatter(Timestamp timeStamp) {
    DateTime dateTime = timeStamp.toDate();
    return DateFormat('yyyy-MM-dd').format(dateTime);
  }

  static DateTime timeStampToDate(String timeStamp) {
    return DateTime.fromMillisecondsSinceEpoch(int.parse(timeStamp));
  }

  static String niceDateFormatter(String timeStamp) {
    DateTime start = DateTime.fromMillisecondsSinceEpoch(int.parse(timeStamp));
    Duration time = DateTime.now().difference(start);
    String postDate = '';

    if (time.inDays >= 30)
      postDate = yMMMdFormatter(timeStamp);
    else if(time.inDays >= 7 && time.inDays < 30) {
      postDate = '${time.inDays~/7}w ago';
    } else if (time.inDays > 0 && time.inDays < 27)
      postDate = '${time.inDays}d ago';
    else if (time.inHours > 0)
      postDate = '${time.inHours}h ago';
    else if (time.inMinutes > 0)
      postDate = '${time.inMinutes}m ago';
    else
      postDate = '${time.inSeconds}s ago';
    return postDate;
  }

  static bool isSameDay(DateTime dateTime1, DateTime dateTime2) {
    DateTime new1 = DateTime(dateTime1.year, dateTime1.month, dateTime1.day);
    DateTime new2 = DateTime(dateTime2.year, dateTime2.month, dateTime2.day);

    if(new1.day == new2.day && new1.month == new2.month && new1.year == new2.year) {
      return true;
    }
    else return false;
  }

  static int getDifferenceBetweenDatesInDays(DateTime dateTime1, DateTime dateTime2) {
    DateTime new1 = DateTime(dateTime1.year, dateTime1.month, dateTime1.day);
    DateTime new2 = DateTime(dateTime2.year, dateTime2.month, dateTime2.day);

    Duration duration = new1.difference(new2);
    if(duration.inDays.isNegative) return duration.inDays * -1;
    else return duration.inDays;
  }

  static int getDifferenceBetweenDatesInMinutes(DateTime dateTime1, DateTime dateTime2) {
    //MyPrint.printOnConsole("Date1:${dateTime1}");
    //MyPrint.printOnConsole("Date2:${dateTime2}");
    DateTime new1 = DateTime(dateTime1.year, dateTime1.month, dateTime1.day, dateTime1.hour, dateTime1.minute, dateTime1.second);
    DateTime new2 = DateTime(dateTime2.year, dateTime2.month, dateTime2.day, dateTime2.hour, dateTime2.minute, dateTime2.second);

    Duration duration = new1.difference(new2);
    //MyPrint.printOnConsole("Difference:${duration.inMinutes}");
    if(duration.inMinutes.isNegative) return duration.inMinutes * -1;
    else return duration.inMinutes;
  }

  static String EEEddMMMMyyhhmmaFormatter(Timestamp date){
    String formattedDate = DateFormat('EEE dd, MMMM yy – hh:mm a').format(date.toDate());
    return formattedDate;
  }
}
