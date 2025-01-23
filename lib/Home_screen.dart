import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather/weather.dart';
import 'package:weather_app/consts.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final WeatherFactory _wf = WeatherFactory(OPENWEATHER_API_KEY);
  var time = DateTime.now();
  String dropdownValue = "Bengaluru";
  Weather? _weather;

  void dropdownCallback(String? newValue) {
    if (newValue is String) {
      setState(() {
        dropdownValue = newValue;
        _wf.currentWeatherByCityName(dropdownValue).then((w) {
          setState(() {
            _weather = w;
          });
        });
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _wf.currentWeatherByCityName(dropdownValue).then((w) {
      setState(() {
        _weather = w;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Weather app"),
      ),
      body: _buildUI(),
    );
  }

  Widget _buildUI() {
    if (_weather == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          DropdownButton<String>(
            borderRadius: BorderRadius.all(Radius.circular(20)),
            value: dropdownValue,
            icon: const Icon(
              Icons.arrow_drop_down,
              size: 40,
            ),
            onChanged: dropdownCallback,
            // items: const [
            //   DropdownMenuItem(value: "Bengaluru", child: Text("Bengaluru")),
            //   DropdownMenuItem(value: "Delhi", child: Text("Delhi")),
            //   DropdownMenuItem(value: "Mumbai", child: Text("Mumbai")),
            //   DropdownMenuItem(value: "Davanagere", child: Text("Davanagere")),
            //   DropdownMenuItem(value: "Pune", child: Text("Pune")),
            //   DropdownMenuItem(value: "Srinagar", child: Text("Pakistan Occupied Kashmir")),
            // ],

            items: <String>[
              'Bengaluru',
              'Delhi',
              'Mumbai',
              'Davanagere',
              'Pune',
              'Srinagar'
            ].map<DropdownMenuItem<String>>(
              (String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              },
            ).toList(),
          ),
          _dateTimeInfo(),
          _CurrentTemp(),
          SizedBox(
            child: Card(
              margin: EdgeInsets.all(20),
              child: Column(
                children: [
                  _WeatherIcon(),
                ],
              ),
            ),
          ),
          _ExtraInfo(),
        ],
      ),
    );
  }

  Widget _dateTimeInfo() {
    DateTime now = _weather!.date!;
    return Column(
      children: [
        Text(
          //'${time.hour}:${time.minute}',
          DateFormat('jm').format(time),
          style: const TextStyle(fontSize: 25),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('${DateFormat('yMMMd').format(time)}'),
          ],
        )
      ],
    );
  }

  Widget _WeatherIcon() {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          height: MediaQuery.sizeOf(context).height * 0.20,
          decoration: BoxDecoration(
            image: DecorationImage(
              colorFilter: const ColorFilter.linearToSrgbGamma(),
              image: NetworkImage(
                "http://openweathermap.org/img/wn/${_weather?.weatherIcon}@4x.png",
              ),
            ),
          ),
        ),
        Text(
          _weather?.weatherDescription ?? "",
          style: const TextStyle(
            fontSize: 20,
          ),
        ),
        SizedBox(height: 20),
      ],
    );
  }

  Widget _CurrentTemp() {
    return Text(
      "${_weather?.temperature?.celsius?.toStringAsFixed(0)}°C",
      style: TextStyle(fontSize: 90, fontWeight: FontWeight.w500),
    );
  }

  Widget _ExtraInfo() {
    return Container(
      //  color: Colors.orange,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 140,
                width: 160,
                child: Card(
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Transform.scale(
                          scale: 1.3,
                          child: const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Icon(
                              Icons.air,
                            ),
                          ),
                        ),
                        Text(
                          "Wind: ${_weather?.windSpeed?.toStringAsFixed(0)} m/s",
                          style: const TextStyle(fontSize: 15),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 140,
                width: 160,
                child: Card(
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Transform.scale(
                          scale: 1.3,
                          child: const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Icon(
                              Icons.water_drop_outlined,
                            ),
                          ),
                        ),
                        Text(
                          "Humidity: ${_weather?.humidity?.toStringAsFixed(0)} %",
                          style: const TextStyle(fontSize: 15),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 140,
                width: 160,
                child: Card(
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Transform.scale(
                          scale: 1.3,
                          child: const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Icon(
                              Icons.device_thermostat_outlined,
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          "Max: ${_weather?.tempMax?.celsius?.toStringAsFixed(0)}° C",
                          style: const TextStyle(fontSize: 15),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 140,
                width: 160,
                child: Card(
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Transform.scale(
                          scale: 1.3,
                          child: const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Icon(
                              Icons.device_thermostat_outlined,
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          "Min: ${_weather?.tempMin?.celsius?.toStringAsFixed(0)}° C",
                          style: const TextStyle(fontSize: 15),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
