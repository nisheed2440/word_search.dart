import 'dart:math';

import 'src/orientations.dart';
import 'src/check-orientations.dart';
import 'src/skip-orientations.dart';
import 'src/utils.dart';
export 'src/utils.dart';

/// The Word Search puzzle class
///
class WordSearch {
  /// The definition of the orientation, calculates the next square given a
  /// starting square (x,y) and distance (i) from that square.
  final orientations = wsOrientations;

  /// Determines if an orientation is possible given the starting square (x,y),
  /// the height (h) and width (w) of the puzzle, and the length of the word (l).
  /// Returns true if the word will fit starting at the square provided using
  /// the specified orientation.
  final _checkOrientations = wsCheckOrientations;

  /// Determines the next possible valid square given the square (x,y) was ]
  /// invalid and a word length of (l).  This greatly reduces the number of
  /// squares that must be checked. Returning {x: x+1, y: y} will always work
  /// but will not be optimal.
  final _skipOrientations = wsSkipOrientations;

  /// Words not placed in the puzzle
  List<String> _wordsNotPlaced = [];

  /// Initializes the puzzle and places words in the puzzle one at a time.
  ///
  /// Returns either a valid puzzle with all of the words or null if a valid
  /// puzzle was not found.
  ///
  /// [words]: The list of words to fit into the puzzle
  /// [options]: The options to use when filling the puzzle
  List<List<String>> _fillPuzzle(
    List<String> words,
    WSSettings options,
  ) {
    final List<List<String>> puzzle = [];
    // initialize the puzzle with blanks
    for (var i = 0; i < options.height; i++) {
      puzzle.add([]);
      for (var j = 0; j < options.width; j++) {
        puzzle[i].add('');
      }
    }
    // add each word into the puzzle one at a time
    for (var i = 0; i < words.length; i++) {
      if (!_placeWordInPuzzle(puzzle, options, words[i])) {
        // if a word didn't fit in the puzzle, give up
        _wordsNotPlaced.add(words[i]);
        return null;
      }
    }
    // return the puzzle
    return puzzle;
  }

  /// If overlap maximization was indicated, this function is used to prune the
  /// list of valid locations down to the ones that contain the maximum overlap
  /// that was previously calculated.
  ///
  /// Returns the pruned set of locations.
  ///
  /// [locations]: The set of locations to prune
  /// [overlap]: The required level of overlap
  bool _placeWordInPuzzle(
    List<List<String>> puzzle,
    WSSettings options,
    String word,
  ) {
    // find all of the best locations where this word would fit
    final List<WSLocation> locations =
        _findBestLocations(puzzle, options, word);

    if (locations.length == 0) {
      return false;
    }

    // select a location at random and place the word there
    final WSLocation sel = locations[Random().nextInt(locations.length)];
    _placeWord(
      puzzle,
      word,
      sel.x,
      sel.y,
      orientations[sel.orientation],
    );
    return true;
  }

  /// Iterates through the puzzle and determines all of the locations where
  /// the word will fit. Options determines if overlap should be maximized or
  /// not.
  ///
  /// Returns a list of location objects which contain an x,y cooridinate
  /// indicating the start of the word, the orientation of the word, and the
  /// number of letters that overlapped with existing letter.
  ///
  /// [puzzle]: The current state of the puzzle
  /// [options]: The options to use when filling the puzzle
  /// [word]: The word to fit into the puzzle.
  List<WSLocation> _findBestLocations(
    List<List<String>> puzzle,
    WSSettings options,
    String word,
  ) {
    List<WSLocation> locations = [];
    int height = options.height;
    int width = options.width;
    int wordLength = word.length;
    // we'll start looking at overlap = 0
    int maxOverlap = 0;

    // loop through all of the possible orientations at this position
    for (var i = 0; i < options.orientations.length; i++) {
      final WSOrientation orientation = options.orientations[i];
      final WSOrientationFn next = orientations[orientation];
      final WSCheckOrientationFn check = _checkOrientations[orientation];
      final WSOrientationFn skip = _skipOrientations[orientation];
      int x = 0;
      int y = 0;
      // loop through every position on the board
      while (y < height) {
        // see if this orientation is even possible at this location
        if (check(x, y, height, width, wordLength)) {
          // determine if the word fits at the current position
          final int overlap = _calcOverlap(word, puzzle, x, y, next);
          // if the overlap was bigger than previous overlaps that we've seen
          if (overlap >= maxOverlap ||
              (!options.preferOverlap && overlap > -1)) {
            maxOverlap = overlap;
            locations.add(
              WSLocation(
                x: x,
                y: y,
                orientation: orientation,
                overlap: overlap,
                word: word,
              ),
            );
          }
          // increment x position
          x += 1;
          if (x >= width) {
            x = 0;
            // increment y position
            y += 1;
          }
        } else {
          // if current cell is invalid, then skip to the next cell where
          // this orientation is possible. this greatly reduces the number
          // of checks that we have to do overall
          WSPosition nextPossible = skip(x, y, wordLength);
          x = nextPossible.x;
          y = nextPossible.y;
        }
      }
    }

    // finally prune down all of the possible locations we found by
    // only using the ones with the maximum overlap that we calculated
    return options.preferOverlap
        ? _pruneLocations(locations, maxOverlap)
        : locations;
  }

