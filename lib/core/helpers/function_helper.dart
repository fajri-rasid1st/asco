/// A collection of helper functions that are reusable for this app
class FunctionHelper {
  static String nextLetter(String letter) {
    // Ensure that the input is a single letter and is an alphabet character
    if (letter.length != 1 || !RegExp(r'^[A-Z]$').hasMatch(letter)) {
      throw ArgumentError('Input must be a single uppercase alphabet letter.');
    }

    // Get the ASCII code of the letter
    final code = letter.codeUnitAt(0);

    // Determine the next letter
    if (letter == 'Z') return 'A'; // If the input is 'Z', the output should be 'A'

    return String.fromCharCode(code + 1);
  }
}
