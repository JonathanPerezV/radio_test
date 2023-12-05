import 'package:flutter/material.dart';

class QuienesSomos extends StatefulWidget {
  const QuienesSomos({super.key});

  @override
  State<QuienesSomos> createState() => _QuienesSomosState();
}

class _QuienesSomosState extends State<QuienesSomos> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromRGBO(33, 29, 82, 1),
          title: const Text(
            "Quiénes somos",
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true,
          leading: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back, color: Colors.white)),
        ),
        backgroundColor: const Color.fromRGBO(33, 29, 82, 1),
        body: options());
  }

  Widget options() => Container(
        margin: const EdgeInsets.only(left: 15, right: 15),
        child: const SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                width: double.infinity,
                child: Text(
                  "INTRODUCCIÓN",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Text(
                """La libertad no se ejerce sin responsabilidad. Quienes hacemos Radio HORIZONTES 94.9 de El Carmen, Manabí; concesionario, administradores y colaboradores, al tener el enorme privilegio de dirigirnos con mensajes a la sociedad, contraemos con ella compromisos y deberes.
          La responsabilidad que tenemos con la sociedad nos obliga a que nos desempeñemos con especial cuidado en nuestra tarea de informar, entretener, orientar y contribuir a la educación.
          Tales tareas la entendemos como servicio, independientemente que para desempeñarlas nos consolidemos como medio de comunicación con credibilidad e identidad propia.
          """,
                textAlign: TextAlign.justify,
                style: TextStyle(color: Colors.white),
              ),
              SizedBox(height: 15),
              SizedBox(
                width: double.infinity,
                child: Text(
                  "MISIÓN",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Text(
                """• Radio Horizontes es un medio de comunicación de la ciudad de El Carmen, que busca aportar en la solución de las necesidades de información y entretenimiento de la comunidad carmense mediante un contenido radial generalista de calidad.
          """,
                textAlign: TextAlign.justify,
                style: TextStyle(color: Colors.white),
              ),
              SizedBox(height: 15),
              SizedBox(
                width: double.infinity,
                child: Text(
                  "VISIÓN",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Text(
                """• Ser un símbolo de desarrollo de El Carmen incorporando una programación que destaque por su contenido informativo y de entretenimiento comprometido con la cohesión social y la búsqueda de bienestar de la comunidad, manteniendo un contacto permanente y directo con los habitantes de las zonas urbanas y rurales.
""",
                textAlign: TextAlign.justify,
                style: TextStyle(color: Colors.white),
              ),
              SizedBox(height: 15),
              Text(
                """Lic. Segundo Wilfrido Vera Vera
GERENTE""",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 15),
            ],
          ),
        ),
      );
}
