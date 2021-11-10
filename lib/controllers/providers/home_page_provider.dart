import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

class HomePageProvider extends ChangeNotifier{
  int _index = 0;
  PageController? pageController;

  HomePageProvider() {
    pageController = PageController(initialPage: _index,);
  }


  void setIndex(int index){
    print(index);
    _index = index;
    pageController!.jumpToPage(_index);
    notifyListeners();
  }

   int get index => _index;
}