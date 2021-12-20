import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:walk_with_dog/models/my_pet_model.dart';

import 'edit_my_pet_info_screen.dart';

class MyScreen extends StatefulWidget {
  const MyScreen({Key? key}) : super(key: key);

  @override
  _MyScreenState createState() => _MyScreenState();
}

class _MyScreenState extends State<MyScreen> {
  String _imagePath = '';
  File? _imageFile;
  List<MyPetModel> _myPetList = [
    MyPetModel('뭉치', '20200101', '5', '포메라니안', '남', ''),
    MyPetModel('덤보', '20210205', '5.1', '포메라니안', '여', ''),
    MyPetModel('우동', '20200607', '4.2', '포메라니안', '남', ''),
    MyPetModel('하양', '20201212', '6.2', '포메라니안', '여', '')
  ];
  @override
  initState() {
    super.initState();
    getImagePath();
  }

  getImagePath() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (prefs.getString('imagePath') != null) {
      setState(() {
        _imagePath = prefs.getString('imagePath')!;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        SizedBox(
          height: Get.height * 0.1,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _imagePath.isEmpty ? needRegisterProfilePhoto() : myProfilePhoto()
          ],
        ),
        const SizedBox(
          height: 20,
        ),
        Column(
          children: [
            headArea(),
            Divider(),
            myPetAreaList(),
          ],
        ),
      ],
    ));
  }

  needRegisterProfilePhoto() {
    return InkWell(
      onTap: () => getGalleryImage(),
      child: Container(
        alignment: Alignment.center,
        height: 150,
        width: 150,
        child: const Text(
          'No Image',
          style: TextStyle(color: Colors.white),
          textAlign: TextAlign.center,
        ),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50), color: Colors.grey),
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
      prefs.setString('imagePath', _imagePath);

      /// image picker XFile to make file
      _imageFile = File(pickedFile.path);
    });
  }

  headArea() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Image.asset(
                'assets/icon/foot.png',
                width: 25,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text('반려견',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: Get.width * 0.06,)),
            ),
            Spacer(),
            Text(
              '추가',
              style: TextStyle(
                fontSize: Get.width * 0.05,
                color: Colors.blueAccent
              ),
            ),
          ],
        ),
      ),
    );
  }

  myPetAreaList() {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: _myPetList.length,
      itemBuilder: (context, index) {
        return  Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Flexible(flex: 5,child: Text(_myPetList[index].name!, style: TextStyle(fontSize: Get.width * 0.06),)),
              Flexible(flex: 3,child: InkWell(onTap: () => Get.to(() => EditMyPetInfoScreen(index)), child: Text('정보 변경하기', style: TextStyle(fontSize: Get.width * 0.05, color: Colors.grey),))),
              Flexible(flex: 1,child: InkWell(onTap: () => setState(() => _myPetList.removeAt(index)),child: Text('삭제', style: TextStyle(fontSize: Get.width * 0.05, color: Colors.grey),))),
            ],
          ),
        );
      },
    );
  }
}
