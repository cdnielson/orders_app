import 'dart:core';
import 'dart:html';
import 'dart:convert';
import 'package:angular2/core.dart';
import 'package:orders2/model/orders.dart';
import 'package:orders2/model/rings.dart';
import 'package:orders2/model/users.dart';

@Component(selector: 'my-app', templateUrl: 'app_component.html')
class AppComponent {
  String get pathToPhpLoad => 'data/getOrders.php';
  String get pathToLoadOrderView => 'data/loadOrder.php';
  String get pathToSignature => 'data/signaturedownload.php';
  String get pathToSignOrder => 'data/sign.php';
  String get pathToOrder => 'data/email.php';
  String get pathToLogin => 'data/logins.json';
  String get pathToEmail => 'data/email.php';
  String get pathToPrint => 'data/print.php';
  String get pathToDeleteOrder => 'data/deleteOrder.php';
  String get pathToImages =>
      'http://lashbrookdesigns.com/sales/images/rings/thumbnails/';
  List<Order> orders;
  List<Order> showOrders = [];
  var selectedLabel;
  Map currentOrder = {};
  Map currentLogin;
  List<Map> removed = [];
  List<Map> added = [];
  List<Map> accessories = [];
  List<Map> customskus = [];
  List<Map> stockbalances = [];
  String acrylic;
  String top;
  String side;
  bool hideadded = true;
  bool hideremoved = true;
  bool hideaccessories = true;
  bool hidecustomdisplay = true;
  bool hidecustom = true;
  bool hidesb = true;
  String tier = "";
  //bool openLogIn = true;
  bool openEmail = false;
  String failedText = "";
  //String customerEmail = "";
  List<Map> orderList;
  List<Ring> tierRings = [];
  int selectedPage = 0;
  bool hideMenuIcon = true;
//  bool viewPrintDialog = false;
  final int tier1 = 4104;
  final int tier2 = 7291;
  final int tier3 = 10490;
  final int tier4 = 14153;
  final int tier4G = 14997;
  int totalCost = 0;
  int subTotalCost = 0;
  String rep;
  String idx = "1";
  String idxtoprint = "1";
  String idxToSend;
  String orderDeleteData;
  bool viewDeleteOrder = false;
  bool viewAreYouSure = false;
  bool hideSignature = true;
  int shipping = 0;
  bool hideIncomplete = true;
  bool hideSignIt = true;
  bool images = true;
  List<Map> mapListLogin;
  List<User> loginData;
  List<User> loginList;
  List<int> checkPin = [];
  String pin1;
  String pin2;
  String pin3;
  String pin4;
  List<bool> emails = [
    true, true, true, true, true, true, true, true, true, true];
  int currentHidden = 0;
  List emailList = [];
  StringBuffer sb = new StringBuffer();
  bool dataAvailable = false;
  bool showOrder = false;
  bool loggedIn = false;
  String pin = "";
  String email = "";
  String email_0 = "";
  String email_1 = "";
  String email_2 = "";
  String email_3 = "";
  String email_4 = "";
  String email_5 = "";
  String email_6 = "";
  String email_7 = "";
  String email_8 = "";
  String email_9 = "";
  String emailSuccess = "";

  AppComponent() {

    //HttpRequest.getString(pathToPhpLoad).then(onPHPDataLoaded);
    HttpRequest.getString(pathToLogin).then(loginLoaded);
  }

  void onPHPDataLoaded(String responseText) {
    orderList = JSON.decode(responseText);

    orders =
        orderList.map((Map element) => new Order.fromMap(element)).toList();

    orders.sort((Order a, Order b) {
      if (int.parse(a.order_idx) < int.parse(b.order_idx)) {
        return 1;
      }
      else if (int.parse(a.order_idx) > int.parse(b.order_idx)) {
        return -1;
      }
      return 0;
    });
    showOrders = orders;
    dataAvailable = true;
  }

