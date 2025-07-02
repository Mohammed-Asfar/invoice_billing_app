String numberToWords(int number) {
  if (number == 0) return 'zero';

  final units = [
    '',
    'one',
    'two',
    'three',
    'four',
    'five',
    'six',
    'seven',
    'eight',
    'nine'
  ];
  final teens = [
    'ten',
    'eleven',
    'twelve',
    'thirteen',
    'fourteen',
    'fifteen',
    'sixteen',
    'seventeen',
    'eighteen',
    'nineteen'
  ];
  final tens = [
    '',
    '',
    'twenty',
    'thirty',
    'forty',
    'fifty',
    'sixty',
    'seventy',
    'eighty',
    'ninety'
  ];
  final thousands = ['hundred', 'thousand', 'lakh', 'crore'];

  String convertBelowThousand(int num) {
    String result = '';
    if (num >= 100) {
      result += '${units[num ~/ 100]} ${thousands[0]} ';
      num %= 100;
    }
    if (num >= 20) {
      result += '${tens[num ~/ 10]} ';
      num %= 10;
    } else if (num >= 10) {
      result += '${teens[num - 10]} ';
      num = 0;
    }
    if (num > 0) {
      result += '${units[num]} ';
    }
    return result.trim();
  }

  String result = '';
  int crore = number ~/ 10000000;
  if (crore > 0) {
    result += '${convertBelowThousand(crore)} ${thousands[3]} ';
    number %= 10000000;
  }
  int lakh = number ~/ 100000;
  if (lakh > 0) {
    result += '${convertBelowThousand(lakh)} ${thousands[2]} ';
    number %= 100000;
  }
  int thousand = number ~/ 1000;
  if (thousand > 0) {
    result += '${convertBelowThousand(thousand)} ${thousands[1]} ';
    number %= 1000;
  }
  if (number > 0) {
    result += convertBelowThousand(number);
  }

  return "${result[0].toUpperCase()}${result.substring(1)} Rupees Only";
}
