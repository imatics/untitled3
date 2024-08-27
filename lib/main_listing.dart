import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:untitled3/api.dart';
import 'package:untitled3/details_page.dart';
import 'package:untitled3/model.dart';

class MainListing extends StatefulWidget {
  const MainListing({super.key});

  @override
  State<MainListing> createState() => _MainListingState();
}

class _MainListingState extends State<MainListing> {
  late TextEditingController controller;
  final filterText = ValueNotifier<String>("");

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = TextEditingController();
    Service().fetchData();
  }

  List<Model> get filtered {
    return Service()
        .list
        .value
        .where((e) => e.toJson().toString().contains(filterText.value))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<dynamic>(
        valueListenable: MultiValueObserver<dynamic>([Service().list, filterText]),
        builder: (context, value, child) {
          if (Service().list.value.isEmpty) {
            return Container(
              color: Colors.grey[100],
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
          return SafeArea(
            child: Scaffold(
              bottomNavigationBar: bottomBar(),
              body: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    SizedBox(
                      height: 35,
                    ),
                    topRow(),
                    SizedBox(
                      height: 30,
                    ),
                    searchBar((text) {
                      filterText.value = text;
                    }),
                    Expanded(
                        child: ListView(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      children:
                          filtered.map((e) => InkWell(child: listItem(e), onTap: (){
                            gotoDetail(e, context);
                          },)).toList(),
                    )),
                  ],
                ),
              ),
            ),
          );
        });
  }

  void gotoDetail(Model model, BuildContext context){
    Service().model.value = model;
    Navigator.push(context, MaterialPageRoute(builder: (e) => Details())).then((e){
      // Show toast;
      SnackBar snackBar = SnackBar(
        content: Text(Service().model.value.company?.catchPhrase??"Hiyya"),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    });

  }


  Widget topRow() {
    return Row(
      children: [
        Text(
          "Team",
          style: TextStyle(
              color: Colors.grey[900],
              fontSize: 30,
              fontWeight: FontWeight.bold),
        ),
        Spacer(),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 13),
          child: Row(
            children: [
              Icon(
                Icons.people_alt_outlined,
                color: Colors.white,
                size: 14,
              ),
              SizedBox(
                width: 5,
              ),
              Text(
                "30",
                style: TextStyle(color: Colors.white),
              )
            ],
          ),
          decoration: BoxDecoration(
              color: Colors.blue, borderRadius: BorderRadius.circular(4)),
        ),
        SizedBox(
          width: 10,
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Icon(
            Icons.add,
            color: Colors.grey[100],
          ),
          decoration:
              BoxDecoration(shape: BoxShape.circle, color: Colors.blue[800]),
        )
      ],
    );
  }

  Widget listItem(Model model) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
      decoration: BoxDecoration(
          border:
              Border(bottom: BorderSide(width: 0.5, color: Colors.grey[300]!))),
      child: Row(
        children: [
          SizedBox(
            height: 60,
            width: 60,
            child: Stack(
              children: [
                Positioned.fill(
                  child: Hero(
                    tag: model.name?.replaceAll(" ", "")??"tag",
                    child: CircleAvatar(
                      child: Icon(Icons.person, color: Colors.grey[600],),
                    ),
                  ),
                ),
                Positioned(
                  top: 0,
                  right: 0,
                  child: Container(
                    height: 2,
                    width: 2,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.green,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            width: 20,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                model.name ?? "",
                style: TextStyle(color: Colors.grey[700], fontSize: 18, fontWeight: FontWeight.w600),
              ),
              Text(
                model.username ?? "",
                style: TextStyle(color: Colors.grey[700], fontSize: 13),
              )
            ],
          )
        ],
      ),
    );
  }

  Widget searchBar(Function(String) onType) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
          color: Colors.grey[200], borderRadius: BorderRadius.circular(12)),
      height: 50,
      width: double.infinity,
      child: Row(
        children: [
          Icon(
            Icons.search,
            color: Colors.grey[700],
            size: 18,
          ),
          Expanded(
              child: SizedBox(
            child: TextFormField(
              controller: controller,
              focusNode: FocusNode(),
              onFieldSubmitted: onType,
              onChanged: onType,
              decoration: const InputDecoration(border: InputBorder.none),
            ),
          ))
        ],
      ),
    );
  }

  Map<String, IconData> items = {
    "Home": Icons.home,
    "Task": Icons.task,
    "Team": Icons.people,
    "Settings": Icons.settings,
    "Help": Icons.help
  };

  Widget bottomBar() {
    return Material(
      elevation: 10,
      child: Padding(
        padding: const EdgeInsets.only(top: 20),
        child: SizedBox(
          height: 65,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: items.keys
                .map((e) => Column(
                      children: [
                        Icon(
                          items[e],
                          color:
                              e == "Team" ? Colors.blue[600] : Colors.grey[700],
                        ),
                        Text(
                          e,
                          style: TextStyle(
                              color: e == "Team"
                                  ? Colors.blue[600]
                                  : Colors.grey[700]),
                        ),
                      ],
                    ))
                .toList(),
          ),
        ),
      ),
      color: Colors.white,
      borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30), topRight: Radius.circular(30)),
    );
  }
}
