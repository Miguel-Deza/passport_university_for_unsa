import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

class UpdateDataScreen extends StatefulWidget {
  const UpdateDataScreen({Key? key}) : super(key: key);

  @override
  _UpdateDataScreenState createState() => _UpdateDataScreenState();
}

class _UpdateDataScreenState extends State<UpdateDataScreen> {
  String codeStudent = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(50.0),
        child: Column(
          children: [
            TextField(
              onChanged: (value) => codeStudent = value.toUpperCase(),
              textCapitalization: TextCapitalization.characters,
              decoration: const InputDecoration(
                hintText: 'Ingresa tu codigo',
                labelText: 'Codigo de estudiante',
              ),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp('[a-zA-Z0-9]')),
                LengthLimitingTextInputFormatter(8),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: ElevatedButton.icon(
                onPressed: () {
                  if(codeStudent==""){
                    AwesomeDialog(
                          context: context,
                          dialogType: DialogType.error,
                          animType: AnimType.rightSlide,
                          title: 'Código Invalido',
                          desc: 'No has ingreso ningún código',
                      btnCancelOnPress: () {},
                    )..show();
                  }else{
                    FocusManager.instance.primaryFocus?.unfocus();
                    AwesomeDialog(
                    context: context,
                    dialogType: DialogType.success,
                    animType: AnimType.rightSlide,
                    title: 'Codigo generado',
                    desc: 'Tu codigo se genero con éxito',
                    btnOkOnPress: () {
                    Navigator.pop(context, codeStudent);
                    },
                  )..show();
                  }
                },
                icon: const Icon(Icons.fiber_new_rounded),
                label: const Text("Generar Codigo de barras"),
              ),
            ),
            const Expanded(
                child: FittedBox(
                    child:
                        Icon(Icons.camera_front_rounded, color: Colors.teal))),
          ],
        ),
      ),
    );
  }
}
