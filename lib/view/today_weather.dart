import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:weather/bloc/weather_bloc.dart';
import 'package:weather/wind_icons.dart';

class TodayWeather extends StatefulWidget {

  final String cityName;
  TodayWeather(this.cityName);

  @override
  _TodayWeatherState createState() => _TodayWeatherState(cityName);
}

class _TodayWeatherState extends State<TodayWeather> {

  final String cityName;

  _TodayWeatherState(this.cityName);

  @override
  Widget build(BuildContext context) {

    final weatherBloc = BlocProvider.of<WeatherBloc>(context);
    weatherBloc.add(FetchWeatherWithCityNameEvent(cityName));

    return BlocBuilder<WeatherBloc, WeatherState>(builder: (context, state){
      if (state is WeatherLoadingState){
        return Center(child: CircularProgressIndicator());
      }
      if (state is WeatherIsLoadedState){

        var fm = new DateFormat('HH:mm a');
        var temp = state.getWeather.main.temp;
        var name = state.getWeather.name;
        var weather = state.getWeather.weather;
        var pressure = state.getWeather.main.pressure;
        var humidity = state.getWeather.main.humidity;
        var maxTemp = state.getWeather.main.tempMax;
        var minTemp = state.getWeather.main.tempMin;
        var wind = state.getWeather.wind.speed;
        var sunrise = state.getWeather.sys.sunrise;
        var sunset = state.getWeather.sys.sunset;

        // addDoubleToSF(lat,lon);
        return Column(
          children: [
            Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: EdgeInsets.only(
                    left: MediaQuery.of(context).size.height/50,
                    top: MediaQuery.of(context).size.height/50,
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Icon(Icons.location_on, color: Colors.white, size: 20,),
                          SizedBox(width: MediaQuery.of(context).size.height/150,),
                          Text(name, style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.w300),),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            left: MediaQuery.of(context).size.height/30
                        ),
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: Text('${new DateFormat.yMMMMd().format(DateTime.now())}',
                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.w300, fontSize: 12)),
                        ),
                      )
                    ],
                  ),
                )
            ),
            Padding(
              padding: EdgeInsets.only(
                left: MediaQuery.of(context).size.height / 8,
                top: MediaQuery.of(context).size.height / 50,
              ),
              child: Row(
                children: <Widget>[
                    SvgPicture.asset(
                        "assets/svgs/"+"${weather[0].icon}"+".svg", width: 70.0,),
                  // Image.network(
                  //     'https://api.openweathermap.org/img/w/${weather[0].iconCode}.png'),),
                  SizedBox(
                    width: MediaQuery.of(context).size.height / 80,
                  ),
                  Column(
                    children: [
                      Text(
                        '${weather[0].main}',
                        style: TextStyle(color: Colors.white),
                      ),
                      Text(
                        '${weather[0].description}',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height/50,
                  bottom: MediaQuery.of(context).size.height/120),
              child: Text(
                fahrenheitToCelsius(temp).toString() + '°C',
                style: TextStyle(fontSize: 80, color: Colors.white, fontWeight: FontWeight.w100),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).size.height/20),
              child: Container(
                width: MediaQuery.of(context).size.height/2,
                height: MediaQuery.of(context).size.height/10,
                child: Padding(
                  padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height/90,
                      bottom: MediaQuery.of(context).size.height/90
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(
                                    top: MediaQuery.of(context).size.height/200,
                                    left: MediaQuery.of(context).size.height/500),
                                child: Align(
                                  alignment: Alignment.topLeft,
                                  child: Container(
                                    height: MediaQuery.of(context).size.height/40,
                                    width: MediaQuery.of(context).size.height/40,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(50.0),
                                      border: Border.all(color: Colors.redAccent),
                                      color: Colors.grey[850],
                                    ),
                                    child: Padding(
                                        padding: EdgeInsets.only(
                                          top: MediaQuery.of(context).size.height/300,),
                                        child: Column(
                                          children: [
                                            Icon(Icons.arrow_downward, size: 6, color: Colors.redAccent,),
                                            Icon(Icons.waves, size: 6, color: Colors.redAccent,),
                                          ],
                                        )
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                    top: MediaQuery.of(context).size.height/200,
                                    left: MediaQuery.of(context).size.height/150),
                                child: Align(
                                    alignment: Alignment.topCenter,
                                    child: Text(pressure.toString(),style: TextStyle(color: Colors.white, fontWeight: FontWeight.w300,
                                        fontSize: 13))),
                              ),
                              Align(
                                  alignment: Alignment.topCenter,
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                        top: MediaQuery.of(context).size.height/200,
                                        left: MediaQuery.of(context).size.height/150),
                                    child: Text('hpa',
                                      style: TextStyle(color: Colors.white,
                                          fontWeight: FontWeight.w300,
                                          fontSize: 13),),
                                  )
                              ),
                            ],
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                left: MediaQuery.of(context).size.height/50),
                            child: Row(
                              children: [
                                Icon(Icons.opacity, color: Colors.blue,),
                                Align(
                                    alignment: Alignment.bottomLeft,
                                    child: Text('humidity  $humidity %' ,
                                      style: TextStyle(color: Colors.white,
                                          fontWeight: FontWeight.w300,
                                          fontSize: 13),)),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(width: MediaQuery.of(context).size.height/40,),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                              top: MediaQuery.of(context).size.height/200,),
                            child: Row(
                              children: [
                                Icon(Icons.arrow_upward_sharp, color: Colors.red, size: 18,),
                                SizedBox(width: MediaQuery.of(context).size.height/100,),
                                Text('${fahrenheitToCelsius(maxTemp)}°C',
                                  style: TextStyle(color: Colors.white,
                                      fontWeight: FontWeight.w300,
                                      fontSize: 13),),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                              top: MediaQuery.of(context).size.height/200,),
                            child: Row(
                              children: [
                                Icon(Icons.arrow_downward, color: Colors.blue, size: 18),
                                SizedBox(width: MediaQuery.of(context).size.height/100,),
                                Text('${fahrenheitToCelsius(minTemp)}°C',
                                  style: TextStyle(color: Colors.white,
                                      fontWeight: FontWeight.w300,
                                      fontSize: 13),),
                              ],
                            ),
                          )
                        ],
                      ),
                      SizedBox(width: MediaQuery.of(context).size.height/25,),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                              top: MediaQuery.of(context).size.height/200,),
                            child: Row(
                              children: [
                                Icon(WindIcon.wind, color: Colors.blue[300],),
                                SizedBox(width: MediaQuery.of(context).size.height/200,),
                                Text('Wind', style: TextStyle(color: Colors.white,
                                    fontSize: 13, fontWeight: FontWeight.w300),),
                                SizedBox(width: MediaQuery.of(context).size.height/100,),
                                Text('$wind',
                                  style: TextStyle(color: Colors.white,
                                      fontSize: 13, fontWeight: FontWeight.w300),),
                                SizedBox(width: MediaQuery.of(context).size.height/120,),
                                Text('m/s', style: TextStyle(color: Colors.white,
                                    fontSize: 13, fontWeight: FontWeight.w300))
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                              top: MediaQuery.of(context).size.height/200,),
                            child: Row(
                              children: [
                                Icon(Icons.wb_sunny, color: Colors.orange,),
                                SizedBox(width: MediaQuery.of(context).size.height/200,),
                                Text('${ DateFormat('h:m a').format(DateTime.fromMicrosecondsSinceEpoch(sunrise))}', style: TextStyle(color: Colors.white,
                                    fontSize: 13, fontWeight: FontWeight.w300),),
                              ],
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
                color: Colors.grey[850],),
            )
          ],
        );
      }
      if (state is WeatherIsNotLoadedState){
        return Text(
          'City not Found',
          style: TextStyle(fontSize: 25, color: Colors.white),
        );
      }
      return Text("Nothing", style: TextStyle(fontSize: 25, color: Colors.white));
    });
  }


  fahrenheitToCelsius( double degree ){
    int celsious = (degree - 273.15).toInt();
    return celsious;
  }

}
