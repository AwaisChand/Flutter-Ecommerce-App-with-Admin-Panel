import 'package:ecommerce_app/Provider/UserPovider/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

List<SingleChildWidget> providerClasses = [...independentProviders];
List<SingleChildWidget> independentProviders = [
  ChangeNotifierProvider(create: (_) => UserProvider()),
];
