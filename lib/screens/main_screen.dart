import 'package:flutter/material.dart';
import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/services.dart';
import 'package:passport_university_for_unsa/screens/motivame_screen.dart';
import 'package:passport_university_for_unsa/screens/update_data_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';

import 'package:image_picker/image_picker.dart';
import 'package:passport_university_for_unsa/screens/select_photo_options_screen.dart';
import 'package:image_cropper/image_cropper.dart';
import 'dart:io';

// TODO: Import ad_helper.dart
import 'package:passport_university_for_unsa/ad_helper.dart';

// TODO: Import google_mobile_ads.dart
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../widgets/common_buttons.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});
  

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {

  // TODO: Add _bannerAd
  BannerAd? _bannerAd;

  // Persistance
  String appDocPath = "";

  // Camara Implementation
  File? _image;

  Future _pickImage(ImageSource source) async {
    try {
      final image = await ImagePicker().pickImage(source: source);
      if (image == null) return;

      File? img = File(image.path);
      img = await _cropImage(imageFile: img);

      final fileName = 'carnet_image.png';
      _image = await img!.copy('${appDocPath}/$fileName');

      setState(() {
        _image = img;
      });

    } on PlatformException catch (e) {
      print(e);
    }
  }

  Future<File?> _cropImage({required File imageFile}) async {
    CroppedFile? croppedImage =
        await ImageCropper().cropImage(sourcePath: imageFile.path,
        aspectRatioPresets: [
          CropAspectRatioPreset.ratio3x2,
        ]);
    if (croppedImage == null) return null;
    return File(croppedImage.path);
  }

  void _showSelectPhotoOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(25.0),
        ),
      ),
      builder: (context) => DraggableScrollableSheet(
          initialChildSize: 0.28,
          maxChildSize: 0.4,
          minChildSize: 0.28,
          expand: false,
          builder: (context, scrollController) {
            return SingleChildScrollView(
              controller: scrollController,
              child: SelectPhotoOptionsScreen(
                onTap: _pickImage,
              ),
            );
          }),
    );
  }

  // final image

  final Future<SharedPreferences> prefs = SharedPreferences.getInstance();
  String? futureCodeStudent = '';

  void getCodeStudentStore() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      futureCodeStudent = prefs.getString('storeCodeStudent') ?? '';
    });
  }

  void getApplicationDirectoryPath() async {
    Directory appDocDir = await getApplicationDocumentsDirectory();
    appDocPath = appDocDir.path;
  }

  void getInitialPhotoFromStore() async{
    Directory appDocDir = await getApplicationDocumentsDirectory();
    appDocPath = appDocDir.path;

    if(await File('${appDocPath}/carnet_image.png').exists()){
      _image = File('${appDocPath}/carnet_image.png');
    }

  }

  @override
  void initState() {
    getCodeStudentStore();

    getApplicationDirectoryPath();
    getInitialPhotoFromStore();

    BannerAd(
      adUnitId: AdHelper.bannerAdUnitId,
      request: AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          setState(() {
            _bannerAd = ad as BannerAd;
          });
        },
        onAdFailedToLoad: (ad, err) {
          print('Failed to load a banner ad: ${err.message}');
          ad.dispose();
        },
      ),
    ).load();

    super.initState();
  }

  @override
  void dispose() {
    // TODO: Dispose a BannerAd object
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text("PASSPORT UNIVERSITY 💳", style: TextStyle(
              fontSize: 30.0,
              fontWeight: FontWeight.w900
            ),),
            SizedBox(
              height: 10,

            ),
            Container(
              height: 250.0,
              width: 250.0,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey.shade200,
              ),
              child: Center(
                child: _image == null
                    ? const Text(
                        'Foto de carnet o DNI',
                        style: TextStyle(fontSize: 20),
                      )
                    : Image.file(_image!)
                    // : FileImage(_image!)
              ),
            ),
            BarcodeWidget(
                padding: const EdgeInsets.all(20),
                height: 100.0,
                barcode: Barcode.code39(),
                data: futureCodeStudent ?? '',
                errorBuilder: (context, error) => Center(
                        child: RichText(
                      text: const TextSpan(
                        children: [
                          TextSpan(
                            text: "Aqui estará ",
                            style: TextStyle(color: Colors.black),
                          ),
                          WidgetSpan(
                            child: Icon(
                              Icons.card_membership,
                              size: 20,
                              color: Colors.blue,
                            ),
                          ),
                          TextSpan(
                            text: " tu codigo de barras",
                            style: TextStyle(color: Colors.black),
                          ),
                        ],
                      ),
                    ),),),
            Row(
              children: [
                Expanded(
                  child: CommonButtons(
                    onTap: () => _showSelectPhotoOptions(context),
                    backgroundColor: Colors.black,
                    textColor: Colors.white,
                    textLabel: 'Añadir foto',
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: CommonButtons(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MotivameScreen()),
                    ),
                    backgroundColor: Colors.black,
                    textColor: Colors.white,
                    textLabel: 'Motivame',
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            CommonButtons(
              onTap: () async{
              futureCodeStudent = await Navigator.push(
              context,
              MaterialPageRoute(
              builder: (context) => const UpdateDataScreen()),
              );
              // obtain shared preferences
              if (futureCodeStudent != null) {
                final prefs = await SharedPreferences.getInstance();
                await prefs.setString('storeCodeStudent', futureCodeStudent!);
                setState(() {
                futureCodeStudent;
                },);
              }
            },
              backgroundColor: Colors.teal,
              textColor: Colors.white,
              textLabel: 'Crear mi pasaporte',
            ),
            SizedBox(
              height: 10.0,
            ),
            // TODO: Display a banner when ready
            if (_bannerAd != null)
              Align(
                alignment: Alignment.topCenter,
                child: Container(
                  width: _bannerAd!.size.width.toDouble(),
                  height: _bannerAd!.size.height.toDouble(),
                  child: AdWidget(ad: _bannerAd!),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
