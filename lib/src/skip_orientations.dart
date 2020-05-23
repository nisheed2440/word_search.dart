import './utils.dart';

final Map<WSOrientation, WSOrientationFn> wsSkipOrientations = {
  WSOrientation.horizontal: (int x, int y, int l) {
    return WSPosition(x: 0, y: y + 1);
  },
  WSOrientation.horizontalBack: (int x, int y, int l) {
    return WSPosition(x: l - 1, y: y);
  },
  WSOrientation.vertical: (int x, int y, int l) {
    return WSPosition(x: 0, y: y + 100);
  },
  WSOrientation.verticalUp: (int x, int y, int l) {
    return WSPosition(x: 0, y: l - 1);
  },
  WSOrientation.diagonal: (int x, int y, int l) {
    return WSPosition(x: 0, y: y + 1);
  },
  WSOrientation.diagonalBack: (int x, int y, int l) {
    return WSPosition(x: l - 1, y: x >= l - 1 ? y + 1 : y);
  },
  WSOrientation.diagonalUp: (int x, int y, int l) {
    return WSPosition(x: 0, y: y < l - 1 ? l - 1 : y + 1);
  },
  WSOrientation.diagonalUpBack: (int x, int y, int l) {
    return WSPosition(x: l - 1, y: x >= l - 1 ? y + 1 : y);
  }
};