  void orderClicked(id) {
      selectedLabel = id;
      findOrder();
  }

  void figureTier(currentTier) {
    if (currentTier == "1") {
      tier = "1";
    }
    if (currentTier == "2") {
      tier = "2";
    }
    if (currentTier == "3") {
      tier = "3";
    }
    if (currentTier == "4") {
      tier = "4";
    }
    if (currentTier == "5") {
      tier = "4 Guaranteed";
    }
    if (currentTier == "0") {
      tier = "No Tier";
    }
  }

  bool unhide(data) {
    if (data.isNotEmpty) {
      return true;
    }
    return false;
  }

  void loginLoaded(data) {
    mapListLogin = JSON.decode(data);
    loginData =
        mapListLogin.map((Map element) => new User.fromMap(element)).toList();

    loginList = loginData.toList();
    querySelector('#pin-input').focus();

  }

  void loadOrders() {
    HttpRequest.getString(pathToPhpLoad).then(onPHPDataLoaded);
  }


//  void handleKeyEventEmail(KeyboardEvent event) {
//    KeyEvent keyEvent = new KeyEvent.wrap(event);
//    if (keyEvent.keyCode == KeyCode.ENTER) {
//      emailOrder();
//    }
//  }

  void addEmail() {
    if (currentHidden < 10) {
      emails[currentHidden] = false;
      emailList.add("email$currentHidden");
      currentHidden++;
    }
  }

  void findOrder() {
    if (selectedLabel.isEmpty) {
      return;
    }
    var datatosend = JSON.encode(selectedLabel);
    HttpRequest.request(pathToLoadOrderView, method: 'POST',
        mimeType: 'application/json',
        sendData: datatosend).catchError((obj) {
      //print(obj);
    }).then((HttpRequest val) {
      //print('response: ${val.responseText}');
      currentOrder = JSON.decode(val.responseText);
      print(currentOrder);

      email = currentOrder['customer'][0]['email'];
      //tierRings = currentOrder['tierRings'].map((Map element) => new Ring.fromMap(element)).toList();
      //var sig = currentOrder['signature'];

      int sig = currentOrder['signature'];

      if (sig == 1) {
        idx = currentOrder['master'][0]['order_idx'];
      } else {
        idx = "1";
        idxToSend = currentOrder['master'][0]['order_idx'];
      }
      if (idx == "1") {
        hideIncomplete = false;
      }
      idxtoprint = currentOrder['master'][0]['order_idx'];
      rep = currentOrder['master'][0]['rep'];
      /*for (var r in removed) {
        tierRings.removeWhere((Ring element) => element.sku == r['sku']);
      }*/
      added = currentOrder['addedRings'];
      removed = currentOrder['removedRings'];
      accessories = currentOrder['addedAccessories'];
      customskus = currentOrder['custom'];
      stockbalances = currentOrder['stockbalances'];
      //date = currentOrder['master'[0]['date'];

      List customDisplay = [];

      customDisplay = (currentOrder["customDisplay"]);

      if (customDisplay.isNotEmpty) {
        acrylic = currentOrder["customDisplay"][0]["acrylic"];
        top = currentOrder["customDisplay"][0]["top"];
        side = currentOrder["customDisplay"][0]["side"];
        hidecustomdisplay = false;
      } else {
        hidecustomdisplay = true;
      }

      figureTier(currentOrder['master'][0]['tier']);
      int completed = int.parse(currentOrder['master'][0]['completed']);
      if (sig == 1) {
        hideSignature = false;
        hideIncomplete = true;
      } else {
        hideSignature = true;
        hideIncomplete = false;
      }
      calculateTotalCost();
      hideSignIt = true;


      if (unhide(added)) {
        hideadded = false;
      } else {
        hideadded = true;
      }
      if (unhide(removed)) {
        hideremoved = false;
      } else {
        hideremoved = true;
      }
      if (unhide(accessories)) {
        hideaccessories = false;
      } else {
        hideaccessories = true;
      }
      if (unhide(customskus)) {
        hidecustom = false;
      } else {
        hidecustom = true;
      }
      if (unhide(stockbalances)) {
        hidesb = false;
      } else {
        hidesb = true;
      }
      selectedPage = 1;
    }, onError: (e) => print("error"));
  }

