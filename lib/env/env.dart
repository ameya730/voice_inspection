import 'package:envied/envied.dart';
part 'env.g.dart';

@Envied(path: '.env')
abstract class Env {
  @EnviedField(varName: 'anonkey')
  static const String anonkey = _Env.anonkey;
}
