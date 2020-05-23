import './utils.dart';

final Map<WSOrientation, WSCheckOrientationFn> wsCheckOrientations = {
  WSOrientation.horizontal: (int x, int y, int h, int w, int l) {
    return w >= x + l;
  },
  WSOrientation.horizontalBack: (int x, int y, int h, int w, int l) {
    return x + 1 >= l;
  },
  WSOrientation.vertical: (int x, int y, int h, int w, int l) {
    return h >= y + l;
  },
  WSOrientation.verticalUp: (int x, int y, int h, int w, int l) {
    return y + 1 >= l;
  },
  WSOrientation.diagonal: (int x, int y, int h, int w, int l) {
    return w >= x + l && h >= y + l;
  },
  WSOrientation.diagonalBack: (int x, int y, int h, int w, int l) {
    return x + 1 >= l && h >= y + l;
  },
  WSOrientation.diagonalUp: (int x, int y, int h, int w, int l) {
    return w >= x + l && y + 1 >= l;
  },
  WSOrientation.diagonalUpBack: (int x, int y, int h, int w, int l) {
    return x + 1 >= l && y + 1 >= l;
  },
};
