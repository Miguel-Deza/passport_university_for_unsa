import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class MotivameScreen extends StatefulWidget {
  @override
  State<MotivameScreen> createState() => _MotivameScreenState();
}

class _MotivameScreenState extends State<MotivameScreen> {
  List<String> ListMotivationalQuotes=[
    "El único modo de hacer un gran trabajo es amar lo que haces - Steve Jobs",
    "Nunca pienso en las consecuencias de fallar un gran tiro… cuando se piensa en las consecuencias se está pensando en un resultado negativo - Michael Jordan",
  "El dinero no es la clave del éxito; la libertad para poder crear lo es - Nelson Mandela",
  "Cuanto más duramente trabajo, más suerte tengo - Gary Player",
  "La inteligencia consiste no sólo en el conocimiento, sino también en la destreza de aplicar los conocimientos en la práctica - Aristóteles",
  "El trabajo duro hace que desaparezcan las arrugas de la mente y el espíritu - Helena Rubinstein",
  "Cuando algo es lo suficientemente importante, lo haces incluso si las probabilidades de que salga bien no te acompañan - Elon Musk",
  "Escoge un trabajo que te guste, y nunca tendrás que trabajar ni un solo día de tu vida - Confucio",
  "Un sueño no se hace realidad por arte de magia, necesita sudor, determinación y trabajo duro - Colin Powell",
  "Cuéntamelo y me olvidaré. enséñamelo y lo recordaré. involúcrame y lo aprenderé - Benjamin Franklin",
  "La lógica te llevará de la a a la z. la imaginación te llevará a cualquier lugar - Albert Einstein",
  "A veces la adversidad es lo que necesitas encarar para ser exitoso - Zig Ziglar",
  "Para tener éxito tu deseo de alcanzarlo debe ser mayor que tu miedo al fracaso - Bill Cosby",
  "Ejecuta tus conocimientos con la maestría del que sigue aprendiendo - Jonathan García-Allen",
  ];

  String getRandomString(){
    String randomItem = (ListMotivationalQuotes.toList()..shuffle()).first;
    return randomItem;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
              SizedBox(
              width: 250.0,
              child: DefaultTextStyle(
                style: const TextStyle(
                  fontSize: 30.0,
                  fontFamily: 'Agne',
                  color: Colors.black
                ),
                child: AnimatedTextKit(
                  totalRepeatCount: 1,
                  animatedTexts: [
                    TypewriterAnimatedText(getRandomString(),),
                  ],
                ),
              ),
            ),


              ],
            ),
          ),
        ),
      ),
    );
  }
}
