import 'package:flutter/material.dart';
import 'package:flutter_conditional_rendering/flutter_conditional_rendering.dart';
import 'package:virtual_council/utils/Regions.dart';
import 'package:virtual_council/utils/practicearea.dart';
import '../Client/getLawyers.dart';

class ClientDashBoardScreen extends StatefulWidget {
  @override
  _ClientDashBoardScreenState createState() => _ClientDashBoardScreenState();
}

class _ClientDashBoardScreenState extends State<ClientDashBoardScreen> {
  bool _clicked = false;
  String dropdownValue = 'Ashanti';
  String selecval = '';
  String? shname;
  // List<String> categories = [];
  bool categor_Civil = false;
  bool categor_Criminal = false;
  bool categor_Divorce = false;
  bool categor_Affidavit = false;

  final header = Container(
    width: double.infinity,
    height: 250,
    margin: EdgeInsets.fromLTRB(5, 40, 5, 10),
    //padding: EdgeInsets.all(),
    decoration: BoxDecoration(
      color: Color(0xFF8C1F85),
      borderRadius: BorderRadius.all(Radius.circular(10)),
    ),
    child: Container(
      margin: EdgeInsets.fromLTRB(30, 30, 30, 50),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Search by",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 42,
              letterSpacing: 2,
            ),
          ),
          Text(
            "Name,",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.normal,
              fontSize: 30,
              letterSpacing: 1,
            ),
          ),
          Text(
            "Practice Area,",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.normal,
              fontSize: 30,
              letterSpacing: 1,
            ),
          ),
          Text(
            "Region",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.normal,
              fontSize: 30,
              letterSpacing: 1,
            ),
          ),
        ],
      ),
    ),
  );

  textField() {
    return Container(
      width: 180,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Color(0xffBEBDBD).withOpacity(.5),
            blurRadius: 3.0,
          )
        ],
      ),
      child: TextField(
        onChanged: (value) {
          if (value == "") {
            shname = null;
          } else {
            // good to validate
            shname = value;
          }
        },
        decoration: InputDecoration(
          prefixIcon: Icon(
            Icons.search,
            color: Color(0xffBEBDBD),
          ),
          hintText: "Search Name",
          hintStyle: TextStyle(color: Color(0xffBEBDBD), fontSize: 20),
          border: InputBorder.none,
        ),
      ),
    );
  }

  void _changeMode() {
    setState(() {
      _clicked = !_clicked;
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      extendBodyBehindAppBar: true,
      // Header of the app
      appBar: AppBar(
        leading: InkWell(
          onTap: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text(
          'Looking for a lawyer?',
          style: TextStyle(fontWeight: FontWeight.w800, color: Colors.white),
        ),
        backgroundColor: Color(0xFF8C1F85),
        centerTitle: true,
      ),

      // Body of the app
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(left: 10, top: 80, right: 10, bottom: 30),
          child: Column(
            children: [
              // Header of the page (blue box)
              header,
              // search box and filter button
              Container(
                margin: EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // search text field
                    textField(),
                    // filter box
                    Container(
                      width: 45,
                      height: 45,
                      decoration: BoxDecoration(
                          color: Color(0xffEF4646),
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Color(0xffBEBDBD).withOpacity(.5),
                              blurRadius: 3.0,
                            )
                          ]),
                      child: IconButton(
                        onPressed: () {
                          setState(() {
                            _changeMode();
                          });
                        },
                        icon: Icon(
                          Icons.filter_alt_rounded,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    // Search button
                    Container(
                      width: 45,
                      height: 45,
                      decoration: BoxDecoration(
                          color: Color(0xFF8C1F85),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Color(0xffBEBDBD).withOpacity(.5),
                              blurRadius: 3.0,
                            )
                          ]),
                      child: IconButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SearchPage(
                                        practiceArea: selecval,
                                        region: dropdownValue,
                                        name: shname,
                                      )));
                        },
                        icon: Icon(
                          Icons.search,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Conditional.single(
                context: context,
                conditionBuilder: (BuildContext context) => _clicked == false,
                widgetBuilder: (BuildContext context) {
                  return Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                            "Try using our filter to better match your search . . .",
                            style: TextStyle(
                                color: Color(0xff7E7D7D),
                                fontSize: 22,
                                fontWeight: FontWeight.bold)),
                      ],
                    ),
                  );
                },
                fallbackBuilder: (BuildContext context) {
                  return Container(
                    width: double.infinity,
                    // height: screenWidth,
                    padding: EdgeInsets.all(20),
                    // decoration: BoxDecoration(
                    //     image: DecorationImage(
                    //   image: AssetImage("assets/images/search_man.png"),
                    //   fit: BoxFit.cover,
                    // )),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Filter",
                            style: TextStyle(
                                color: Color(0xff676666), fontSize: 20)),
                        SizedBox(
                          height: screenWidth * 0.02,
                        ),
                        Container(
                          height: 105,
                          margin:
                              EdgeInsets.symmetric(vertical: 0, horizontal: 0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Practice Area",
                                  style: TextStyle(
                                      color: Color(0xff676666), fontSize: 16)),
                              DropdownButtonFormField<String>(
                                elevation: 10,
                                isExpanded: true,
                                decoration: InputDecoration(
                                    hintText: "Select a practise Area",
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(20)),
                                    ),
                                    filled: true,
                                    fillColor: Color(0xffEF2F1F1)),
                                // value: selecval,
                                icon: const Icon(
                                    Icons.keyboard_arrow_down_rounded),
                                iconSize: 24,
                                style: TextStyle(
                                  color: Colors.deepPurple,
                                ),
                                onChanged: (String? newValue) {
                                  print(newValue);
                                  setState(() {
                                    selecval = newValue!;
                                  });
                                },
                                items: AreaData.areas
                                    .map<DropdownMenuItem<String>>(
                                        (Area value) {
                                  // print(value.area);
                                  return DropdownMenuItem<String>(
                                      // value: value.region_code.toString(),
                                      value: value.area.toString(),
                                      child: Text(
                                        value.area,
                                      ));
                                }).toList(),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: screenWidth * 0.02,
                        ),
                        // State DropDown
                        Container(
                          height: 105,
                          margin: EdgeInsets.symmetric(
                              vertical: 0, horizontal: screenWidth * 0.01),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Region",
                                  style: TextStyle(
                                      color: Color(0xff676666), fontSize: 16)),
                              DropdownButtonFormField<String>(
                                elevation: 10,
                                decoration: InputDecoration(
                                    hintText: "Select Region",
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(20)),
                                    ),
                                    filled: true,
                                    fillColor: Color(0xffEF2F1F1)),
                                value: dropdownValue,
                                icon: const Icon(
                                    Icons.keyboard_arrow_down_rounded),
                                iconSize: 24,
                                style:
                                    const TextStyle(color: Colors.deepPurple),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    dropdownValue = newValue!;
                                  });
                                },
                                items: RegionData.regions
                                    .map<DropdownMenuItem<String>>(
                                        (Region value) {
                                  return DropdownMenuItem<String>(
                                      value: value.region,
                                      child: Text(value.region));
                                }).toList(),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
