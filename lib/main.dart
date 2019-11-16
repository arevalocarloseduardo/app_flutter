import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() => runApp(AppLogin());

class AppLogin extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FormPage(),
    );
  }
}

class FormPage extends StatefulWidget {
  @override
  _FormPageState createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  static String myIp = "192.168.0.105";
  static String url = "http://$myIp/dashboard/myfolder/adduser.php";

  TextEditingController name = new TextEditingController();
  TextEditingController pass = new TextEditingController();
  TextEditingController email = new TextEditingController();

  String msg = "";

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Card(
        child: Padding(
          padding: const EdgeInsets.all(22.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Expanded(
                    flex: 2,
                    child: Center(
                      child: Text("Formulario de registro",
                          style: TextStyle(fontSize: 28)),
                    )),
                TextFormField(
                    validator: validate,
                    controller: name,
                    decoration: InputDecoration(
                      labelText: "Nombre",
                    )),
                TextFormField(
                    validator: validate,
                    controller: email,
                    decoration: InputDecoration(labelText: "E-mail")),
                TextFormField(
                    validator: emailValidator,
                    controller: pass,
                    obscureText: true,
                    decoration: InputDecoration(labelText: "Contraseña")),
                SizedBox(
                  height: 20,
                ),
                FlatButton(
                  child: Text("Enviar", style: TextStyle(color: Colors.white)),
                  color: Colors.blue,
                  shape: StadiumBorder(),
                  onPressed: () {
                    if (_formKey.currentState.validate()) {
                      _addUser();
                    }
                  },
                ),
                Expanded(
                  child: Text(msg),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void cleanData() {
    name.clear();
    pass.clear();
    email.clear();
  }

  void _addUser() async {
    final response = await http.post(url, body: {
      "Name": name.text,
      "Password": pass.text,
      "Email": email.text,
    });
    if (response.body == "OK") {
      setState(() {
        msg = "Usuario ${name.text} agregado con exito!";
      });
      cleanData();
    }
  }

  String validate(String value) {
    print(value);
    if (value.isEmpty) {
      return "El campo no puede estar vacio";
    }
    return null;
  }

  String emailValidator(String anEmailAddress) {
    if (anEmailAddress.isEmpty) {
      return "El campo no puede estar vacio";
    }
    if (RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(anEmailAddress)) {
      return null;
    } else {
      return "Email Inválido";
    }
  }
}