  void emailOrder() {
    var idxtosend = currentOrder['master'][0]['order_idx'];


    List emailsToSend = [email];

    if (email_0 != "") {
      emailsToSend.add(email_0);
    }
    if (email_1 != "") {
      emailsToSend.add(email_1);
    }
    if (email_2 != "") {
      emailsToSend.add(email_2);
    }
    if (email_3 != "") {
      emailsToSend.add(email_3);
    }
    if (email_4 != "") {
      emailsToSend.add(email_4);
    }
    if (email_5 != "") {
      emailsToSend.add(email_5);
    }
    if (email_6 != "") {
      emailsToSend.add(email_6);
    }
    if (email_7 != "") {
      emailsToSend.add(email_7);
    }
    if (email_8 != "") {
      emailsToSend.add(email_8);
    }
    if (email_9 != "") {
      emailsToSend.add(email_9);
    }

    var dataToSend = {
      "emails" : emailsToSend,
      "idx" : idxtosend
    };

    var data = JSON.encode(dataToSend);
    print(data);
    HttpRequest.request(pathToEmail, method: 'POST',
        mimeType: 'application/json',
        sendData: data).catchError((obj) {
    }).then((HttpRequest val) {
      print("email success");
      emailSuccess = "Email sent!";
    }, onError: (e) => print("error"));
  }

  void getEmail() {
    if (currentOrder.isEmpty) {
      window.alert("You must select an order to send an email");
      return;
    }
    openEmail = true;
  }

  void closeEmail() {
    openEmail = false;
  }

  void deleteOrder() {
    orderDeleteData = currentOrder['master'][0]['order_idx'];
    viewDeleteOrder = true;
  }

  void actuallyDeleteIt() {
    viewDeleteOrder = false;
    viewAreYouSure = true;
  }

  void doNotDeleteIt() {
    viewDeleteOrder = false;
    if (viewAreYouSure) {
      viewAreYouSure = false;
    }
  }

  void actuallyDeleteItForRealThisTime() {
    doNotDeleteIt();
    var data = JSON.encode(orderDeleteData);
    HttpRequest.request(pathToDeleteOrder, method: 'POST',
        mimeType: 'application/json',
        sendData: data).catchError((obj) {

    }).then((HttpRequest val) {
      //not working for some reason.

      orders.removeWhere((Order element) => int.parse(element.order_idx) ==
          int.parse(orderDeleteData));
      showOrders = orders;
    }, onError: (e) => print("error"));
  }

  void onOrderDeleted() {

  }

  void filterOrder() {
    var filterOrder = querySelector('filterOrder');
    var temp = filterOrder.value.toUpperCase();
    if (temp != "" || temp.isNotEmpty || temp != null) {
      showOrders =
          orders.where((Order element) => element.order_idx.toUpperCase()
              .contains(temp) ||
              element.order_name.toUpperCase().contains(temp) ||
              element.rep.toUpperCase().contains(temp));
    } else {
      showOrders = orders;
    }
  }

  void printOrderWith() {
    images = true;
//    viewPrintDialog = false;
    //createPrint();
  }

  void printOrderWithout() {
    images = false;
//    viewPrintDialog = false;
    //createPrint();
  }

  void createPrint() {
    selectedPage = 3;
  }

