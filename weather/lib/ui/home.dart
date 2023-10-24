import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:weather/models/city.dart';
import 'package:weather/models/constants.dart';
import 'package:weather/widgets/weather_item.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Constants myConstants = Constants();

  //initiatilization
  int temperature = 0;
  int maxTemp = 0;
  String weatherStateName = 'Loading..';
  int humidity = 0;
  int windSpeed = 0;
  int feelsLike = 0;
  int minTemp = 0;
  int pressureMM = 0;
  String image = '';


  var currentDate = 'Loading..';
  String location = 'Барнаул';

  var selectedCities = City.getSelectedCities();
  List<String> cities = [
    'Барнаул'
  ];

  List consolidatedWeatherList = []; //To hold our weather data after api call

  String filterCondition(String condition) {
    switch (condition) {
    case "clear":
      return "Ясно";
    case "partly-cloudy":
      return "Переменная облачность";
    case "cloudy":
      return "Облачно";
    case "overcast":
      return "Пасмурно";
    case "drizzle":
      return "Легкий дождь";
    case "light-rain":
      return "Легкий дождь";
    case "rain":
      return "Дождь";
    case "moderate-rain":
      return "Умеренный дождь";
    case "heavy-rain":
      return "Сильный дождь";
    case "continuous-heavy-rain":
      return "Сильный дождь";
    case "showers":
      return "Ливень";
    case "wet-snow":
      return "Легкий снег";
    case "light-snow":
      return "Легкий снег";
    case "snow":
      return "Снег";
    case "snow-showers":
      return "Снегопад";
    case "hail":
      return "Град";
    case "thunderstorm":
      return "Гроза";
    case "thunderstorm-with-rain":
      return "Дождь с грозой";
    case "thunderstorm-with-hail":
      return "Град с грозой";
    default:
      return "";
    }
  }

  //Получение погоды
  void fetchWeatherData(String newCity) async {
    double lat = 0;
    double lon = 0;

    //ищем город и потом делаем запрос
    for (int i = 0; i < 4; i++) {
      if (newCity == City.citiesList[i].city) {
        lat = City.citiesList[i].lat;
        lon = City.citiesList[i].lon;
      }
    }

    var searchWeatherUrl = 'https://api.weather.yandex.ru/v2/forecast?lat=$lat&lon=$lon';
    print(searchWeatherUrl);
    var weatherResult =
    await http.get(Uri.parse(searchWeatherUrl), headers: {'X-Yandex-API-Key': '91f75775-0510-4c60-aa63-70aaa9a097ac'});
    var result = json.decode(utf8.decode(weatherResult.bodyBytes));

    setState(() {

      //заполнение данными
      temperature = result['fact']['temp'];
      windSpeed = result['fact']['wind_speed'].toInt();
      humidity = result['fact']['humidity'];
      maxTemp = result['forecasts'][0]['parts']['day']['temp_max'];
      weatherStateName = filterCondition(result['fact']['condition']);
      minTemp = result['forecasts'][0]['parts']['day']['temp_min'];
      feelsLike = result['fact']['feels_like'];
      pressureMM = result['fact']['pressure_mm'].toInt();
      currentDate = result['now_dt'].substring(0, 10);
      image = result['fact']['icon'];

    });


  }


  @override
  void initState() {
    fetchWeatherData('Барнаул');

    for (int i = 0; i < selectedCities.length; i++) {
      cities.add(selectedCities[i].city);
    }
    super.initState();
  }

  final Shader linearGradient = const LinearGradient(
    colors: <Color>[Color(0xffABCFF2), Color(0xff9AC6F3)],
  ).createShader(const Rect.fromLTWH(0.0, 0.0, 200.0, 70.0));

  @override
  Widget build(BuildContext context) {

    Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: false,
        titleSpacing: 0,
        backgroundColor: Colors.white,
        elevation: 0.0,
        title: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          width: size.width,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/pin.png',
                    width: 20,
                  ),
                  const SizedBox(
                    width: 4,
                  ),
                  DropdownButtonHideUnderline(
                    child: DropdownButton(
                        value: location,
                        icon: const Icon(Icons.keyboard_arrow_down),
                        items: cities.map((String location) {
                          return DropdownMenuItem(
                              value: location, child: Text(location));
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            location = newValue!;
                            fetchWeatherData(newValue!);
                          });
                        }),
                  )
                ],
              )
            ],
          ),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              location,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 30.0,
              ),
            ),
            Text(
              currentDate,
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 16.0,
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            Container(
              width: size.width,
              height: 200,
              decoration: BoxDecoration(
                  color: myConstants.primaryColor,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: myConstants.primaryColor.withOpacity(.5),
                      offset: const Offset(0, 25),
                      blurRadius: 10,
                      spreadRadius: -12,
                    )
                  ]),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Positioned(
                    top: 15,
                    left: 20,
                    child: image == ''
                        ? const Text('')
                        : Image.asset(
                            'assets/' + image + '.png',
                            width: 110,
                          ),
                  ),
                  Positioned(
                    bottom: 30,
                    left: 20,
                    child: Text(
                      weatherStateName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 20,
                    right: 20,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 4.0),
                          child: Text(
                            temperature.toString(),
                            style: TextStyle(
                              fontSize: 80,
                              fontWeight: FontWeight.bold,
                              foreground: Paint()..shader = linearGradient,
                            ),
                          ),
                        ),
                        Text(
                          'o',
                          style: TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                            foreground: Paint()..shader = linearGradient,
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  weatherItem(
                    text: 'Скорость ветра',
                    value: windSpeed.toInt(),
                    unit: 'km/h',
                    imageUrl: 'assets/windspeed.png',
                  ),
                  weatherItem(
                      text: 'Влажность',
                      value: humidity,
                      unit: '',
                      imageUrl: 'assets/humidity.png'),
                  weatherItem(
                    text: 'Ощущается как',
                    value: feelsLike,
                    unit: 'C',
                    imageUrl: 'assets/max-temp.png',
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  weatherItem(
                      value: minTemp,
                      text: 'Мин темп',
                      unit: 'С',
                      imageUrl: 'assets/sleet.png'
                  ),
                  weatherItem(
                      value: maxTemp,
                      text: 'Мак темп',
                      unit: 'С',
                      imageUrl: 'assets/max-temp.png'
                  ),
                  weatherItem(
                      value: pressureMM.toInt(),
                      text: 'Давление',
                      unit: ' ММ',
                      imageUrl: 'assets/get-started.png'
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}
