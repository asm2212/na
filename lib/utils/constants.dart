// validation for inputs logIn and signUp
String patternEmail =
    r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
RegExp regExpEmail = RegExp(patternEmail);
String patternName = r'(^[a-zA-Z ]*$)';
RegExp regExpName = RegExp(patternName);
String patternPass =
    r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
RegExp regExpPass = RegExp(patternPass);
String patternMobile = r'(^[0-9]*$)';
RegExp regExpMobile = RegExp(patternMobile);
