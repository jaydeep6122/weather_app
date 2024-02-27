// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/model/Cloudimage.dart';
import 'package:weather_app/model/dayname.dart';
import 'package:weather_app/model/weatherdata.dart';
import 'package:weather_app/screen/Loginscreen.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    Provider.of<WeatherdataProvider>(context, listen: false).getCityName();
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController searchControler = TextEditingController();
    var provider = Provider.of<WeatherdataProvider>(context, listen: false);

    return SafeArea(
      // Background Container
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white.withOpacity(0.7), width: 5),
          gradient: const LinearGradient(
              colors: [
                Colors.deepPurpleAccent,
                Color.fromARGB(255, 164, 160, 160),
                Colors.deepPurpleAccent
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              transform: GradientRotation(0)),
        ),
        child: Scaffold(
          // Appbar and Drawer
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            centerTitle: true,
            title: Text(
              "Today's Weather",
              style: TextStyle(
                  color: Colors.white.withOpacity(0.9),
                  fontWeight: FontWeight.bold),
            ),
          ),
          drawer: Drawer(
            backgroundColor: Colors.deepPurple,
            child: Padding(
              padding: EdgeInsets.only(
                  top: MediaQuery.sizeOf(context).height * 0.05),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    decoration:
                        BoxDecoration(border: Border.all(color: Colors.grey)),
                    padding: EdgeInsets.symmetric(
                      horizontal: MediaQuery.sizeOf(context).width * 0.05,
                      vertical: MediaQuery.sizeOf(context).height * 0.03,
                    ),
                    child: const ListTile(
                      leading: Icon(
                        Icons.person,
                        color: Colors.white,
                      ),
                      title: Text(
                        "Welcome Back",
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(
                      bottom: MediaQuery.sizeOf(context).height * 0.02,
                    ),
                    child: const ListTile(
                      leading: Icon(
                        Icons.favorite,
                        color: Colors.red,
                      ),
                      title: Text(
                        "Favourite Location",
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
                    ),
                  ),
                  Container(
                    height: MediaQuery.sizeOf(context).height * 0.05,
                    margin: EdgeInsets.symmetric(
                      horizontal: MediaQuery.sizeOf(context).width * 0.1,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: searchControler,
                            decoration: InputDecoration(
                              labelText: 'Search',
                              hintText: 'Enter City Name',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              labelStyle: const TextStyle(color: Colors.white),
                              hintStyle: const TextStyle(color: Colors.white70),
                            ),
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.lightBlueAccent,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: IconButton(
                            icon: const Icon(Icons.search),
                            onPressed: () async {
                              await provider.getWeather(
                                searchControler.text.trim().toString(),
                              );
                              Navigator.pop(context);
                            },
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      await provider.getCityName();
                      Navigator.pop(context);
                    },
                    child: const ListTile(
                      leading: Icon(Icons.location_on, color: Colors.white),
                      title: Text("Current Location",
                          style: TextStyle(color: Colors.white)),
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      await provider.getWeather("Bangalore");
                      Navigator.pop(context);
                    },
                    child: const ListTile(
                      leading: Icon(Icons.location_on, color: Colors.white),
                      title: Text("Bangalore",
                          style: TextStyle(color: Colors.white)),
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      await provider.getWeather("London");
                      Navigator.pop(context);
                    },
                    child: const ListTile(
                      leading: Icon(Icons.location_on, color: Colors.white),
                      title:
                          Text("London", style: TextStyle(color: Colors.white)),
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      await provider.getWeather("Surat");
                      Navigator.pop(context);
                    },
                    child: const ListTile(
                      leading: Icon(Icons.location_on, color: Colors.white),
                      title:
                          Text("Surat", style: TextStyle(color: Colors.white)),
                    ),
                  ),
                  ListTile(
                    leading: const Icon(Icons.exit_to_app, color: Colors.white),
                    title: GestureDetector(
                      onTap: () async {
                        var user = await Hive.openBox("user");
                        user.clear();
                        await FirebaseAuth.instance.signOut();
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LoginScreen(),
                          ),
                        );
                      },
                      child: const Text("Logout",
                          style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ],
              ),
            ),
          ),
          backgroundColor: Colors.transparent,
          body: SingleChildScrollView(
            child: Center(
              child: Consumer<WeatherdataProvider>(
                builder: (BuildContext context, value, Widget? child) {
                  return value.isLoading
                      ? const CircularProgressIndicator()

                      // Location Container
                      : Container(
                          decoration: const BoxDecoration(),
                          padding: EdgeInsets.only(
                              top: MediaQuery.sizeOf(context).height * 0.03),
                          child: Column(
                            children: [
                              Container(
                                margin: EdgeInsets.symmetric(
                                    horizontal:
                                        MediaQuery.sizeOf(context).width * 0.1),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.white,
                                      width: 3,
                                    ),
                                    borderRadius: BorderRadius.circular(20),
                                    color: Colors.white.withOpacity(0.4)),
                                height: MediaQuery.sizeOf(context).height * 0.2,
                                width: double.infinity,
                                child: Center(
                                  child: Container(
                                    margin: EdgeInsets.symmetric(
                                        horizontal:
                                            MediaQuery.sizeOf(context).width *
                                                0.04),
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Container(
                                                margin: const EdgeInsets.only(
                                                    top: 30),
                                                height:
                                                    MediaQuery.sizeOf(context)
                                                            .height *
                                                        0.15,
                                                child: Image.asset(getWeatherImage(
                                                    "${value.weather["weather"][0]["icon"]}"))),
                                            const Spacer(),
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "${(value.weather["main"]["temp"] / 10 as double).toInt()}\u00B0",
                                                  style: const TextStyle(
                                                      fontSize: 60,
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                Text(
                                                  "${value.weather["name"]}"
                                                      .toUpperCase(),
                                                  style: const TextStyle(
                                                    fontSize: 10,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                                Text(
                                                  "${value.weather["weather"][0]["description"]}",
                                                  style: const TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      "H:${(value.weather["main"]["temp_max"] / 10 as double).toInt()}\u00B0",
                                                      style: const TextStyle(
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    Text(
                                                      "L${(value.weather["main"]["temp_min"] / 10 as double).toInt()}\u00B0",
                                                      style: const TextStyle(
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    )
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              //Future Location Container
                              Container(
                                  decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.7),
                                      borderRadius: BorderRadius.circular(40)),
                                  margin: EdgeInsets.symmetric(
                                      horizontal:
                                          MediaQuery.sizeOf(context).width *
                                              0.08,
                                      vertical: 20),
                                  child: Column(
                                    children: [
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal:
                                                MediaQuery.sizeOf(context)
                                                        .width *
                                                    0.1,
                                            vertical: MediaQuery.sizeOf(context)
                                                    .height *
                                                0.01),
                                        child: const Text(
                                          "Future Weather",
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 15,
                                            fontWeight: FontWeight.normal,
                                          ),
                                        ),
                                      ),
                                      ListView.builder(
                                          shrinkWrap: true,
                                          //scrollDirection: Axis.vertical,
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          itemCount: value.weeklyWeather.length,
                                          itemBuilder: (context, index) {
                                            return Container(
                                              decoration: const BoxDecoration(
                                                  border: Border(
                                                      top: BorderSide(
                                                          color: Colors.grey))),
                                              padding: EdgeInsets.symmetric(
                                                  horizontal:
                                                      MediaQuery.sizeOf(context)
                                                              .width *
                                                          0.05,
                                                  vertical:
                                                      MediaQuery.sizeOf(context)
                                                              .height *
                                                          0.01),
                                              child: Column(
                                                children: [
                                                  Row(
                                                    children: [
                                                      Expanded(
                                                          child: Image.asset(
                                                              getWeatherImage(
                                                                  "${value.weeklyWeather[index]["weather"][0]["icon"]}"))),
                                                      const Spacer(),
                                                      Expanded(
                                                          child: Text(
                                                        "${(value.weeklyWeather[index]["main"]["temp"] / 10 as double).toInt()}\u00B0",
                                                        style: const TextStyle(
                                                            fontSize: 25,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w400),
                                                      )),
                                                      Expanded(
                                                          child: Text(
                                                        next6Days[index],
                                                        style: const TextStyle(
                                                            fontSize: 12,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ))
                                                    ],
                                                  )
                                                ],
                                              ),
                                            );
                                          }),
                                    ],
                                  ))
                            ],
                          ),
                        );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
