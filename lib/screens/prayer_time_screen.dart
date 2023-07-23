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
    super.initState();
    Future.delayed(Duration.zero, () {
      getPrayerTime();
    });
  }

  Future<void> getPrayerTime({String city = "karachi"}) async {
    showDialog(
        context: context,
        builder: (context) {
          return const Center(child: CircularProgressIndicator());
        });
    http.Response response = await http
        .get(Uri.parse("https://dailyprayer.abdulrcs.repl.co/api/$city"));
    setState(() {
      time = PrayerTime.fromJson(jsonDecode(response.body));
    });
    Navigator.of(context).pop();
  }

  bool _showSearch = false;
  String cityName = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: _showSearch
            ? Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.deepPurple[800]!.withOpacity(0.4)),
                child: TextField(
                  style: TextStyle(color: Colors.white.withOpacity(0.8)),
                  autofocus: true,
                  onEditingComplete: () {
                    FocusManager.instance.primaryFocus?.unfocus();
                    _showSearch = false;
                  },
                  onSubmitted: ((value) {
                    cityName = value;
                    _showSearch = false;
                    FocusManager.instance.primaryFocus?.unfocus();
                    getPrayerTime(city: cityName.toLowerCase());
                  }),
                  decoration: InputDecoration(
                    hintStyle: TextStyle(
                        fontSize: 17, color: Colors.white60.withOpacity(0.3)),
                    hintText: 'Search City name',
                    border: InputBorder.none,
                    prefixIcon: const Icon(
                      Icons.search,
                      color: Colors.white60,
                    ),
                  ),
                ),
              )
            : Text(
                "Prayer Time",
                style: Theme.of(context).textTheme.bodyLarge,
              ),
        centerTitle: true,
        actions: [
          IconButton(
            color: Colors.white60,
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            icon: _showSearch ? const Icon(Icons.cancel_rounded) : Icon(Icons.search),
            onPressed: () {
              setState(() {
                _showSearch = !_showSearch;
              });
            },
          ),
        ],
        elevation: 0.0,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
      ),
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
          Text(
            time.city == null || time.city == "" ? "----" : "${time.city}",
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            time.city == null ? "--/--/--" : "${time.date}",
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const Spacer(),
          _timeCard(
              "Fajr", time.city == null ? "--:--" : "${time.today?.fajr}"),
          _timeCard("Sunrise",
              time.city == null ? "--:--" : "${time.today?.sunrise}"),
          _timeCard(
              "Dhuhr", time.city == null ? "--:--" : "${time.today?.dhuhr}"),
          _timeCard("Asr", time.city == null ? "--:--" : "${time.today?.asr}"),
          _timeCard("Maghrib",
              time.city == null ? "--:--" : "${time.today?.maghrib}"),
          _timeCard(
              "Isha'A", time.city == null ? "--:--" : "${time.today?.ishaA}"),
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
