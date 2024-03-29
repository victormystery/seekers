import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:seeker_ng/service/booking_services/personalization_service.dart';

class BookConfirmationService with ChangeNotifier {
  bool isPanelOpened = false;

  double totalPriceAfterAllcalculation = 0.0;
  var subTotalAfterAllCalculation = 0.0;
  double totalPriceOnlineServiceAfterAllCalculation = 0.0;
  var subTotalOnlineServiceAfterAllCalculation = 0.0;

  var taxPrice;
  var taxPriceOnline;

  setTotalOnlineService(v) {
    totalPriceOnlineServiceAfterAllCalculation = v;
    notifyListeners();
  }

  setTotalOfflineService(v) {
    totalPriceAfterAllcalculation = v;
    notifyListeners();
  }

  setPanelOpenedTrue() {
    isPanelOpened = true;
    notifyListeners();
  }

  setPanelOpenedFalse() {
    isPanelOpened = false;
    notifyListeners();
  }

  includedTotalPrice(List includedList) {
    var total = 0.0;
    for (int i = 0; i < includedList.length; i++) {
      total = total + (includedList[i]['price'] * includedList[i]['qty']);
    }
    return total;
  }

  extrasTotalPrice(List extrasList) {
    var total = 0.0;
    for (int i = 0; i < extrasList.length; i++) {
      if (extrasList[i]['selected'] == true) {
        total = total + (extrasList[i]['price'] * extrasList[i]['qty']);
      }
    }
    return total;
  }

  calculateSubtotal(List includedList, List extrasList) {
    var includedTotal = 0.0;
    var extraTotal = 0.0;
    includedTotal = includedTotalPrice(includedList);
    extraTotal = extrasTotalPrice(extrasList);
    subTotalAfterAllCalculation = includedTotal + extraTotal;

    return subTotalAfterAllCalculation;
  }

  calculateSubtotalForOnline(List extrasList) {
    var extraTotal = 0.0;

    extraTotal = extrasTotalPrice(extrasList);
    subTotalOnlineServiceAfterAllCalculation = extraTotal;
    return extraTotal;
  }

  calculateTax(
    taxPercent,
    List includedList,
    List extrasList,
  ) {
    var subTotal = calculateSubtotal(includedList, extrasList);
    taxPrice = (subTotal * taxPercent) / 100 ?? 0;

    return taxPrice;
  }

  calculateTotal(taxPercent, List includedList, List extrasList) {
    var subTotal = calculateSubtotal(includedList, extrasList);
    var tax = calculateTax(taxPercent, includedList, extrasList);

    totalPriceAfterAllcalculation = subTotal + tax;
    Future.delayed(const Duration(microseconds: 500), () {
      notifyListeners();
    });
  }

  calculateTotalOnlineService(
      taxPercent, List includedList, List extrasList, BuildContext context) {
    var subTotal = calculateSubtotal(includedList, extrasList);
    var tax = calculateTax(taxPercent, includedList, extrasList);
    totalPriceOnlineServiceAfterAllCalculation = subTotal +
        tax +
        Provider.of<PersonalizationService>(context, listen: false)
            .defaultprice;
    Future.delayed(const Duration(microseconds: 500), () {
      notifyListeners();
    });
  }

  caculateTotalAfterCouponApplied(couponDiscount) {
    totalPriceAfterAllcalculation =
        totalPriceAfterAllcalculation - couponDiscount;
    totalPriceOnlineServiceAfterAllCalculation =
        totalPriceOnlineServiceAfterAllCalculation - couponDiscount;
    notifyListeners();
  }
}
