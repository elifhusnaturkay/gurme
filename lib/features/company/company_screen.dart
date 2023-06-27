import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gurme/common/constants/asset_constants.dart';

class CompanyScreen extends ConsumerStatefulWidget {
  const CompanyScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CompanyScreenState();
}

class _CompanyScreenState extends ConsumerState<CompanyScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverAppBar(
            expandedHeight: 150,
            floating: true,
            flexibleSpace: Stack(
              children: [
                Positioned.fill(
                  child: Image.network(
                    AssetConstants.defaultBannerPic,
                    fit: BoxFit.cover,
                  ),
                )
              ],
            ),
          ),
          SliverAppBar(
            elevation: 0,
            pinned: true,
            centerTitle: false,
            backgroundColor: ThemeData.light().canvasColor,
            title: Text(
              "Restoran",
              style: GoogleFonts.inter(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
        ],
        body: ListView(
          children: const [
            Row(
              children: [
                Text("data"),
              ],
            )
          ],
        ),
      ),
    );
  }
}
