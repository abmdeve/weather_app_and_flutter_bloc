import 'package:bloc/bloc.dart';

import 'weather_bloc_event.dart';
import 'weather_bloc_state.dart';

class Weather_blocBloc extends Bloc<Weather_blocEvent, Weather_blocState> {
  Weather_blocBloc() : super(Weather_blocState().init());

  @override
  Stream<Weather_blocState> mapEventToState(Weather_blocEvent event) async* {
    if (event is InitEvent) {
      yield await init();
    }
  }

  Future<Weather_blocState> init() async {
    return state.clone();
  }
}
