import 'package:equatable/equatable.dart';

sealed class WeatherBlocEvent extends Equatable {
  const WeatherBlocEvent();

  @override
  List<Object> get props => [];
}


class FetchWeather extends WeatherBlocEvent {

}