import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart' as Geo;
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:shape_of_view/shape_of_view.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:weather/bloc/cities_summery_container_bloc.dart';
import 'package:weather/bloc/weather_bloc.dart';
import 'package:weather/convert/convert_temperature.dart';
import 'package:weather/models/city_model.dart';
import 'package:weather/view/city_weather_details_with_citylocation.dart';
import 'package:weather/view/city_weather_details_with_cityname.dart';
import 'dart:ui' as ui;
import 'dart:math' as math;

import 'package:weather/view/add_city_page.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  // FocusNode focusNode = FocusNode();
  // String hintText = 'Search city';
  String formattedTime = DateFormat('kk').format(DateTime.now());

  // @override
  // void initState() {
  //   // TODO: implement initState
  //   super.initState();
  //   focusNode.addListener(() {
  //     if (focusNode.hasFocus) {
  //       hintText = '';
  //     } else {
  //       hintText = 'Search city';
  //     }
  //     setState(() {});
  //   });
  // }

  // void selectedItem(BuildContext context, item){
  //   switch (item) {
  //     case 0 :
  //       Navigator.push(
  //           context,
  //           MaterialPageRoute(builder: (context) => SearchPage()));
  //       break;
  //     case 1 :
  //       showDialog(
  //           context: context,
  //           builder: (context) {
  //             return AlertDialog(
  //               insetPadding: EdgeInsets.only(
  //                 bottom: MediaQuery.of(context).size.height / 4,
  //                 left: MediaQuery.of(context).size.height / 30,
  //                 right: MediaQuery.of(context).size.height / 30,
  //               ),
  //               actions: [
  //                 Center(
  //                   child: ElevatedButton(
  //                       style:
  //                       ElevatedButton.styleFrom(
  //                         primary: Colors.white30,
  //                         onPrimary: Colors.black,
  //                         shape: const BeveledRectangleBorder(
  //                             borderRadius: BorderRadius.all(Radius.circular(25))),
  //                       ),
  //                       onPressed: () {
  //                         Navigator.pop(context);
  //                       },
  //                       child: Text('ok')),
  //                 )
  //                 ],
  //                 content: Text(
  //                     'Just longpress on the city card to '
  //                         'delete the weather summary'),
  //                 backgroundColor:
  //                 Colors.grey,
  //                 shape: RoundedRectangleBorder(
  //                     borderRadius:
  //                     BorderRadius.circular(25)),
  //               );
  //             }
  //         );
  //   }
  // }

  @override
  Widget build(BuildContext context) {

    final citiesWeathersSummeryBloc = BlocProvider.of<CitiesWeathersSummeryBloc>(context);
    citiesWeathersSummeryBloc.add(FetchAllDataEvent());

    return BlocBuilder<CitiesWeathersSummeryBloc, CitiesWeathersSummeryState>(
        builder: (context, state) {
      if (state is CitiesWeathersSummeryIsLoadingState) {
        return Center(child: CircularProgressIndicator());
      }
      if (state is CitiesWeathersSummeryIsLoadedState) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          home: Scaffold(
              extendBodyBehindAppBar: true,
              resizeToAvoidBottomInset: false,
              // appBar: AppBar(
              //   backgroundColor: Colors.white.withOpacity(0),
              //   elevation: 0,
                // actions: [
                //   PopupMenuButton <int> (
                //       shape: RoundedRectangleBorder(
                //           borderRadius:
                //           BorderRadius.all(Radius.circular(15.0))),
                //       color: Colors.black.withOpacity(1),
                //       icon: Icon(
                //         Icons.more_vert,
                //         color: (int.parse(formattedTime) < 18)
                //             ? Colors.black87
                //             : Colors.white,
                //       ),
                //       itemBuilder: (context) => [
                //         PopupMenuItem <int> (
                //           value: 0,
                //           child: Text(
                //             "Add City",
                //             style: TextStyle(
                //               color: (int.parse(formattedTime) < 18)
                //                   ? Colors.black87
                //                   : Colors.white,
                //             ),
                //           ),
                //           // onTap: () {
                //           //   print('ssss');
                //           //   Navigator.push(
                //           //       context,
                //           //       MaterialPageRoute(builder: (context) => SearchPage()));
                //           // },
                //         ),
                //         PopupMenuItem <int> (
                //           value: 1,
                //           child: Text("Help",
                //               style: TextStyle(
                //                 color: (int.parse(formattedTime) < 18)
                //                     ? Colors.black87
                //                     : Colors.white,
                //               )
                //               ),
                //         )
                //           // onTap: () {
                //           //   showDialog(
                //           //       context: context,
                //           //       builder: (context) {
                //           //         return AlertDialog(
                //           //           insetPadding: EdgeInsets.only(
                //           //             bottom: MediaQuery.of(context).size.height / 4,
                //           //             left: MediaQuery.of(context).size.height / 30,
                //           //             right: MediaQuery.of(context).size.height / 30,
                //           //           ),
                //           //           actions: [
                //           //             Center(
                //           //               child: ElevatedButton(
                //           //                   style:
                //           //                   ElevatedButton.styleFrom(
                //           //                     primary: Colors.white30,
                //           //                     onPrimary: Colors.black,
                //           //                     shape: const BeveledRectangleBorder(
                //           //                         borderRadius: BorderRadius.all(Radius.circular(25))),
                //           //                   ),
                //           //                   onPressed: () {
                //           //                     Navigator.pop(context);
                //           //                   },
                //           //                   child: Text('ok')),
                //           //             )
                //         //             ],
                //         //             content: Text(
                //         //                 'Just longpress on the city card to '
                //         //                     'delete the weather summary'),
                //         //             backgroundColor:
                //         //             Colors.grey,
                //         //             shape: RoundedRectangleBorder(
                //         //                 borderRadius:
                //         //                 BorderRadius.circular(25)),
                //         //           );
                //         //         }
                //         //     );
                //         //   },
                //         //   value: 2,
                //         // )
                //       ],
                //     onSelected: (item) => selectedItem(context, item),
                //         // Navigator.push(
                //         // context,
                //         // MaterialPageRoute(builder: (context) => SearchPage()))
                //   )
                // ],
              // ),
              body: Container(
                  width: double.infinity,
                  height: double.infinity,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage((int.parse(formattedTime) < 18)
                            ? 'assets/images/sunny.png'
                            : 'assets/images/night.png'),
                        fit: BoxFit.fill,
                        // colorFilter: new ColorFilter.mode(
                        //     Colors.white.withOpacity(0.8), BlendMode.dstATop),
                      )),
                  child: (state.getCitiesWeathers.length != 0)
                  ? SafeArea(child: CityWeatherDetailsWithName(state.getCitiesWeathers[0].name))
                  : Center(
                    child: Container(
                      width: MediaQuery.of(context).size.width/1.4,
                      height: MediaQuery.of(context).size.height/7,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.black.withOpacity(0.4)
                      ),
                      child: Column(
                        children: [
                          SizedBox(
                            height: MediaQuery.of(context).size.height/30,
                          ),
                          Text('No city data to show, please add a city and retry',
                          style: TextStyle(fontSize: 12),),
                          SizedBox(
                            height: MediaQuery.of(context).size.height/40,
                          ),
                          ElevatedButton(
                            onPressed: (){
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => AddCityPage()));
                            },
                            child: Text('Add city'),
                          ),
                        ]
                    ),
                  )

                // SearchPage(hintText, focusNode),
              )
            )
          ),
        );
      }
      if (state is CitiesWeathersSummeryIsNotLoadedState) {
        return Text(
          '',
          style: TextStyle(fontSize: 25, color: Colors.white),
        );
      } else
        return Text("", style: TextStyle(fontSize: 25, color: Colors.white));
      // MaterialApp(
      // debugShowCheckedModeBanner: false,
      // home: Scaffold(
      //     extendBodyBehindAppBar: true,
      //     resizeToAvoidBottomInset: false,
      //     appBar: AppBar(
      //         backgroundColor: const Color(0xFFFEFFFA).withOpacity(0),
      //         elevation: 0.0,
      //         actions: [
      //           PopupMenuButton(
      //             shape: RoundedRectangleBorder(
      //                  borderRadius: BorderRadius.all(Radius.circular(15.0))),
      //             color: Colors.black.withOpacity(0.3),
      //               icon: Icon(Icons.more_vert, color: (int.parse(formattedTime) < 18)
      //                   ? Colors.black87
      //                   : Colors.white,),
      //               itemBuilder:(context) => [
      //                 PopupMenuItem(
      //                   child: Text("Add City", style: TextStyle(color: (int.parse(formattedTime) < 18)
      //                       ? Colors.white
      //                       : Colors.black87,),),
      //                   onTap: (){
      //
      //                   },
      //                   value: 1,
      //                 ),
      //                 PopupMenuItem(
      //                   child: Text("Help" ,style: TextStyle(color: (int.parse(formattedTime) < 18)
      //                 ? Colors.white
      //                     : Colors.black87,)),
      //                   onTap: (){
      //
      //                   },
      //                   value: 2,
      //                 )
      //               ]
      //           )
      //list if widget in appbar actions
      // IconButton(icon: Icon(Icons.help,color: Colors.white),
      // onPressed: (){
      //   showDialog(
      //       context: context,
      //       builder: (context) {
      //         return AlertDialog(
      //           insetPadding: EdgeInsets.only(
      //             bottom: MediaQuery.of(context).size.height / 4,
      //             left: MediaQuery.of(context).size.height / 30,
      //             right: MediaQuery.of(context).size.height / 30,
      //           ),
      //           actions: [
      //             Center(
      //               child: ElevatedButton(
      //                   style:
      //                   ElevatedButton.styleFrom(
      //                     primary: Colors.white30,
      //                     onPrimary: Colors.black,
      //                     shape: const BeveledRectangleBorder(
      //                         borderRadius: BorderRadius.all(Radius.circular(25))),
      //                   ),
      //                   onPressed: () {
      //                     Navigator.pop(context);
      //                   },
      //                   child: Text('ok')),
      //             )
      //           ],
      //           content: Text(
      //               'Just longpress on the city card to '
      //                   'delete the weather summary'),
      //           backgroundColor:
      //           Colors.grey,
      //           shape: RoundedRectangleBorder(
      //               borderRadius:
      //               BorderRadius.circular(25)),
      //         );
      //       }
      //   );
      // },
      // ),
      //     ],
      // ),
      // body: Container(
      //   decoration: BoxDecoration(
      //       color: Colors.black,
      //       image: DecorationImage(
      //         image: AssetImage((int.parse(formattedTime) < 18)
      //             ? 'assets/images/sunny.png'
      //             : 'assets/images/night.png'),
      //         fit: BoxFit.fill,
      //         colorFilter: new ColorFilter.mode(
      //             Colors.black.withOpacity(0.7), BlendMode.dstATop),
      //       )),
      //   child:
      //   // CityWeatherDetailsWithName();
      //
      //   // SearchPage(hintText, focusNode),
      // )
      // ),
    });
  }
}

