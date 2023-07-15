import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gurme/common/utils/lose_focus.dart';
import 'package:gurme/features/auth/controller/auth_controller.dart';
import 'package:gurme/features/profile/controller/profile_controller.dart';
import 'package:gurme/models/user_model.dart';

class EditNameScreen extends ConsumerStatefulWidget {
  final String name;
  const EditNameScreen({super.key, required this.name});

  @override
  ConsumerState<EditNameScreen> createState() => _EditNameScreenState();
}

class _EditNameScreenState extends ConsumerState<EditNameScreen> {
  final TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    controller.text = widget.name;
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Future<void> updateName(UserModel user, String newName) async {
    return await ref
        .read(profileControllerProvider.notifier)
        .updateUserName(user, newName);
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider.notifier).state!;
    return GestureDetector(
      onTap: loseFocus,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size(double.infinity, 60),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
              child: AppBar(
                automaticallyImplyLeading: true,
                titleSpacing: 0,
                iconTheme: const IconThemeData().copyWith(
                  color: Colors.black,
                ),
                backgroundColor: Theme.of(context).canvasColor,
                foregroundColor: const Color.fromRGBO(246, 246, 246, 0.5),
                elevation: 2,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(8),
                  ),
                  side: BorderSide(
                    color: Color(0xFFE8E8E8),
                  ),
                ),
                centerTitle: true,
                title: Text(
                  "Ad Soyad",
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontSize: 20,
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () async {
                      final newName = controller.text.trim();
                      await updateName(user, newName)
                          .then((value) => context.pop());
                    },
                    child: Text(
                      "Kaydet",
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  const SizedBox(width: 7),
                ],
              ),
            ),
          ),
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
