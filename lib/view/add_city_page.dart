import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:intl/intl.dart';
import 'package:geolocator/geolocator.dart' as Geo;
import 'package:shape_of_view/shape_of_view.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:weather/bloc/cities_summery_container_bloc.dart';
import 'package:weather/bloc/weather_bloc.dart';
import 'package:weather/view/city_weather_details_with_citylocation.dart';
import 'package:weather/view/city_weather_details_with_cityname.dart';
import 'dart:ui' as ui;

class AddCityPage extends StatefulWidget {
  const AddCityPage({Key key}) : super(key: key);

  @override
  _AddCityPageState createState() => _AddCityPageState();
}

class _AddCityPageState extends State<AddCityPage> {

  String formattedTime = DateFormat('kk').format(DateTime.now());
  FocusNode focusNode = FocusNode();
  String hintText = 'Search city';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    focusNode.addListener(() {
      if (focusNode.hasFocus) {
        hintText = '';
      } else {
        hintText = 'Search city';
      }
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
            // color: Colors.white,
            image: DecorationImage(
          image: AssetImage((int.parse(formattedTime) < 18)
              ? 'assets/images/sunny.png'
              : 'assets/images/night.png'),
          fit: BoxFit.fill,
        )),
        child: SearchPage(hintText, focusNode),
      ),
    );
  }
}

class SearchPage extends StatefulWidget {
  final String hintText;
  FocusNode focusNode;

  SearchPage(this.hintText, this.focusNode);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {

  var position = new Geo.Position();
  final TextEditingController cityNameController = TextEditingController ();
  Geo.Position _currentPosition;
  final Location location = Location (
  );

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now ();
    String formattedTime = DateFormat ('kk').format (now);

    final citiesWeathersSummeryBloc = BlocProvider.of<CitiesWeathersSummeryBloc> (context);
    citiesWeathersSummeryBloc.add (FetchAllDataEvent ());

    return Column (
      children: [
        SizedBox (height: MediaQuery.of (context).size.height / 7,),
        Opacity (
          opacity: 0.5,
          child: ShapeOfView (
            shape: CircleShape (
              borderColor: Colors.white, //optional
            ),
            child: Container (
              width: MediaQuery.of (context).size.height / 1.5,
              height: MediaQuery.of (context).size.height / 3,
              decoration: BoxDecoration (
                  image: DecorationImage (
                    colorFilter: new ColorFilter.mode(
                        Colors.black,
                        BlendMode.dstATop),
                    image: AssetImage (
                        'assets/images/Weather.gif'),
                  )
              ),
            ),
          ),
        ),
        SizedBox (
          height: MediaQuery
              .of (
              context)
              .size
              .height / 50,
        ),
        Align (
          alignment: Alignment.topLeft,
          child: Text (
            '  Check the weather by the city',
            style: TextStyle (
                color: (int.parse (
                    formattedTime) < 18)
                    ? Colors.black87
                    : Colors.white,
                fontSize: 19,
                fontWeight: FontWeight.w300),
          ),
        ),
        SizedBox (
            height: MediaQuery.of (context).size.height / 100),
        cityInput (context,widget.hintText,widget.focusNode,formattedTime),
        SizedBox (height: MediaQuery.of (context).size.height / 100,),
      ],
    );
  }