  void createPrintold(images) {
    sb.writeln("<style>");
    sb.writeln(
        ".ringcontainer {float: left; text-align: center; border: 1px solid black; padding:3px; margin:2px;}");
    sb.writeln(".ringImage {width: 100px;}");
    sb.writeln("</style>");
    sb.writeln("<a href='javascript:window.print()'>Print</a>");

    sb.writeln("<div style='position: relative;'>");
    sb.writeln("<p>Order #: ");
    sb.writeln(currentOrder['master'][0]['order_idx']);

    sb.writeln("</p>");


    sb.writeln("This is an order for:<br>");

    sb.writeln("<p>Store Name: ");
    sb.write(currentOrder['customer'][0]['storeName']);
    sb.write("</p>");
    sb.writeln("<p>First Name: ");
    sb.write(currentOrder['customer'][0]['firstName']);
    sb.write("</p>");
    sb.writeln("<p>Last Name: ");
    sb.write(currentOrder['customer'][0]['lastName']);
    sb.write("</p>");
    sb.writeln("<p>Address: ");
    sb.write(currentOrder['customer'][0]['address']);
    sb.write("</p>");
    sb.writeln("<p>City: ");
    sb.write(currentOrder['customer'][0]['city']);
    sb.write("</p>");
    sb.writeln("<p>State: ");
    sb.write(currentOrder['customer'][0]['state']);
    sb.write("</p>");
    sb.writeln("<p>Phone: ");
    sb.write(currentOrder['customer'][0]['phone']);
    sb.write("</p>");
    sb.writeln("<p>E-mail: ");
    sb.write(currentOrder['customer'][0]['email']);
    sb.write("</p>");
    sb.writeln("<p>Terms: ");
    sb.write(currentOrder['customer'][0]['terms']);
    sb.write("</p>");
    sb.writeln("<p>Notes: ");
    sb.write(currentOrder['customer'][0]['notes']);
    sb.write("</p>");
    sb.writeln("<p>Tier: ");
    sb.write(tier);
    sb.write("</p>");

    sb.writeln("<p>The following rings have been removed:</p>");
    for (var r in removed) {
      sb.writeln(r['sku']);
      sb.write(" - ");
      sb.write(r['finish']);
      sb.write(" - ");
      sb.write(r['price']);
      sb.writeln("<br>");
    }
    sb.writeln("<p>The following rings have been added:</p>");
    for (var a in added) {
      sb.writeln(a['sku']);
      sb.write(" - ");
      sb.write(a['finish']);
      sb.write(" - ");
      sb.write(a['price']);
      sb.writeln("<br>");
    }
    sb.writeln("<p>The following accessories have been added:</p>");
    for (var a in accessories) {
      sb.writeln(a['sku']);
      sb.write(" - ");
      sb.write(a['finish']);
      sb.write(" - ");
      sb.write(a['price']);
      sb.writeln("<br>");
    }
    sb.writeln(
        "<p>The following additional (custom added skus) rings have been added:</p>");
    for (var c in customskus) {
      sb.writeln(c['sku']);
      sb.write(" - ");
      sb.write(c['finish']);
      sb.write(" - ");
      sb.write(c['price']);
      sb.writeln("<br>");
    }
    sb.writeln("<p>The following stockbalance(s) have been added:</p>");
    for (var s in stockbalances) {
      sb.writeln(s['id']);
      sb.write(" - ");
      sb.write(s['price']);
      sb.writeln("<br>");
    }
    sb.writeln("</div>");
    sb.writeln(
        "Order Total: $totalCost<br>(Note - does not include shipping costs)");
    sb.writeln("<div style='positions: absolute; width:100%;'>");

    if (images) {
      sb.writeln(
          "<p>Here are images of the rings in your order (not including custom added skus)</p>");
    } else {
      sb.writeln("<p>Here are the rings in your tier order</p>");
    }
    for (var t in tierRings) {
      if (images) {
        sb.writeln("<div class='ringcontainer'>");
        sb.writeln(
            "<img class='ringImage' src='$pathToImages" + t.image + "'/>");
        sb.write("<br>");
      }
      sb.write(t.sku);
      if (images) {
        sb.write("<br>");
      } else {
        sb.write(" - ");
      }
      sb.write(t.finish);
      if (images) {
        sb.write("<br>");
      } else {
        sb.write(" - ");
      }
      sb.write("\$" + t.price);
      if (images) {
        sb.writeln("</div>");
      } else {
        sb.writeln("<br>");
      }
    }
    for (var a in added) {
      if (images) {
        sb.writeln("<div class='ringcontainer'>");
        sb.writeln(
            "<img class='ringImage' src='$pathToImages" + a['image'] + "'/>");
        sb.write("<br>");

        sb.write(a['sku']);

        sb.write("<br>");
        sb.write(a['finish']);
        sb.write("<br>");
        sb.write("\$" + a['price']);
        sb.writeln("</div>");
      }
    }
    for (var a in accessories) {
      if (images) {
        sb.writeln("<div class='ringcontainer'>");
        sb.writeln(
            "<img class='ringImage' src='$pathToImages" + a['image'] + "'/>");
        sb.write("<br>");

        sb.write(a['sku']);

        sb.write("<br>");
        sb.write(a['finish']);
        sb.write("<br>");
        sb.write("\$" + a['price']);

        sb.writeln("</div>");
      }
    }
    sb.writeln("</div>");
    var dataToSend = {
      "name" : currentOrder['master'][0]['order_idx'],
      "body" : sb.toString()
    };
    sendDataForPrint(dataToSend);
  }

