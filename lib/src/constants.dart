// Default letters to fill in the empty spaces
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
  int height;
  int width;
  final List<WSOrientation> orientations;
  final dynamic fillBlanks;
  final bool allowExtraBlanks;
  final int maxAttempts;
  final int maxGridGrowth;
  final bool preferOverlap;

  WSSettings({
    this.width,
    this.height,
    this.orientations = WSOrientation.values,
    this.fillBlanks = true,
    this.allowExtraBlanks = true,
    this.maxAttempts = 3,
    this.maxGridGrowth = 10,
    this.preferOverlap = true,
  });
}

/// Word location interface
class WSLocation implements WSPosition {
  final int x;
  final int y;
  final WSOrientation orientation;
  final int overlap;
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
  final int x;
  final int y;

  WSPosition({
    this.x = 0,
    this.y = 0,
  });
}

/// New puzzle interface
class WSNewPuzzle {
  List<List<String>> puzzle;
  List<String> wordsNotPlaced;
  List<String> warnings;
  List<String> errors;

  WSNewPuzzle({
    this.puzzle = null,
    List<String> wordsNotPlaced,
    List<String> warnings,
    List<String> errors,
  })  : wordsNotPlaced = wordsNotPlaced ?? [],
        warnings = warnings ?? [],
        errors = errors ?? [];
}

/// The solved puzzle interface
class WSSolved {
  List<WSLocation> found;
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
