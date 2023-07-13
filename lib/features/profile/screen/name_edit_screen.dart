import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gurme/common/utils/lose_focus.dart';

class EditNameScreen extends StatefulWidget {
  const EditNameScreen({super.key});

  @override
  State<EditNameScreen> createState() => _EditNameScreenState();
}

class _EditNameScreenState extends State<EditNameScreen> {
  final TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    controller.text = "asdasdsa";
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: loseFocus,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.indigo.shade400,
          centerTitle: true,
          title: Text(
            "Ad Soyad",
            style: GoogleFonts.inter(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: 20,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {},
              child: Text(
                "Kaydet",
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 14,
                ),
              ),
            )
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
          child: TextFormField(
            controller: controller,
            maxLength: 30,
            decoration: InputDecoration(
              fillColor: Colors.grey.shade100,
              hintMaxLines: 30,
              enabledBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: Color(0xFFE8E8E8)),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey.shade400),
              ),
              hintStyle: GoogleFonts.inter(
                color: const Color(0xFFBDBDBD),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