  /// Determines whether or not a particular word fits in a particular
  /// orientation within the puzzle.
  ///
  /// Returns the number of letters overlapped with existing words if the word
  /// fits in the specified position, -1 if the word does not fit.
  ///
  /// [word]: The word to fit into the puzzle.
  /// [puzzle]: The current state of the puzzle
  /// [x]: The x position to check
  /// [y]: The y position to check
  /// [fnGetSquare]: Function that returns the next square
  int _calcOverlap(
    String word,
    List<List<String>> puzzle,
    int x,
    int y,
    WSOrientationFn fnGetSquare,
  ) {
    int overlap = 0;

    // traverse the squares to determine if the word fits
    for (var i = 0; i < word.length; i++) {
      final WSPosition next = fnGetSquare(x, y, i);
      String square = puzzle[next.y][next.x];

      // if the puzzle square already contains the letter we
      // are looking for, then count it as an overlap square
      if (square == word[i]) {
        overlap++;
      }
      // if it contains a different letter, than our word doesn't fit
      // here, return -1
      else if (square != '') {
        return -1;
      }
    }

    // if the entire word is overlapping, skip it to ensure words aren't
    // hidden in other words
    return overlap;
  }

  /// If overlap maximization was indicated, this function is used to prune the
  /// list of valid locations down to the ones that contain the maximum overlap
  /// that was previously calculated.
  ///
  /// Returns the pruned set of locations.
  ///
  /// [locations]: The set of locations to prune
  /// [overlap]: The required level of overlap
  List<WSLocation> _pruneLocations(
    List<WSLocation> locations,
    int overlap,
  ) {
    List<WSLocation> pruned = [];
    for (var i = 0; i < locations.length; i++) {
      if (locations[i].overlap >= overlap) {
        pruned.add(locations[i]);
      }
    }
    return pruned;
  }

  /// Places a word in the puzzle given a starting position and orientation.
  ///
  /// [puzzle]: The current state of the puzzle
  /// [word]: The word to fit into the puzzle.
  /// [x]: The x position to check
  /// [y]: The y position to check
  /// [fnGetSquare]: Function that returns the next square
  void _placeWord(
    List<List<String>> puzzle,
    String word,
    int x,
    int y,
    WSOrientationFn fnGetSquare,
  ) {
    for (var i = 0; i < word.length; i++) {
      final WSPosition next = fnGetSquare(x, y, i);
      puzzle[next.y][next.x] = word[i];
    }
  }

  /// Fills in any empty spaces in the puzzle with random letters.
  ///
  /// [puzzle]: The current state of the puzzle
  /// [extraLetterGenerator]: Function to add extra letters to fill blanks
  int _fillBlanks(List<List<String>> puzzle, Function extraLetterGenerator) {
    int extraLettersCount = 0;
    for (var i = 0, height = puzzle.length; i < height; i++) {
      List<String> row = puzzle[i];
      for (var j = 0, width = row.length; j < width; j++) {
        if (puzzle[i][j] == '') {
          puzzle[i][j] = extraLetterGenerator();
          extraLettersCount += 1;
        }
      }
    }
    return extraLettersCount;
  }

