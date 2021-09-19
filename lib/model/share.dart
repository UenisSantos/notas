import 'package:flutter_share_me/flutter_share_me.dart';
import 'package:multiselect_scope/multiselect_scope.dart';
import 'package:nota_diaria/view/Home.dart';

class Share {
  MultiselectController multiselectController = MultiselectController();
  Home home;
  
  shareToSystem() async{
    var response =  await FlutterShareMe().shareToSystem(
        msg: multiselectController.getSelectedItems().toString());
    if (response == 'success') {}
  }

  shareToWhatsApp() async {
    var response = await FlutterShareMe().shareToWhatsApp(
        msg: multiselectController.getSelectedItems().toString());

    if (response == 'success') {}
  }
}
