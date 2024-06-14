import 'package:zhaopin/utils/date_utils.dart';

class IMTimeAgo {
  List<String> dayMap() {
    return [
      "昨天",
      "前天",
    ];
  }

  List<String> weekdayMap() {
    return ['', "星期一", "星期二", "星期三", "星期四", "星期五", "星期六", "星期天"];
  }

  String getYearMonthDate(DateTime dateTime) {
    return '${dateTime.year}年${dateTime.month}月${dateTime.day}日';
  }

  String getMonthDate(DateTime dateTime) {
    return '${dateTime.month}月${dateTime.day}日';
  }

  String? getTimeStringForChat(int timeStamp) {
    final DateTime date = DateTime.fromMillisecondsSinceEpoch(timeStamp * 1000);
    final DateTime epochLimit = DateTime.utc(1971);

    if (date.isBefore(epochLimit)) {
      return null;
    }

    final Duration duration = DateTime.now().difference(date);
    final int diffDays = duration.inDays +
        (duration.inMinutes >
                DateTime.now()
                    .difference(DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day))
                    .inMinutes
            ? 1
            : 0);
    final int diffMinutes = duration.inMinutes;

    String res;

    // 一个礼拜之内
    if (diffDays > 0 && diffDays < 7) {
      if (diffDays <= 2) {
        res = dayMap()[diffDays - 1];
      } else {
        res = weekdayMap()[date.weekday];
      }
    } else if (diffDays >= 7) {
      //当年内
      if (date.year == DateTime.now().year) {
        res = getMonthDate(date);
      } else {
        res = getYearMonthDate(date);
      }
    } else {
      if (diffMinutes > 1) {
        if (diffMinutes < 60) {
          final String option2 = diffMinutes.toString();
          res = "$option2 分钟前";
        } else {
          res = "${date.hour}:${date.minute < 10 ? "${date.minute}0" : date.minute}";
        }
      } else {
        res = "现在";
      }
    }

    return res;
  }

  String getTimeForMessage(int timeStamp) {
    var nowTime = DateTime.now();
    nowTime = DateTime(nowTime.year, nowTime.month, nowTime.day);
    var ftime = DateTime.fromMillisecondsSinceEpoch(timeStamp * 1000);
    final timeStr = YDDateUtil.formatDate(ftime, format: 'HH:mm'); // Use 'HH:mm' for 24-hour format
    // 一年外 年月日 + 时间 (24小时制)
    if (nowTime.year != ftime.year) {
      return YDDateUtil.formatDate(ftime, format: 'yyyy-MM-dd HH:mm');
    }
    // 一年内一周外 月日 + 时间 (24小时制）
    if (ftime.isBefore(nowTime.subtract(const Duration(days: 6)))) {
      return YDDateUtil.formatDate(ftime, format: 'MM-dd HH:mm');
    }
    // 一周内一天外 星期 + 时间 (24小时制）
    if (ftime.isBefore(nowTime.subtract(const Duration(days: 1)))) {
      return '${weekdayMap()[ftime.weekday]} $timeStr';
    }
    // 昨日 昨天 + 时间 (24小时制)
    if (nowTime.day != ftime.day) {
      String option2 = timeStr;
      return "昨天 $option2";
    }
    // 同年月日 时间 (24小时制)
    return timeStr;
  }
}