  /// Generates a new word find (word search) puzzle.
  ///
  /// Example:
  /// ```
  /// final List<String> wl = ['hello', 'world', 'foo', 'bar', 'baz', 'dart'];
  /// final WSSettings ws = WSSettings();
  /// final WordSearch wordSearch = WordSearch();
  /// final WSNewPuzzle newPuzzle = wordSearch.newPuzzle(wl, ws);
  /// print(newPuzzle.puzzle);
  /// ```
  ///
  WSNewPuzzle newPuzzle(
    List<String> words,
    WSSettings settings,
  ) {
    // New instance of the output data
    WSNewPuzzle output = WSNewPuzzle();
    if (words.length == 0) {
      output.errors.add('Zero words provided');
      return output;
    }
    List<List<String>> puzzle;
    int attempts = 0;
    int gridGrowths = 0;

    // copy and sort the words by length, inserting words into the puzzle
    // from longest to shortest works out the best
    final List<String> wordList = []
      ..addAll(words)
      ..sort((String a, String b) {
        return b.length - a.length;
      });
    // max word length
    final maxWordLength = wordList.first.length;
    // create new options instance of the settings
    final WSSettings options = WSSettings(
      width: settings.width != null ? settings.width : maxWordLength,
      height: settings.height != null ? settings.height : maxWordLength,
      orientations: settings.orientations,
      fillBlanks: settings.fillBlanks,
      maxAttempts: settings.maxAttempts,
      maxGridGrowth: settings.maxGridGrowth,
      preferOverlap: settings.preferOverlap,
    );
    while (puzzle == null) {
      while (puzzle == null && attempts++ < options.maxAttempts) {
        _wordsNotPlaced = [];
        puzzle = _fillPuzzle(wordList, options);
      }
      if (puzzle == null) {
        // Increase the size of the grid
        gridGrowths += 1;
        // No more grid growths allowed
        if (gridGrowths > options.maxGridGrowth) {
          output.errors.add(
            'No valid ${options.width}x${options.height} grid found and not allowed to grow more',
          );
          return output;
        }
        print('Trying a bigger grid after ${attempts - 1}');
        options.height += 1;
        options.width += 1;
        attempts = 0;
      }
    }
    // fill in empty spaces with random letters
    if (options.fillBlanks) {
      List<String> lettersToAdd = [];
      int fillingBlanksCount = 0;
      int extraLettersCount = 0;
      double gridFillPercent = 0;
      Function extraLetterGenerator;
      // Custom fill blanks function
      if (options.fillBlanks is Function) {
        extraLetterGenerator = options.fillBlanks;
      } else if (options.fillBlanks is String) {
        // Use the simple array pop mechanism for the input string
        lettersToAdd.addAll(options.fillBlanks.toLowerCase().split(''));
        extraLetterGenerator = () {
          if (lettersToAdd.length > 0) {
            return lettersToAdd.removeLast();
          }
          fillingBlanksCount += 1;
          return '';
        };
      } else {
        // Use the default random letters
        extraLetterGenerator = () {
          return WSLetters[Random().nextInt(WSLetters.length)];
        };
      }
      // Fill all the blanks in the puzzle
      extraLettersCount = _fillBlanks(puzzle, extraLetterGenerator);
      // Warn the user that some letters were not used
      if (lettersToAdd.length > 0) {
        output.warnings
            .add('Some extra letters provided were not used: ${lettersToAdd}');
      }
      // Extra letters not filled in the grid if allow blanks is false
      if (lettersToAdd.length > 0 &&
          fillingBlanksCount > 0 &&
          !options.allowExtraBlanks) {
        output.errors.add(
            '${fillingBlanksCount} extra letters were missing to fill the grid');
        return output;
      }
      gridFillPercent =
          100 * (1 - extraLettersCount / (options.width * options.height));
      print('Blanks filled with ${extraLettersCount} random letters');
      print('Final grid is filled at ${gridFillPercent.toStringAsFixed(0)}%');
    }
    output.puzzle = puzzle;
    output.wordsNotPlaced = _wordsNotPlaced;
    return output;
  }

  /// Returns the starting location and orientation of the specified words
  /// within the puzzle. Any words that are not found are returned in the
  /// notFound array.
  ///
  /// Example:
  /// ```
  /// final List<String> wl = ['hello', 'world', 'foo', 'bar', 'baz', 'dart'];
  /// final WSSettings ws = WSSettings();
  /// final WordSearch wordSearch = WordSearch();
  /// final WSNewPuzzle newPuzzle = wordSearch.newPuzzle(wl, ws);
  /// final WSSolved solved = wordSearch.solvePuzzle(newPuzzle.puzzle, ['dart']);
  /// // Outputs found and not found words
  /// ```
  ///
  WSSolved solvePuzzle(
    List<List<String>> puzzle,
    List<String> words,
  ) {
    WSSettings options = WSSettings(
      height: puzzle.length,
      width: puzzle[0].length,
    );
    // Create new instance of the solved interface
    WSSolved output = WSSolved();

    for (var i = 0, len = words.length; i < len; i++) {
      final String word = words[i];
      List<WSLocation> locations = _findBestLocations(puzzle, options, word);
      if (locations.length > 0 && locations[0].overlap == word.length) {
        locations[0].word = word;
        output.found.add(locations[0]);
      } else {
        output.notFound.add(word);
      }
    }
    // Return the output
    return output;
  }
}
