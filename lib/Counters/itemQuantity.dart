import 'package:flutter/foundation.dart';

class ItemQuantity with ChangeNotifier {
  int _numberOfItems = 0;
  int get numberOfItems => _numberOfItems;
  diplay(int no)
  {
    _numberOfItems = no;
    notifyListeners();
  }
}
