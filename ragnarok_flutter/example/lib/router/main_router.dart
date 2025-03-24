import 'package:flutter/widgets.dart';
import 'package:ragnarok_flutter/ragnarok_flutter.dart';
import 'package:ragnarok_flutter/ragnarok_app/ragnarok_app.dart';
import 'package:ragnarok_flutter_example/router/router_extension.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  RagnarokFlutter.initialize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return RagnarokApp(
      debugShowCheckedModeBanner: false,
      initAppPageRoute: AppPageRouteExt.home,
    );
  }
}
