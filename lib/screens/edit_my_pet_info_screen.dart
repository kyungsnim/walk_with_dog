import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:walk_with_dog/models/my_pet_model.dart';

class EditMyPetInfoScreen extends StatefulWidget {
  int? index;

  EditMyPetInfoScreen(this.index, {Key? key}) : super(key: key);

  @override
  _EditMyPetInfoScreenState createState() => _EditMyPetInfoScreenState();
}

class _EditMyPetInfoScreenState extends State<EditMyPetInfoScreen> {
  String _imagePath = '';
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        _myPetInfo(),
        // test(),
      ],
    ));
  }

  _myPetInfo() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 24,
      ),
      child: Column(
        children: [
          SizedBox(height: Get.height * 0.15),
          Text(
            '나의 반려견을 등록해주세요',
            style: TextStyle(
              fontSize: Get.width * 0.065,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  myProfilePhoto() {
    return InkWell(
      onTap: () => getGalleryImage(),
      child: SizedBox(
        height: 150.0,
        width: 150.0,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(200),
          child: Image.asset(
            _imagePath,
            fit: BoxFit.fill,
          ),
        ),
      ),
    );
  }

  Future getGalleryImage() async {
    // List<XFile>? pickedFileList = await ImagePicker().pickMultiImage();
    XFile? pickedFile = await ImagePicker()
        .pickImage(source: ImageSource.gallery, imageQuality: 50);
    // final tempDir = await getTemporaryDirectory();
    // final path = tempDir.path;
    // int rand = new Math.Random().nextInt(10000);
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      _imagePath = pickedFile!.path;
      prefs.setString('imagePath}', _imagePath);
    });
  }
}
