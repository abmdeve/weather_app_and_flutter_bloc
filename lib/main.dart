import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weather_app_and_flutter_bloc/bloc/weather_bloc_bloc.dart';
import 'package:weather_app_and_flutter_bloc/bloc/weather_bloc_event.dart';
import 'package:weather_app_and_flutter_bloc/screens/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FutureBuilder(
          future: _determinatePosition(),
          builder: (context, snap) {
            if (snap.hasData) {
              return BlocProvider<WeatherBlocBloc>(
                create: (context) => WeatherBlocBloc()
                  ..add(
                    FetchWeather(position: snap.data as Position),
                  ),
                child: const HomeScreen(),
              );
            } else {
              return const Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }
          }),
      /*BlocProvider<WeatherBlocBloc>(
        create: (context) => WeatherBlocBloc()..add(FetchWeather()),
        child: const HomeScreen(),
      ),*/
    );
  }
}

/// DETERMINE THE CURRENT POSITION OF THE DEVICE
/// WHEN THE LOCATION SERVICES ARE NOT ENABLED OR PERMISSIONS
/// ARE DENIED THE `FUTURE` WILL RETURN AN ERROR
Future<Position> _determinatePosition() async {
  bool serviceEnabled;
  LocationPermission permission;

  /// TEST IF LOCATION SERVICES ARE ENABLED
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    ///LOCATION SERVICES ARE NOT ENABLED DON'T CONTINUE
    ///ACCESSING THE POSITION AND REQUEST USERS OF THE
    ///APP TO ENABLE THE LOCATION SERVICE.
    return Future.error("LOCATION SERVICE ARE DISABLED.");
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      /// PERMISSION ARE DENIED, NEXT TIME YOU COULD TRY
      /// REQUESTING PERMISSIONS AGAIN (THIS IS ALSO WHERE)
      /// ANDROID'S shouldShowRequestPermissionRationale
      /// RETURNED TRUE. ACCORDING TO ANDROID GUIDE LINES
      /// YOUR APP SHOULD SHOW AN EXPLANATORY UI NOW.
      return Future.error("LOCATION PERMISSIONS ARE DENIED");
    }
  }

  if (permission == LocationPermission.deniedForever) {
    /// PERMISSIONS ARE DENIED FOREVER, HANDLE APPROPRIATELY
    return Future.error(
        'LOCATION PERMISSIONS ARE PERMANENTLY DENIED, WE CANNOT REQUEST PERMISSIONS.');
  }

  /// WHEN WE REACH HERE, PERMISSIONS ARE GRANTED AND WE CAN
  /// CONTINUE ACCESSING THE POSITION OF THE DEVICE
  return await Geolocator.getCurrentPosition();
}
