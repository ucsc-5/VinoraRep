
import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

void main() {
  group("Flutter Auth App Test", () {
    final emailField = find.byValueKey("email-field");
    final passwordField = find.byValueKey("password-field");
    final signInButton = find.byValueKey("signIn");
    final userInfoPage = find.byType("HomePage");
    final snackbar = find.byType("SnackBar");

    FlutterDriver driver;
    setUpAll(()async{
      driver = await FlutterDriver.connect();
    });

    tearDownAll(()async{
      if(driver != null) {
        driver.close();
      }
    });

    test("login fails with incorrect email and password, provides snackbar feedback",() async{
      await driver.tap(emailField);
      await driver.enterText("chamiviews@gmail.com");
      await Future.delayed(Duration(seconds: 2));
      await driver.tap(passwordField);
      await driver.enterText("123456789v");
      await Future.delayed(Duration(seconds: 2));
      await driver.tap(signInButton);
      await Future.delayed(Duration(seconds: 50));
      /*await driver.waitFor(snackbar);
      assert(snackbar != null);*/
      await driver.waitUntilNoTransientCallbacks();
      assert(userInfoPage == null);
    });

    /*test("logs in with correct email and password",() async {
      await driver.tap(emailField);
      await driver.enterText("test@testmail.com");
      await driver.tap(passwordField);
      await driver.enterText("testtest1");
      await driver.tap(signInButton);
      await driver.waitFor(userInfoPage);
      assert(userInfoPage != null);
      await driver.waitUntilNoTransientCallbacks();
      
    });*/


  });
}