  Widget cityInput(BuildContext context,String hintText,FocusNode focusNode,
      String formattedTime) {
    return ConstrainedBox (
      constraints: BoxConstraints (
          maxHeight: 400 //put here the max height to which you need to resize the textbox
      ),
      child: Row (
        children: [
          Flexible (
            child: Container (
              padding: EdgeInsets.only (
                  left: MediaQuery
                      .of (
                      context)
                      .size
                      .height / 100,
                  top: MediaQuery
                      .of (
                      context)
                      .size
                      .height / 50,
                  bottom: MediaQuery
                      .of (
                      context)
                      .size
                      .height / 200,
                  right: MediaQuery
                      .of (
                      context)
                      .size
                      .height / 500),
              child: Directionality (
                textDirection: ui.TextDirection.ltr,
                child: Container (
                  width: MediaQuery
                      .of (
                      context)
                      .size
                      .height / 2.1,
                  child: TextField (
                    textInputAction: TextInputAction.search,
                    onSubmitted: (value) {
                      Navigator.of (
                          context).push (
                          MaterialPageRoute (
                              builder: (context) =>
                                  CityWeatherDetailsWithName (
                                      this.cityNameController.text)));
                    },
                    focusNode: focusNode,
                    maxLines: null,
                    decoration: InputDecoration (
                      suffixIcon: IconButton (
                        onPressed: () {
                          if(this.cityNameController.text.isNotEmpty){
                            Navigator.of (
                                context).push (
                                MaterialPageRoute (
                                    builder: (context) =>
                                        CityWeatherDetailsWithName (
                                            this.cityNameController.text)));
                          }else {
                            showTopSnackBar (
                              context,
                              CustomSnackBar.info (
                                message:
                                "Please enter city name before press search icon",
                                textStyle: TextStyle (
                                  color: (int.parse (
                                      formattedTime) < 18)
                                      ? Colors.black54
                                      : Colors.white,
                                ),
                                backgroundColor: (int.parse (
                                    formattedTime) < 18)
                                    ? Colors.white
                                    : Colors.black54,
                              ),
                            );
                          }
                        },
                        icon: Icon (
                          Icons.search,
                          size: 20.0,
                          color: (int.parse (
                              formattedTime) < 18)
                              ? Colors.black87
                              : Colors.white,
                        ),
                      ),
                      fillColor: Colors.transparent,
                      filled: true,
                      contentPadding: EdgeInsets.only (
                        left: MediaQuery
                            .of (
                            context)
                            .size
                            .height / 30,
                        top: MediaQuery
                            .of (
                            context)
                            .size
                            .height / 35,
                        bottom: MediaQuery
                            .of (
                            context)
                            .size
                            .height / 60,
                      ),
                      hintText: hintText,
                      hintStyle: TextStyle (
                          fontSize: 15.0,
                          color: (int.parse (
                              formattedTime) < 18)
                              ? Colors.black87
                              : Colors.white,
                          fontWeight: FontWeight.w300),
                      focusedBorder: new OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(
                              20.0),
                          borderSide: new BorderSide(
                              color: (int.parse (
                                  formattedTime) < 18)
                                  ? Colors.black87
                                  : Colors.white,
                              width: 1)),
                      enabledBorder: new OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(
                              20.0),
                          borderSide: new BorderSide(
                              color: (int.parse (
                                  formattedTime) < 18)
                                  ? Colors.black87
                                  : Colors.white,
                              width: 1)),
                    ),
                    cursorColor: (int.parse (
                        formattedTime) < 18)
                        ? Colors.black87
                        : Colors.white,
                    textAlign: TextAlign.left,
                    controller: this.cityNameController,
                    style: TextStyle (
                        color: (int.parse (
                            formattedTime) < 18)
                            ? Colors.black87
                            : Colors.white),
                  ),
                ),
              ),
            ),
          ),
          Padding (
            padding: EdgeInsets.only (
                left: MediaQuery
                    .of (
                    context)
                    .size
                    .height / 400,
                top: MediaQuery
                    .of (
                    context)
                    .size
                    .height / 100),
            child: IconButton (
                icon: Icon (
                  Icons.location_on,
                  size: 30,
                ),
                color: (int.parse (
                    formattedTime) < 18)
                    ? Colors.black87
                    : Colors.white,
                onPressed: () {
                  FocusScope.of (
                      context);
                  Navigator.of (
                      context).push (
                      MaterialPageRoute (
                          builder: (context) =>
                              CityWeatherDetailsWithCityLocation ()));
                }
            ),
          )
        ],
      ),
    );
  }
}