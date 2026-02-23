
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../core/exports/main_exports.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({super.key});

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        hintText: "search",
        fillColor: Colors.white,
        filled: true,
        enabledBorder: buildOutlineInputBorder(),
        focusedBorder: buildOutlineInputBorder(),
        suffixIcon: IconButton(
          onPressed: () {},
          icon: Opacity(
              opacity: 0.5,
              child: Icon(FontAwesomeIcons.magnifyingGlass, size: 20)),
        ),
      ),
    );
  }

  OutlineInputBorder buildOutlineInputBorder() {
    return OutlineInputBorder(
      borderSide: BorderSide(color: Colors.white),
      borderRadius: BorderRadius.circular(15),
    );
  }
}
