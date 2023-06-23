import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SubmitButton extends StatefulWidget {
  const SubmitButton({super.key, required this.onTap, required this.text});

  final Function()? onTap;
  final String text;

  @override
  State<SubmitButton> createState() => _BigButtonState();
}

class _BigButtonState extends State<SubmitButton> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        setState(() {
          isLoading = true;
        });
        await widget.onTap!();
        setState(() {
          isLoading = false;
        });
      },
      child: Container(
        height: 51,
        margin: const EdgeInsets.symmetric(horizontal: 25),
        decoration: BoxDecoration(
          color: Colors.indigo.shade400,
          borderRadius: BorderRadius.circular(100),
        ),
        child: Center(
          child: isLoading
              ? const CircularProgressIndicator()
              : Text(
                  widget.text,
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
        ),
      ),
    );
  }
}
