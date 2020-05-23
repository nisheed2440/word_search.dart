/// Default letters to fill in the empty spaces
const String WSLetters = 'abcdefghijklmnoprstuvwy';

/// All the orientations available to build the puzzle
enum WSOrientation {
  /// Horizontal orientation
  horizontal,

  /// horizontal reverse orientation
  horizontalBack,

  /// Vertical orientation
  vertical,

  /// Vertical reverse orientation
  verticalUp,

  /// Diagonal down orientation
  diagonal,

  /// Diagonal up orientation
  diagonalUp,

  /// Diagonal down reverse orientation
  diagonalBack,

  /// Diagonal up reverse orientation
  diagonalUpBack,
}

/// The puzzle settings intetface
class WSSettings {
  /// The recommended height of the puzzle
  ///
  /// **Note:** This will automatically increment if
  /// the words cannot be placed properly in the puzzle
  int height;

  /// The recommended width of the puzzle
  ///
  /// **Note:** This will automatically increment if
  /// the words cannot be placed properly in the puzzle
  int width;

  /// The allowed orientations for the words placed in the puzzle
  final List<WSOrientation> orientations;

  /// The way in which empty spaces in the puzzle should be filled
  ///
  /// If `Function` then should return a string with single character
  /// Example:
  /// ```
  /// fillBlanks: () {
  ///   final fancyStrings = '@#$%^420';
  ///   return fancyStrings[Random().nextInt(fancyStrings.length)];
  /// }
  /// ```
  ///
  /// If `String` then should contain a set of unique characters
  /// Example:
  /// ```
  /// fillBlanks: '@#$%^420',
  /// ```
  /// If `bool` it will use the default functionality
  final dynamic fillBlanks;

  /// Allow the puzzle to be filled with blanks
  final bool allowExtraBlanks;

  /// Maximum number of attempts to fit the words in the puzzle
  final int maxAttempts;

  /// Maximum numbed of times the grid can grow
  /// depending on the length of the words and placement
  final int maxGridGrowth;

  /// Allow overlaping of words in the puzzle
  final bool preferOverlap;

  WSSettings({
    this.width,
    this.height,
    this.orientations = WSOrientation.values,
    this.fillBlanks,
    this.allowExtraBlanks = true,
    this.maxAttempts = 3,
    this.maxGridGrowth = 10,
    this.preferOverlap = true,
  });
}

/// Word location interface
class WSLocation implements WSPosition {
  /// The column position where the word starts
  final int x;

  /// The row position where the word starts
  final int y;

  /// The orientation the word placed in the puzzle
  final WSOrientation orientation;

  /// The numbed of overlaps the word has
  final int overlap;

  /// The word used
  String word;

  WSLocation({
    this.x,
    this.y,
    this.orientation,
    this.overlap,
    this.word,
  });
}

// Word position interface
class WSPosition {
  /// The column position where the word starts
  final int x;

  /// The row position where the word starts
  final int y;

  WSPosition({
    this.x = 0,
    this.y = 0,
  });
}

/// New puzzle interface
class WSNewPuzzle {
  /// Two dimentional list containing the puzzle
  List<List<String>> puzzle;

  /// List of word not placed in the puzzle
  List<String> wordsNotPlaced;

  /// List of warnings that occured while creating the puzzle
  ///
  /// **Note:** Use this to notify the user of any issues
  List<String> warnings;

  /// List of errors that occured while creating the puzzle
  ///
  /// **Note:** Check this before printing or viewing the puzzle
  List<String> errors;

  WSNewPuzzle({
    this.puzzle,
    List<String> wordsNotPlaced,
    List<String> warnings,
    List<String> errors,
  })  : wordsNotPlaced = wordsNotPlaced ?? [],
        warnings = warnings ?? [],
        errors = errors ?? [];

  /// Outputs a puzzle to the console, useful for debugging.
  /// Returns a formatted string representing the puzzle.
  ///
  /// Example:
  /// ```
  /// final List<String> wl = ['hello', 'world', 'foo', 'bar', 'baz', 'dart'];
  /// final WSSettings ws = WSSettings();
  /// final WordSearch wordSearch = WordSearch();
  /// final WSNewPuzzle newPuzzle = wordSearch.newPuzzle(wl, ws);
  /// // Outputs the 2D puzzle
  /// print(newPuzzle.toString());
  /// ```
  @override
  String toString() {
    String puzzleString = '';
    for (var i = 0, height = puzzle.length; i < height; i++) {
      final List<String> row = puzzle[i];
      for (var j = 0, width = row.length; j < width; j++) {
        puzzleString += (row[j] == '' ? ' ' : row[j]) + ' ';
      }
      puzzleString += '\n';
    }
    return puzzleString;
  }
}

/// The solved puzzle interface
class WSSolved {
  /// List of words found by solving the puzzle
  List<WSLocation> found;

  /// List of words that were not found while solving the puzzle
  List<String> notFound;

  WSSolved({
    List<WSLocation> found,
    List<String> notFound,
  })  : found = found ?? [],
        notFound = notFound ?? [];
}

/// Orientation function interface
typedef WSOrientationFn = WSPosition Function(int x, int y, int i);

/// Check orientation function interface
typedef WSCheckOrientationFn = bool Function(int x, int y, int h, int w, int l);
