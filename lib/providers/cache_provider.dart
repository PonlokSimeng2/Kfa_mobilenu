import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'cache_provider.g.dart';

@Riverpod(keepAlive: true)
SharedPreferences sharePref(SharePrefRef ref) {
  throw UnimplementedError();
}
