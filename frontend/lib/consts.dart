
import 'components.dart';

String localhost = 'http://127.0.0.1:8000';

String usernameLocal = 'huda';
String passwordLocal = 'hudaqddo';

setUser(String user, String pass) {
  usernameLocal = user;
  passwordLocal = pass;
}

String tokenUser = "";
setToken() async {
  tokenUser = await getToken();
}
