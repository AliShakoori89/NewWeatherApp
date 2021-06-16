import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:weather/bloc/hourly_weather_bloc.dart';
import 'package:weather/bloc/weather_bloc.dart';
import 'package:weather/repositories/weather_repository.dart';
import 'package:weather/view/daily_weak_weathers_with_city_name.dart';
import 'dart:ui' as ui;
import 'package:weather/view/hourly_week_weathers_with_city_name.dart';
import 'package:weather/view/today_weather_with_city_name.dart';


class CityWeatherDetailsWithName extends StatefulWidget {

  final String cityName;

  CityWeatherDetailsWithName(this.cityName);

  @override
  _CityWeatherDetailsWithNameState createState() => _CityWeatherDetailsWithNameState(cityName);
}

class _CityWeatherDetailsWithNameState extends State<CityWeatherDetailsWithName> {

  final String cityName;
  _CityWeatherDetailsWithNameState(this.cityName);

  @override
  Widget build(BuildContext context) {

    DateTime now = DateTime.now();
    String formattedTime = DateFormat('kk').format(now);

    return Scaffold(
      backgroundColor: Colors.black,
      body: MultiBlocProvider(
        providers: [
          BlocProvider (
              create: (BuildContext context) => WeatherBloc (WeatherRepository())),
          BlocProvider(
              create: (BuildContext context) => WeatherDetailsBloc(WeatherRepository())),
        ],
        child: SafeArea(
            child: Container(
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage( ( int.parse(formattedTime) < 18)
                        ? 'assets/images/sunny.png'
                        : 'assets/images/night.png'),
                    fit: BoxFit.fill,
                    colorFilter: new ColorFilter.mode(Colors.black.withOpacity(0.7), BlendMode.dstATop),
                  )
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height/20,
                        left: MediaQuery.of(context).size.height/50,
                        right: MediaQuery.of(context).size.height/50,
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.grey[900].withOpacity(0.5),
                            borderRadius: BorderRadius.circular(25)
                        ),
                        width: MediaQuery.of(context).size.height,
                        height: MediaQuery.of(context).size.height/1.98,
                        child: Directionality(
                          textDirection: ui.TextDirection.ltr,
                          child: TodayWeatherWithCityName(cityName),
                        ),
                      ),
                    ),
                    Padding(
                        padding: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height/40,
                          left: MediaQuery.of(context).size.height/50,
                          right: MediaQuery.of(context).size.height/50,
                          // bottom: MediaQuery.of(context).size.height/20,
                        ),
                        child: Container(
                            decoration: BoxDecoration(
                                color: Colors.grey[900].withOpacity(0.5),
                                borderRadius: BorderRadius.circular(25)),
                            width: MediaQuery.of(context).size.height,
                            height: MediaQuery.of(context).size.height/5,
                            child: Column(
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(
                                    top: MediaQuery.of(context).size.height / 50,
                                    left: MediaQuery.of(context).size.height / 50,
                                  ),
                                  child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        'HOURLY',
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 13.0),
                                      )),
                                ),
                                Expanded(child: HourlyWeekWeathersWithCityName(cityName))
                              ],
                            )
                        )
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height/40,
                        left: MediaQuery.of(context).size.height/50,
                        right: MediaQuery.of(context).size.height/50,
                        // bottom: MediaQuery.of(context).size.height/20,
                      ),
                      child: Container(
                          decoration: BoxDecoration(
                              color: Colors.grey[900].withOpacity(0.5),
                              borderRadius: BorderRadius.circular(25)),
                          width: MediaQuery.of(context).size.height,
                          height: MediaQuery.of(context).size.height / 3.5,
                          child: Column(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(
                                  top: MediaQuery.of(context).size.height / 50,
                                  left: MediaQuery.of(context).size.height / 50,
                                ),
                                child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      'DAILY',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 13.0),
                                    )),
                              ),
                              Expanded(child: DailyWeekWeathersWithCityName(cityName)),
                            ],
                          )
                      ),
                    ),
                    SizedBox(
                        height: MediaQuery.of(context).size.height / 50
                    )
                  ],
                ),
              ),
            )
        )
      )
    );
  }
}

