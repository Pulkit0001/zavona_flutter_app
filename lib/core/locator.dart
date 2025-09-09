

import 'package:get_it/get_it.dart';

GetIt locator = GetIt.instance;


T get<T extends Object>() {
  return locator<T>();
}

