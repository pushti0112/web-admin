import 'package:flutter/cupertino.dart';

class CouponCodeProvider extends ChangeNotifier{

  double uploadingPer =  0;

  void setIndex(double index){
    this.uploadingPer = index;
    notifyListeners();
  }

}