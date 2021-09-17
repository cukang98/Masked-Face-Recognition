import 'package:face_net_authentication/pages/utils/requestassistant.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:developer';

class AssistantMethods{
  static Future<String> searchCoordinateAddress(Position position) async{
    String placeAddress = "";
    Uri url = Uri.parse("https://us1.locationiq.com/v1/reverse.php?key=pk.756a7c6dad10ea82858075d4459c5acd&lat=${position.latitude}&lon=${position.longitude}&format=json");
    print(url.toString());
    var response = await RequestAssistant.getRequest(url);

    if(response != null){
      inspect(response['address']['road']);
      placeAddress = "${response['address']['road']}, ${response['address']['suburb']}, ${response['address']['region']}, ${response['address']['state']}";
    }
    return placeAddress;
  }
}