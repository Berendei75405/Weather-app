
import 'dart:ffi';

class City {
  bool isSelected;
  String city;
  bool isDefault;
  double lat;
  double lon;

  City({required this.isSelected, required this.city, required this.isDefault, required this.lat, required this.lon});

  //Список городов на стартовом экране
  static List<City> citiesList = [
    City(
      isSelected: false,
      city: 'Барнаул',
      isDefault: true,
      lat: 53.34,
      lon: 83.74,
    ),
    City(
      isSelected: false,
      city: 'Томск',
      isDefault: false,
      lat: 56.50,
      lon: 84.95,
    ),
    City(
      isSelected: false,
      city: 'Новосибирск',
      isDefault: false,
      lat: 55.01,
      lon: 82.92,
    ),
    City(isSelected: false,
      city: "Омск",
      isDefault: false,
      lat: 54.97,
      lon: 73.41,
    )
  ];

  //Получить выбранные города
  static List<City> getSelectedCities(){
    List<City> selectedCities = City.citiesList;
    return selectedCities
        .where((city) => city.isSelected == true)
        .toList();
  }
}