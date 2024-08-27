import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:untitled3/model.dart';

class Service {

  static final Service _singleton =
  Service._internal();

  factory Service() {
    return _singleton;
  }

  Service._internal();


  final list = ValueNotifier<List<Model>>([]);
  final model = ValueNotifier<Model>(Model());

  Future fetchData() async {
    if(list.value.isNotEmpty){
      return;
    }
    var dio = Dio();
    var response = await dio.request(
      'https://jsonplaceholder.typicode.com/users',
      options: Options(
        method: 'GET',
      ),
    );
    if (response.statusCode == 200) {
      list.value = Model.listFromJson(response.data);
    } else {
      list.value = [];
    }
  }}



class MultiValueObserver<T> extends ValueNotifier<T?> {
  MultiValueObserver(this.observers) : super(null) {
    for (var element in observers) {
      element.addListener(() => notifyListeners());
    }
  }
  final List<ValueNotifier<T>> observers;
  final List<T> staticValue = [];

  void add(ValueNotifier<T> item) {
    item.addListener(() => notifyListeners());
    observers.add(item);
  }

  void remove(ValueNotifier<T> item) {
    observers.remove(item);
  }

  List<T> get values => observers.map((e) => e.value).toList();
}
