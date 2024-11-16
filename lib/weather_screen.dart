
import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:weather_app/additional_info_item.dart';
import 'package:weather_app/hourly_forecast.dart';
import 'package:http/http.dart' as http;
import 'package:weather_app/secrets.dart';
import 'package:intl/intl.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  late Future<Map<String,dynamic>> weather;
    
 

  Future<Map<String,dynamic>> getCurrentWeather() async {
    try {
  String cityName="Ghaziabad";
  final res=await http.get(
    Uri.parse(
      "https://api.openweathermap.org/data/2.5/forecast?q=$cityName&APPID=$openWeatherAPIKey"
    ),
  );

  final data=jsonDecode(res.body);

  if(data["cod"]!="200"){

    throw "An unexpected error occured";

  }

  return data;

} on Exception catch (e) {
  
  throw e.toString();
}





  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    weather=getCurrentWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Weather App",
        style: TextStyle(
          fontWeight: FontWeight.bold
        ),
        ),
        centerTitle: true,
        actions: [
          IconButton(onPressed: (){
            setState(() {
              weather=getCurrentWeather();
            });
          }, icon: const Icon(Icons.refresh))
          // Gesture
          //Detector(child: const Icon(Icons.refresh),
          // onTap: () {
          //   print("refresh");
          // },)
        ],
        
      ),
      body:  FutureBuilder(
        future: weather,
        builder:(context,snapshot) {

          if(snapshot.connectionState==ConnectionState.waiting){
            return const Center(child: CircularProgressIndicator.adaptive());
          }

          if(snapshot.hasError){
            return Center(child: Text(snapshot.error.toString()));
          }

          final data=snapshot.data!;

          final correctTemp=data["list"][0]["main"]["temp"];
          final currentSky=data["list"][0]["weather"][0]["main"];
          final currentPressure=data["list"][0]["main"]["pressure"];
          final currentWindSpeed=data["list"][0]["wind"]["speed"];
          final currentHumidity=data["list"][0]["main"]["humidity"];
          return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment:CrossAxisAlignment.start,
            
            children: [
          
              //main card
          
              // const Placeholder(
              //   fallbackHeight: 250,
              // ),
          
              SizedBox(
                width: double.infinity,
                child: Card(
        
                  elevation: 10,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10,sigmaY: 10),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            Text("$correctTemp K",
                            style: const TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                            ),
                            ),
                             const SizedBox(height: 20 ),
                            Icon(currentSky=="Clouds" || currentSky=="Rain"?
                            Icons.cloud:Icons.sunny,
                            size: 60,),
                            const  SizedBox(height: 10 ),
                             Text(currentSky,
                            style:const  TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold
                            ),)
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
          
              const SizedBox(height: 15),
        
        
              const Text("Weather Forecast",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold
              ),
              ),
        
              const SizedBox(height:15),
        
              //   SingleChildScrollView(
              //   scrollDirection: Axis.horizontal,
              //    child: Row(
              //     children: [

              //       for(int i=0;i<39;i++)
              //         HourlyForecast(
              //         icon: data['list'][i+1]['weather'][0]['main']=="Clouds" || data['list'][i+1]['weather'][0]['main']=="Rain"?
              //         Icons.cloud:Icons.sunny,
              //         time: data['list'][i+1]['dt'].toString(),
              //         temperature: data['list'][i+1]['main']['temp'].toString(),
              //           ),
                      

                    

                    
                       

                    
                 
                    
                    
                    
                    
                    
              //     ],
              //                ),
              //  ),

              SizedBox(
                height: 120,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 5,
                  itemBuilder: (context,index){
                    final hourlyWeather=data['list'][index+1];
                    


                    final time=DateTime.parse(hourlyWeather['dt_txt']);

                
                    return HourlyForecast(
                      time: DateFormat.Hm().format(time),
                       temperature: hourlyWeather['main']['temp'].toString(),
                        icon: hourlyWeather['weather'][0]['main']=="Rain" || hourlyWeather['weather'][0]['main']=="Clouds"?
                        Icons.cloud:
                        Icons.sunny);
                  }
                  ),
              ),
                
          
              //weather forecast card
          
              
          
              const SizedBox(height: 15),
              
          
              const SizedBox(height: 16,),
              const Text("Additional Information",
               style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold
              ),
              ),
              const SizedBox(height: 16,),
               Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children:  [
                   AdditionalInfoItem(
                    icon: Icons.water_drop,
                    label: "Humidity",
                    value: currentHumidity.toString(),
                    
                  ),
                  AdditionalInfoItem(
                    icon: Icons.air,
                    label: "Wind Speed",
                    value: currentWindSpeed.toString(),
                    
                  ),
                  AdditionalInfoItem(
                    icon: Icons.beach_access,
                    label: "Pressure",
                    value: currentPressure.toString(),
                    
                  ),
                  
                ],
              )
          
          
            ],
          ),
        );
        },
      ),
    );
  }
}



