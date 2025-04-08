import 'package:flutter/material.dart';

// Define el widget de botones de navegación
class BottomNavigationBarButtons extends StatelessWidget {
  const BottomNavigationBarButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.1,
      decoration: const BoxDecoration(
        color: Color(0xFF2B2B2B),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(width: 20), // Espacio antes de los botones
          IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Theme.of(context).colorScheme.primary, // Usando el color primario del tema
              size: 24,
            ),
            onPressed: () {
              print('IconButton pressed ...');
            },
          ),
          const SizedBox(width: 30), // Espacio entre botones
          IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Theme.of(context).colorScheme.primary, // Usando el color primario del tema
              size: 24,
            ),
            onPressed: () {
              print('IconButton pressed ...');
            },
          ),
          const SizedBox(width: 30), // Espacio entre botones
          IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Theme.of(context).colorScheme.primary, // Usando el color primario del tema
              size: 24,
            ),
            onPressed: () {
              print('IconButton pressed ...');
            },
          ),
          const SizedBox(width: 30), // Espacio entre botones
          IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Theme.of(context).colorScheme.primary, // Usando el color primario del tema
              size: 24,
            ),
            onPressed: () {
              print('IconButton pressed ...');
            },
          ),
          const SizedBox(width: 20), // Espacio después de los botones
        ],
      ),
    );
  }
}

// Define el widget de MonthButton
class MonthButton extends StatelessWidget {
  const MonthButton({
    super.key,
    required this.monthName,
    required this.backgroundColor,
    required this.textColor,
    required this.textStyle,
  });

  final String monthName;
  final Color backgroundColor;
  final Color textColor;
  final TextStyle textStyle;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.3,
      height: MediaQuery.of(context).size.height * 0.13,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Align(
        alignment: Alignment.center,
        child: Text(
          monthName,
          style: textStyle.copyWith(color: textColor),
        ),
      ),
    );
  }
}

// Define el widget de MonthSelector
class MonthSelector extends StatelessWidget {
  const MonthSelector({super.key});

  @override
  Widget build(BuildContext context) {
    final Color monthButtonBackgroundColor = Theme.of(context).primaryColor;
    final Color monthButtonTextColor = Colors.white;
    const TextStyle monthButtonTextStyle = TextStyle(
      fontFamily: 'Inter',
      fontSize: 18,
      letterSpacing: 0.0,
      fontWeight: FontWeight.w600,
    );

    return Align(
      alignment: AlignmentDirectional(0, 0),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              MonthButton(
                monthName: 'JANUARY',
                backgroundColor: monthButtonBackgroundColor,
                textColor: monthButtonTextColor,
                textStyle: monthButtonTextStyle,
              ),
              MonthButton(
                monthName: 'FEBRUARY',
                backgroundColor: monthButtonBackgroundColor,
                textColor: monthButtonTextColor,
                textStyle: monthButtonTextStyle,
              ),
              MonthButton(
                monthName: 'MARCH',
                backgroundColor: monthButtonBackgroundColor,
                textColor: monthButtonTextColor,
                textStyle: monthButtonTextStyle,
              ),
              MonthButton(
                monthName: 'APRIL',
                backgroundColor: monthButtonBackgroundColor,
                textColor: monthButtonTextColor,
                textStyle: monthButtonTextStyle,
              ),
              // Puedes agregar más botones de meses aquí
            ].expand((monthButton) => [monthButton, const SizedBox(width: 8)]).toList(), // Añadiendo espacio entre los botones
          ),
        ),
      ),
    );
  }
}

// La pantalla principal que usa BottomNavigationBarButtons y MonthSelector
class MonthScreen extends StatelessWidget {
  const MonthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Month Selector Screen"),
      ),
      body: Column(
        children: [
          // Primer widget, el selector de meses
          const MonthSelector(),
          // Un espacio entre el selector de meses y la barra de navegación
          const SizedBox(height: 20),
          // Segundo widget, los botones de navegación
          const BottomNavigationBarButtons(),
        ],
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: const MonthScreen(),
  ));
}

