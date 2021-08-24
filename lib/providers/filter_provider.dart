import 'package:flutter/foundation.dart';

class FilterProvider extends ChangeNotifier {
  bool _favorite = false;

  bool get favorite => _favorite;

  set favorite(bool favorite) {
    if (_favorite != favorite) {
      _favorite = favorite;
      notifyListeners();
    }
  }

  void updateFavorite() {
    notifyListeners();
  }
}