  void sendDataForPrint(dataToSend) {
    var data = JSON.encode(dataToSend);
    HttpRequest.request(pathToPrint, method: 'POST',
        mimeType: 'application/json',
        sendData: data).catchError((obj) {

    }).then((HttpRequest val) {
      var orderName = dataToSend['name'];
      window.location.href =
      'http://www.lashbrookdesigns.com/orders/data/orderbackup/$orderName.html';
    }, onError: (e) => print("error"));
  }

  void showPrintDialog() {
    if (currentOrder.isEmpty) {
      window.alert("You must select an order to print");
      return;
    }
    //viewPrintDialog = true;
  }

  void cancelPrint() {
    //viewPrintDialog = false;
  }

  void newTab(tab) {
    selectedPage = tab;
    if (tab == 3) {
      //viewPrintDialog = true;
    }
    if (tab == 5) {
      deleteOrder();
      selectedPage = 1;
    }
  }

  void calculateTotalCost() {

    subTotalCost = 0;

    for (var a in added) {
      subTotalCost += int.parse(a['price']);
    }

    for (var a in accessories) {
      subTotalCost += int.parse(a['price']);
    }
    for (var c in customskus) {
      subTotalCost += int.parse(c['price']);
    }

    for (var s in stockbalances) {
      subTotalCost += int.parse(s['price']);
    }

    if (subTotalCost < 3001) {
      shipping = 20;
    }
    if (subTotalCost > 3000 && subTotalCost < 6001) {
      shipping = 35;
    }
    if (subTotalCost > 6000 && subTotalCost < 10001) {
      shipping = 50;
    }
    if (subTotalCost > 10000) {
      shipping = 75;
    }

    totalCost = subTotalCost + shipping;
  }

  void signOrder() {
    hideSignIt = false;
    hideSignature = true;
    hideIncomplete = true;
  }

  void scroll() {
    var scaffold = querySelector('scaffold');
    scaffold.scrollTop = 0;
  }

  //TODO set focus on pin

  void checkPinInput() {
    //print($['pin'].value);
/*    String temp = pin.value;
    int length = temp.length*/;
    //print(length);
    try {
      checkPin = [pin[0], pin[1], pin[2], pin[3]];
    } catch (exception, stackTrace) {
      return;
    }
    for (User p in loginData) {
      if (checkPin.toString() == p.pin.toString()) {
        logIn();
      }
    }
  }

  void logIn() {
    loggedIn = true;
    loadOrders();
  }

  void toggleImages() {
    images = !images;
  }

  void numpadAction(String data) {
    pin = pin + data;
    checkPinInput();
  }
}
