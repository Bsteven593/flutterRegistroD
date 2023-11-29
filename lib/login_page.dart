import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late Color myColor;
  late Size mediaSize;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController cedulaController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  bool rememberUser = false;
  bool isFemaleSelected = false;
  bool isMaleSelected = false;
  String emailErrorMessage = '';
  int selectedAge = 18;
  String selectedProvince = 'Pichincha';

  @override
  Widget build(BuildContext context) {
    myColor = Theme.of(context).backgroundColor;
    mediaSize = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          _buildBackground(),
          Positioned(top: 80, child: _buildTop()),
          Positioned(bottom: 0, child: _buildBottom()),
        ],
      ),
    );
  }

  Widget _buildBackground() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color.fromARGB(255, 30, 30, 209),
            Color.fromARGB(255, 55, 146, 185),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
    );
  }

  Widget _buildTop() {
    return SizedBox(
      width: mediaSize.width,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildHeading("Go map"),
        ],
      ),
    );
  }

  Widget _buildBottom() {
    return SizedBox(
      width: mediaSize.width,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: _buildForm(),
        ),
      ),
    );
  }

  Widget _buildForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeading("Registro Cliente Para Empresa"),
        _buildGreyText("Escriba su información para Ingresar"),
        SizedBox(height: 10),
        _buildTextField("Nombre", nameController),
        SizedBox(height: 10),
        _buildTextField("Apellido", lastNameController),
        SizedBox(height: 10),
        _buildTextField("Email", emailController, isEmail: true),
        if (emailErrorMessage.isNotEmpty) _buildErrorMessage(emailErrorMessage),
        SizedBox(height: 10),
        _buildTextField("Número de Teléfono", phoneNumberController,
            isNumeric: true, maxLength: 10),
        SizedBox(height: 10),
        _buildTextField("Contraseña", passwordController, isPassword: true),
        SizedBox(height: 10),
        _buildTextField("Cédula", cedulaController,
            isNumeric: true, maxLength: 10),
        SizedBox(height: 10),
        _buildGenderSelection(),

        SizedBox(height: 10),
        _buildGreyText("Edad"),
        _buildAgeDropdown(),
        SizedBox(height: 10),
        _buildProvinceDropdown(),
        SizedBox(height: 10),
        _buildRememberForgot(),
        SizedBox(height: 10),
        _buildRegisterButton(), // Movido al final
      ],
    );
  }

  Widget _buildHeading(String text) {
    return Text(
      text,
      style: TextStyle(
        color: Colors.lightBlueAccent,
        fontSize: 32,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget _buildGreyText(String text) {
    return Text(
      text,
      style: const TextStyle(color: Color.fromARGB(255, 200, 200, 200)),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller,
      {bool isPassword = false,
      bool isNumeric = false,
      bool isEmail = false,
      int? maxLength}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildGreyText(label),
        TextField(
          controller: controller,
          onChanged: (value) {
            if (isEmail && !value.contains('@')) {
              setState(() {
                emailErrorMessage = 'El correo electrónico debe contener "@"';
              });
            } else {
              setState(() {
                emailErrorMessage = '';
              });
            }
          },
          decoration: InputDecoration(
            suffix: isPassword
                ? const Icon(Icons.remove_red_eye)
                : const Icon(Icons.done),
          ),
          obscureText: isPassword,
          keyboardType: isNumeric
              ? TextInputType.phone
              : (isEmail ? TextInputType.emailAddress : TextInputType.text),
          inputFormatters: [
            if (isNumeric) LengthLimitingTextInputFormatter(maxLength),
            if (isNumeric) FilteringTextInputFormatter.digitsOnly,
          ],
        ),
      ],
    );
  }

  Widget _buildGenderSelection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildGenderCheckbox("Mujer", isFemaleSelected, (value) {
          _updateGenderSelection(value, true, false);
        }),
        _buildGenderCheckbox("Hombre", isMaleSelected, (value) {
          _updateGenderSelection(value, false, true);
        }),
      ],
    );
  }

  void _updateGenderSelection(bool? value, bool female, bool male) {
    setState(() {
      isFemaleSelected = female && value!;
      isMaleSelected = male && value!;
    });
  }

  Widget _buildGenderCheckbox(
      String label, bool value, ValueChanged<bool?> onChanged) {
    return Row(
      children: [
        Checkbox(
          value: value,
          onChanged: onChanged,
        ),
        _buildGreyText(label),
      ],
    );
  }

  Widget _buildRememberForgot() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildRememberCheckbox(),
        TextButton(
          onPressed: () {},
          child: _buildGreyText("Olvidé mi Contraseña"),
        ),
      ],
    );
  }

  Widget _buildRememberCheckbox() {
    return Row(
      children: [
        Checkbox(
          value: rememberUser,
          onChanged: (value) {
            setState(() {
              rememberUser = value!;
            });
          },
        ),
        _buildGreyText("Recordar"),
      ],
    );
  }

  Widget _buildAgeDropdown() {
    List<int> ages = List.generate(100, (index) => index + 1);

    return DropdownButton<int>(
      value: selectedAge,
      onChanged: (int? value) {
        setState(() {
          selectedAge = value!;
        });
      },
      items: ages.map<DropdownMenuItem<int>>((int value) {
        return DropdownMenuItem<int>(
          value: value,
          child: Text(value.toString()),
        );
      }).toList(),
    );
  }

  Widget _buildProvinceDropdown() {
    List<String> provinces = [
      'Azuay',
      'Bolívar',
      'Cañar',
      'Carchi',
      'Chimborazo',
      'Cotopaxi',
      'El Oro',
      'Esmeraldas',
      'Galápagos',
      'Guayas',
      'Imbabura',
      'Loja',
      'Los Ríos',
      'Manabí',
      'Morona Santiago',
      'Napo',
      'Orellana',
      'Pastaza',
      'Pichincha',
      'Santa Elena',
      'Santo Domingo de los Tsáchilas',
      'Sucumbíos',
      'Tungurahua',
      'Zamora-Chinchipe'
    ];

    return DropdownButton<String>(
      value: selectedProvince,
      onChanged: (String? value) {
        setState(() {
          selectedProvince = value!;
        });
      },
      items: provinces.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }

  Widget _buildRegisterButton() {
    return ElevatedButton(
      onPressed: () {
        _register();
        _clearFields();
      },
      style: ElevatedButton.styleFrom(
        primary: Colors.lightBlueAccent,
      ),
      child: Text(
        "Registrar",
        style: TextStyle(color: Colors.white),
      ),
    );
  }

  void _clearFields() {
    emailController.clear();
    passwordController.clear();
    phoneNumberController.clear();
    cedulaController.clear();
    nameController.clear();
    lastNameController.clear();

    setState(() {
      rememberUser = false;
      isFemaleSelected = false;
      isMaleSelected = false;
    });
  }

  void _register() {
    if (_areFieldsValid()) {
      print("Nombre: ${nameController.text}");
      print("Apellido: ${lastNameController.text}");
      print("Email: ${emailController.text}");
      print("Phone Number: ${phoneNumberController.text}");
      print("Password: ${passwordController.text}");
      print("Cédula: ${cedulaController.text}");
      print("Is Female: $isFemaleSelected");
      print("Is Male: $isMaleSelected");
      print("Remember User: $rememberUser");
      print("Selected Age: $selectedAge");
      print("Selected Province: $selectedProvince");
    } else {
      print("Campos no llenos");
    }
  }

  bool _areFieldsValid() {
    return nameController.text.isNotEmpty &&
        lastNameController.text.isNotEmpty &&
        emailController.text.isNotEmpty &&
        phoneNumberController.text.isNotEmpty &&
        passwordController.text.isNotEmpty &&
        cedulaController.text.isNotEmpty;
  }

  Widget _buildErrorMessage(String message) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        message,
        style: TextStyle(color: Colors.red),
      ),
    );
  }
}
