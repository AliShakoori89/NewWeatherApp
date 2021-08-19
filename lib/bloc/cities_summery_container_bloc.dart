import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather/models/city_model.dart';
import 'package:weather/models/weather_model.dart';
import 'package:weather/networking/http_exception.dart';
import 'package:weather/repositories/weather_repository.dart';

class CitiesWeathersSummeryEvent extends Equatable {
  @override

  List<Object> get props => [];
}

class CitiesWeathersSummeryState extends Equatable {
  @override

  List<Object> get props => throw[];
}

class UpdateCitiesWeathersSummeryIsLoadedState extends CitiesWeathersSummeryState{
  final WeatherModel _weather;

  UpdateCitiesWeathersSummeryIsLoadedState(this._weather);

  WeatherModel get getWeather => _weather;


  @override
  List<Object> get props => [_weather];
}

class CitiesWeathersSummeryIsLoadedState extends CitiesWeathersSummeryState {
  final citiesWeather;

  CitiesWeathersSummeryIsLoadedState(this.citiesWeather);

  List<CityModel> get getCitiesWeathers => citiesWeather;

  @override
  List<Object> get props => [citiesWeather];
}

class CitiesWeathersSummeryIsNotLoadedState extends CitiesWeathersSummeryState{}

class CitiesWeathersSummeryIsLoadingState extends CitiesWeathersSummeryState {}

class SaveCityWeathersEvent extends CitiesWeathersSummeryEvent{
  final CityModel cityWeathers;

  SaveCityWeathersEvent(this.cityWeathers);

  @override
  List<Object> get props => [cityWeathers];
}

class FetchAllDataEvent extends CitiesWeathersSummeryEvent{}

class FetchWeatherWithCityNameForUpdateEvent extends CitiesWeathersSummeryEvent{
  final String cityName;

  FetchWeatherWithCityNameForUpdateEvent(this.cityName);

  @override
  List<Object> get props => [cityName];
}

class DeleteCityForWeatherEvent extends CitiesWeathersSummeryEvent {
  final String cityName;

  DeleteCityForWeatherEvent(this.cityName);

  @override
  List<Object> get props => [cityName];
}

class UpdateCityWeatherEvent extends CitiesWeathersSummeryEvent{
  final CityModel cityWeathers;

  UpdateCityWeatherEvent(this.cityWeathers);

  @override
  List<Object> get props => [cityWeathers];
}

class WeatherError extends CitiesWeathersSummeryState {
  final int errorCode;

  WeatherError(this.errorCode);

}


class CitiesWeathersSummeryBloc extends Bloc<CitiesWeathersSummeryEvent, CitiesWeathersSummeryState>{
  WeatherRepository weatherRepository;

  CitiesWeathersSummeryBloc(this.weatherRepository) : super(CitiesWeathersSummeryState());

  @override
  Stream<CitiesWeathersSummeryState> mapEventToState(CitiesWeathersSummeryEvent event) async*{
    if(event is SaveCityWeathersEvent){
      await weatherRepository.saveCityWeatherDetailesRepo(event.cityWeathers);
    }

    if(event is DeleteCityForWeatherEvent){
      await weatherRepository.deleteCityWeatherDetailesRepo(event.cityName);
      List<CityModel> contacts = await weatherRepository.fetchAllDataCityWeatherRepo();
      yield CitiesWeathersSummeryIsLoadedState(contacts);
    }

    if(event is FetchAllDataEvent){
      List<CityModel> citiesWeather = await weatherRepository.fetchAllDataCityWeatherRepo();
      yield CitiesWeathersSummeryIsLoadedState(citiesWeather);
    }

    if (event is UpdateCityWeatherEvent) {
      print(event.cityWeathers);
      await weatherRepository.updateCityWeatherRepo(event.cityWeathers);
      yield CitiesWeathersSummeryIsLoadedState(event.cityWeathers);
    }

    if (event is FetchWeatherWithCityNameForUpdateEvent) {
      print(1);
      yield CitiesWeathersSummeryIsLoadingState();
      print(2);
      try {
        print(3);
        final WeatherModel weather = await weatherRepository.getWeatherWithCityName(
          event.cityName,
        );
        print(4);
       // yield UpdateCitiesWeathersSummeryIsLoadedState(weather);
        yield CitiesWeathersSummeryIsLoadingState();

        print(5);
      } catch (exception) {
        print(6);
        print(exception);
        if (exception is AppException) {
          print(7);
          yield WeatherError(300);
        } else {
          print(8);
          yield WeatherError(500);
        }
      }
    }
  }
}