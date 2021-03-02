import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class PowerData {}

class HomePage extends StatelessWidget {
  const HomePage({Key key}) : super(key: key);

  Future<String> fetch() async {
    // final uri = Uri.http("power.larc.nasa.gov", "/cgi-bin/v1/DataAccess.py", {
    //   "request": "execute",
    //   "tempAverage": "DAILY",
    //   "identifier": "SinglePoint",
    //   "parameters": "ALLSKY_SFC_SW_DWN",
    //   "userCommunity": "SSE",
    //   "lon": "0",
    //   "lat": "0",
    //   "startDate": "2016",
    //   "endDate": "2017",
    //   "outputList": "JSON",
    //   "user": "DOCUMENTATION"
    // });
    // final response1 = await http.get(uri);
    final uri = Uri.https("re.jrc.ec.europa.eu", "/api/PVcalc", {
      "lat": "45",
      "lon": "8",
      "peakpower": "1",
      "loss": "14",
      "outputformat": "json"
    });
    print("Uri: $uri");
    final response1 = await http.get(uri);
    //"?&request=execute&tempAverage=INTERANNUAL&identifier=SinglePoint&parameters=T2M
    //&userCommunity=SB&lon=0&lat=0&startDate=2016&endDate=2017&outputList=JSON&user=DOCUMENTATION");

    return response1.body;
  }

  @override
  Widget build(BuildContext context) {
    return Center(child: Text("Hello"));
  }
}
