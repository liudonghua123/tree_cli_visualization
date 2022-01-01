class Utils {
  static String getFormattedDateTime({required DateTime dateTime}) {
    String day = '${dateTime.day}';
    String month = '${dateTime.month}';
    String year = '${dateTime.year}';

    String hour = '${dateTime.hour}';
    String minute = '${dateTime.minute}';
    String second = '${dateTime.second}';
    return '$day/$month/$year $hour/$minute/$second';
  }

  static String getFormattedFileSize({int size = 0}) {
    final _byteUnits = [
      'Bytes',
      'KB',
      'MB',
      'GB',
      'TB',
      'PB',
      'EB',
      'ZB',
      'YB'
    ];
    int i = 0;
    while (size >= 1024 && i < _byteUnits.length - 1) {
      size ~/= 1024;
      i++;
    }
    final result = size.toStringAsFixed(i == 0 ? 0 : 1);
    return '$result ${_byteUnits[i]}';
  }
}
