import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/prayer_time.dart';

class PrayerTimeScreen extends StatefulWidget {
  const PrayerTimeScreen({super.key});

  @override
  State<PrayerTimeScreen> createState() => _PrayerTimeScreenState();
}

class _PrayerTimeScreenState extends State<PrayerTimeScreen> {
  PrayerTime time = PrayerTime();

  @override
  void initState() {
    getPrayerTime();
    super.initState();
  }

  Future<void> getPrayerTime({String city = "karachi"}) async {
    http.Response response = await http
        .get(Uri.parse("https://dailyprayer.abdulrcs.repl.co/api/${city}"));
    print(response.statusCode);

    setState(() {
      time = PrayerTime.fromJson(jsonDecode(response.body));
    });
  }

  String? cityName ;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
                fit: BoxFit.cover, image: AssetImage("assets/bg.png"))),
        width: double.infinity,
        padding: const EdgeInsets.all(15),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const SizedBox(
            height: 70,
          ),
          TextField(
                onChanged: ((value) {
                  cityName = value;
                  getPrayerTime(city: cityName!);
                
                }),),
          Text(
            "${time.city}",
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
           "${time.date}",
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          Spacer(),
          _timeCard(
              "Fajr", "${time.today?.fajr}"),
          _timeCard("Sunrise",
              "${time.today?.sunrise}"),
          _timeCard(
              "Dhuhr", "${time.today?.dhuhr}"),
          _timeCard("Asr", "${time.today?.asr}"),
          _timeCard("Maghrib",
               "${time.today?.maghrib}"),
          _timeCard(
              "Ishak","${time.today?.ishaA}"),
          const SizedBox(
            height: 20,
          ),
        ]),
      ),
    );
  }

  Widget _timeCard(String name, String time) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Colors.black.withOpacity(0.4)),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 25),
      margin: const EdgeInsets.only(bottom: 10),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Row(
          children: [
            const Icon(
              Icons.timer_outlined,
              color: Colors.white,
              size: 25,
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
              name,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
        Text(
          time,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ]),
    );
  }
}