// class SearchPage extends StatefulWidget {
//   final String hintText;
//   FocusNode focusNode;
//
//   SearchPage(this.hintText, this.focusNode);
//
//   @override
//   _SearchPageState createState() => _SearchPageState();
// }

// class _SearchPageState extends State<SearchPage> with TickerProviderStateMixin{
//
//   var position = new Geo.Position();
//   final TextEditingController cityNameController = TextEditingController();
//   Geo.Position _currentPosition;
//   final Location location = Location();
//   AnimationController _controller;
//
//
//   @override
//   void initState() {
//     super.initState();
//     _controller = AnimationController(vsync: this, duration: Duration(seconds: 2));
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     DateTime now = DateTime.now();
//     String formattedTime = DateFormat('kk').format(now);
//
//     final citiesWeathersSummeryBloc = BlocProvider.of<CitiesWeathersSummeryBloc>(context);
//     citiesWeathersSummeryBloc.add(FetchAllDataEvent());
//
//     return Column(
//       children: [
//         SizedBox(
//           height: MediaQuery.of(context).size.height /7,
//         ),
//         // Opacity(
//         //   opacity: 0.5,
//         //   child: ShapeOfView(
//         //     shape: CircleShape(
//         //       borderColor: Colors.white, //optional
//         //     ),
//         //     child: Container(
//         //       width: MediaQuery.of(context).size.height /1.5,
//         //       height: MediaQuery.of(context).size.height /3,
//         //       decoration: BoxDecoration(
//         //           image: DecorationImage(
//         //             colorFilter: new ColorFilter.mode(Colors.black,
//         //                 BlendMode.dstATop),
//         //             image: AssetImage(
//         //                 'assets/images/Weather.gif'),
//         //           )
//         //       ),
//         //     ),
//         //   ),
//         // ),
//         SizedBox(
//           height: MediaQuery.of(context).size.height /50,
//         ),
//         Align(
//           alignment: Alignment.topLeft,
//           child: Text(
//             '  Check the weather by the city',
//             style: TextStyle(
//                 color: (int.parse(formattedTime) < 18)
//                     ? Colors.black87
//                     : Colors.white,
//                 fontSize: 19,
//                 fontWeight: FontWeight.w300),
//           ),
//         ),
//         SizedBox(height: MediaQuery.of(context).size.height / 100),
//         cityInput(context, widget.hintText, widget.focusNode, formattedTime),
//         SizedBox(height: MediaQuery.of(context).size.height / 100,),
//         cityContainer()
//       ],
//     );
//   }
//
//   BlocBuilder<CitiesWeathersSummeryBloc, CitiesWeathersSummeryState> cityContainer() {
//     return BlocBuilder<CitiesWeathersSummeryBloc, CitiesWeathersSummeryState>(builder: (context, state){
//         if (state is CitiesWeathersSummeryIsLoadingState){
//           return Center(child: CircularProgressIndicator());
//         }
//         if (state is CitiesWeathersSummeryIsLoadedState){
//           return Flexible(
//               child: ListView.builder(
//                   scrollDirection: Axis.horizontal,
//                   itemCount: state.getCitiesWeathers.length,
//                   itemBuilder: (BuildContext context, int index) {
//
//                     return Padding(
//                           padding: EdgeInsets.only(
//                               top: MediaQuery.of(context).size.height / 500,
//                               bottom: MediaQuery.of(context).size.height / 200,
//                               left: MediaQuery.of(context).size.height / 80,
//                               right: MediaQuery.of(context).size.height / 80),
//                           // child: InkWell(
//                           //   child: Container(
//                           //     width: MediaQuery.of(context).size.height / 5,
//                           //     decoration: BoxDecoration(
//                           //       borderRadius: BorderRadius.circular(20.0),
//                           //       color: Colors.grey[800].withOpacity(0.6),
//                           //     ),
//                           //     child: Column(
//                           //       children: [
//                           //         Column(
//                           //           children: [
//                           //             Padding(
//                           //               padding: EdgeInsets.only(
//                           //                   top: MediaQuery.of(context).size.height / 80,
//                           //                   left: MediaQuery.of(context).size.height / 80),
//                           //               child: Align(
//                           //                 alignment: Alignment.centerLeft,
//                           //                 child: Text(
//                           //                   state.getCitiesWeathers[index].name.toString(),
//                           //                   style: TextStyle(
//                           //                       color: Colors.white),
//                           //                 ),
//                           //               ),
//                           //             ),
//                           //             Padding(
//                           //               padding: EdgeInsets.only(
//                           //                   top: MediaQuery.of(context).size.height / 180,
//                           //                   left: MediaQuery.of(context).size.height / 80),
//                           //               child: Align(
//                           //                 alignment: Alignment.centerLeft,
//                           //                 child: Text(
//                           //                   '${new DateFormat.MMMMd().format(DateTime.fromMicrosecondsSinceEpoch(state.getCitiesWeathers[index].time))}',
//                           //                   style: TextStyle(
//                           //                       color: Colors.white,
//                           //                       fontWeight: FontWeight.w300,
//                           //                       fontSize: 12),
//                           //                 ),
//                           //               ),
//                           //             ),
//                           //           ],
//                           //         ),
//                           //         Padding(
//                           //           padding: EdgeInsets.only(
//                           //               top: MediaQuery.of(context).size.height / 60),
//                           //           child: SvgPicture.asset(
//                           //             "assets/svgs/" + "${state.getCitiesWeathers[index].icon}" + ".svg",
//                           //             width: 65.0,
//                           //           ),
//                           //         ),
//                           //         Padding(
//                           //           padding: EdgeInsets.only(
//                           //               top: MediaQuery.of(context).size.height / 60),
//                           //           child: Text(
//                           //             '${ConvertTemperature().fahrenheitToCelsius(state.getCitiesWeathers[index].temp)} °C',
//                           //             style: TextStyle(color: Colors.white),
//                           //           ),
//                           //         ),
//                           //         SizedBox(
//                           //           height:
//                           //           MediaQuery.of(context).size.height / 80,
//                           //         ),
//                           //         Row(
//                           //           mainAxisAlignment:
//                           //           MainAxisAlignment.spaceBetween,
//                           //           children: [
//                           //             Column(
//                           //               children: [
//                           //                 SizedBox(
//                           //                   height: MediaQuery.of(context).size.height / 80,
//                           //                 ),
//                           //                 Row(
//                           //                   children: [
//                           //                     Icon(
//                           //                       Icons.arrow_upward_sharp,
//                           //                       size: 18,
//                           //                       color: Colors.redAccent,
//                           //                     ),
//                           //                     Text(
//                           //                       '${ConvertTemperature().fahrenheitToCelsius(state.getCitiesWeathers[index].tempMax)} °C',
//                           //                       style: TextStyle(
//                           //                           color: Colors.white),
//                           //                     ),
//                           //                   ],
//                           //                 ),
//                           //                 SizedBox(
//                           //                   height: MediaQuery.of(context).size.height / 80,
//                           //                 ),
//                           //                 Row(
//                           //                   children: [
//                           //                     Icon(
//                           //                       Icons.arrow_downward,
//                           //                       color: Colors.blue,
//                           //                       size: 18,
//                           //                     ),
//                           //                     Text(
//                           //                       '${ConvertTemperature().fahrenheitToCelsius(state.getCitiesWeathers[index].tempMin)} °C',
//                           //                       style: TextStyle(
//                           //                           color: Colors.white),
//                           //                     ),
//                           //                   ],
//                           //                 ),
//                           //               ],
//                           //             ),
//                           //             Padding(
//                           //               padding: EdgeInsets.only(
//                           //                   right: MediaQuery.of(context).size.height / 80),
//                           //               child: Column(
//                           //                 children: [
//                           //                   SizedBox(
//                           //                     height: MediaQuery.of(context).size.height / 70,
//                           //                   ),
//                           //                   Text('Real feel',
//                           //                       style: TextStyle(
//                           //                           color: Colors.white,
//                           //                           fontWeight: FontWeight.w400,
//                           //                           fontSize: 12)),
//                           //                   SizedBox(
//                           //                     height: MediaQuery.of(context).size.height / 80,
//                           //                   ),
//                           //                   Text(
//                           //                       '${ConvertTemperature().fahrenheitToCelsius(state.getCitiesWeathers[index].feelsLike)} °C',
//                           //                       style: TextStyle(
//                           //                           color: Colors.white)),
//                           //                 ],
//                           //               ),
//                           //             )
//                           //           ],
//                           //         )
//                           //       ],
//                           //     ),
//                           //   ),
//                           //   onLongPress: () {
//                           //     final weatherBloc =
//                           //     BlocProvider.of<CitiesWeathersSummeryBloc>(context);
//                           //     weatherBloc.add(DeleteCityForWeatherEvent(state.getCitiesWeathers[index].name));
//                           //     Navigator.push(
//                           //         context,
//                           //         MaterialPageRoute(
//                           //             builder: (context) => SearchScreen()));
//                           //   },
//                           //   onTap: () {
//                           //     Navigator.of(context).push(MaterialPageRoute(
//                           //         builder: (context) =>
//                           //             CityWeatherDetailsWithName(state.getCitiesWeathers[index].name)));
//                           //   },
//                           // ),
//                         );
//                         // Padding(
//                         //   padding: EdgeInsets.only(left: MediaQuery.of(context).size.height / 7),
//                         //   child: AnimatedBuilder(
//                         //       animation: _controller,
//                         //       builder: (_, child) {
//                         //         return Transform.rotate(
//                         //           angle: _controller.value * 2 * math.pi,
//                         //           child: child,
//                         //         );
//                         //       },
//                         //       child: IconButton(icon: Icon(Icons.update_rounded, color: Colors.white,),
//                         //           onPressed: (){
//                         //
//                         //             setState(() {
//                         //               _controller = AnimationController(vsync: this, duration: Duration(seconds: 2))..repeat()..addListener(() {
//                         //                 if (_controller.value > (4 / 4.001)) {    //4 = to stop after 5 seconds
//                         //                   _controller.stop();
//                         //                 }
//                         //               });});
//                         //
//                         //             final citiesWeathersSummeryBloc = BlocProvider.of<CitiesWeathersSummeryBloc>(context);
//                         //             citiesWeathersSummeryBloc.add(FetchWeatherWithCityNameForUpdateEvent(state.getCitiesWeathers[index].name));
//                         //             print("state is $state");
//                         //
//                         //             if (state is UpdateCitiesWeathersSummeryIsLoadedState){
//                         //
//                         //               print('11111111111');
//                         //
//                         //               print('state    $state');
//                         //
//                         //             var temp = state.getCitiesWeathers[index].temp;
//                         //             var name = state.getCitiesWeathers[index].name;
//                         //             var icon = state.getCitiesWeathers[index].icon;
//                         //             var maxTemp = state.getCitiesWeathers[index].tempMax;
//                         //             var minTemp = state.getCitiesWeathers[index].tempMin;
//                         //             var feelsLike = state.getCitiesWeathers[index].feelsLike;
//                         //             var id = state.getCitiesWeathers[index].id;
//                         //             var time = state.getCitiesWeathers[index].time;
//                         //
//                         //             print('time        ${DateFormat().format(DateTime.fromMicrosecondsSinceEpoch(state.getCitiesWeathers[index].time))}');
//                         //
//                         //             CityModel cityModel = CityModel();
//                         //             cityModel.id = id;
//                         //             cityModel.name = name;
//                         //             cityModel.feelsLike = feelsLike;
//                         //             cityModel.temp = temp;
//                         //             cityModel.tempMax = maxTemp;
//                         //             cityModel.tempMin = minTemp;
//                         //             cityModel.time = time;
//                         //             cityModel.icon = icon;
//                         //
//                         //             print(cityModel.toMap());
//                         //
//                         //             final citiesWeathersSummeryBloc = BlocProvider.of<CitiesWeathersSummeryBloc>(context);
//                         //             citiesWeathersSummeryBloc.add(UpdateCityWeatherEvent(cityModel));
//                         //             }
//                         //
//                         //             return Text('Date kahr');
//                         //           })),
//                         // )
//                   }
//               )
//           );
//         }
//         if (state is WeatherIsNotLoadedState){
//           return Text(
//             '',
//             style: TextStyle(fontSize: 25, color: Colors.white),
//           );
//         }
//         return Center(child: Text("", style: TextStyle(fontSize: 25, color: Colors.white)));
//       });
//   }
//
//   Widget cityInput(BuildContext context, String hintText, FocusNode focusNode,
//       String formattedTime) {
//     return ConstrainedBox(
//       constraints: BoxConstraints(
//           maxHeight: 400 //put here the max height to which you need to resize the textbox
//           ),
//       child: Row(
//         children: [
//           Flexible(
//             child: Container(
//               padding: EdgeInsets.only(
//                   left: MediaQuery.of(context).size.height / 100,
//                   top: MediaQuery.of(context).size.height / 50,
//                   bottom: MediaQuery.of(context).size.height / 200,
//                   right: MediaQuery.of(context).size.height / 500),
//               child: Directionality(
//                 textDirection: ui.TextDirection.ltr,
//                 child: Container(
//                   width: MediaQuery.of(context).size.height / 2.1,
//                   child: TextField(
//                     textInputAction: TextInputAction.search,
//                     onSubmitted: (value){
//                       Navigator.of(context).push(MaterialPageRoute(
//                           builder: (context) => CityWeatherDetailsWithName(
//                               this.cityNameController.text)));
//                     },
//                     focusNode: focusNode,
//                     maxLines: null,
//                     decoration: InputDecoration(
//                       suffixIcon: IconButton(
//                         onPressed: () {
//                           if (this.cityNameController.text.isNotEmpty) {
//                             Navigator.of(context).push(MaterialPageRoute(
//                                 builder: (context) => CityWeatherDetailsWithName(
//                                     this.cityNameController.text)));
//                           }else {
//                             showTopSnackBar(
//                               context,
//                               CustomSnackBar.info(
//                                 message:
//                                 "Please enter city name before press search icon",
//                                 textStyle: TextStyle(color: (int.parse(formattedTime) < 18)
//                                     ? Colors.black54
//                                     : Colors.white,
//                                 ),
//                                 backgroundColor: (int.parse(formattedTime) < 18)
//                                     ? Colors.white
//                                     : Colors.black54,
//                               ),
//                             );
//                           }
//                         },
//                         icon: Icon(
//                           Icons.search,
//                           size: 20.0,
//                           color: (int.parse(formattedTime) < 18)
//                               ? Colors.black87
//                               : Colors.white,
//                         ),
//                       ),
//                       fillColor: Colors.transparent,
//                       filled: true,
//                       contentPadding: EdgeInsets.only(
//                         left: MediaQuery.of(context).size.height / 30,
//                         top: MediaQuery.of(context).size.height / 35,
//                         bottom: MediaQuery.of(context).size.height / 60,
//                       ),
//                       hintText: hintText,
//                       hintStyle: TextStyle(
//                           fontSize: 15.0,
//                           color: (int.parse(formattedTime) < 18)
//                               ? Colors.black87
//                               : Colors.white,
//                           fontWeight: FontWeight.w300),
//                       focusedBorder: new OutlineInputBorder(
//                           borderRadius: new BorderRadius.circular(20.0),
//                           borderSide: new BorderSide(
//                               color: (int.parse(formattedTime) < 18)
//                                   ? Colors.black87
//                                   : Colors.white,
//                               width: 1)),
//                       enabledBorder: new OutlineInputBorder(
//                           borderRadius: new BorderRadius.circular(20.0),
//                           borderSide: new BorderSide(
//                               color: (int.parse(formattedTime) < 18)
//                                   ? Colors.black87
//                                   : Colors.white,
//                               width: 1)),
//                     ),
//                     cursorColor: (int.parse(formattedTime) < 18)
//                         ? Colors.black87
//                         : Colors.white,
//                     textAlign: TextAlign.left,
//                     controller: this.cityNameController,
//                     style: TextStyle(
//                         color: (int.parse(formattedTime) < 18)
//                             ? Colors.black87
//                             : Colors.white),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//           Padding(
//             padding: EdgeInsets.only(
//                 left: MediaQuery.of(context).size.height / 400,
//                 top: MediaQuery.of(context).size.height / 100),
//             child: IconButton(
//               icon: Icon(
//                 Icons.location_on,
//                 size: 30,
//               ),
//               color: (int.parse(formattedTime) < 18)
//                   ? Colors.black87
//                   : Colors.white,
//               onPressed: (){
//                 FocusScope.of(context);
//                    Navigator.of(context).push(MaterialPageRoute(
//                        builder: (context) => CityWeatherDetailsWithCityLocation(
//                            )));
//                }
//             ),
//           )
//         ],
//       ),
//     );
//   }
// }
