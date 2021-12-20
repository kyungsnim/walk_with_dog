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
        test(),
      ],
    ));
  }
  
  test() {
    return       // Figma Flutter Generator MyWidget - FRAME
      Container(
          width: 375,
          height: 812,
          decoration: BoxDecoration(
            color : Color.fromRGBO(255, 255, 255, 1),
          ),
          child: Stack(
              children: <Widget>[
                Positioned(
                    top: 50,
                    left: 31,
                    child: Text('􀆉', textAlign: TextAlign.left, style: TextStyle(
                        color: Color.fromRGBO(0, 0, 0, 1),
                        fontFamily: 'SF Pro Text',
                        fontSize: 24,
                        letterSpacing: -0.5799999833106995,
                        fontWeight: FontWeight.normal,
                        height: 0.9166666666666666
                    ),)
                ),Positioned(
                    top: 107,
                    left: 8,
                    child: Text('나의 반려견을 등록해주세요', textAlign: TextAlign.center, style: TextStyle(
                        color: Color.fromRGBO(0, 0, 0, 1),
                        fontFamily: 'SF Pro Text',
                        fontSize: 24,
                        letterSpacing: -0.23999999463558197,
                        fontWeight: FontWeight.normal,
                        height: 0.8333333333333334
                    ),)
                ),Positioned(
                    top: 335,
                    left: 4,
                    child: Text('반려동물 이름 (예정)*', textAlign: TextAlign.center, style: TextStyle(
                        color: Color.fromRGBO(151, 151, 151, 1),
                        fontFamily: 'SF Pro Text',
                        fontSize: 12,
                        letterSpacing: -0.23999999463558197,
                        fontWeight: FontWeight.normal,
                        height: 1.6666666666666667
                    ),)
                ),Positioned(
                    top: 361,
                    left: 8,
                    child: Text('한글이름 최대 8자 이내', textAlign: TextAlign.center, style: TextStyle(
                        color: Color.fromRGBO(151, 151, 151, 1),
                        fontFamily: 'SF Pro Text',
                        fontSize: 18,
                        letterSpacing: -0.23999999463558197,
                        fontWeight: FontWeight.normal,
                        height: 1.1111111111111112
                    ),)
                ),Positioned(
                    top: 413,
                    left: 9,
                    child: Text('반려동물 생년월 (YYYYMM)', textAlign: TextAlign.center, style: TextStyle(
                        color: Color.fromRGBO(151, 151, 151, 1),
                        fontFamily: 'SF Pro Text',
                        fontSize: 12,
                        letterSpacing: -0.23999999463558197,
                        fontWeight: FontWeight.normal,
                        height: 1.6666666666666667
                    ),)
                ),Positioned(
                    top: 439,
                    left: 6,
                    child: Text('ex) 201911', textAlign: TextAlign.center, style: TextStyle(
                        color: Color.fromRGBO(151, 151, 151, 1),
                        fontFamily: 'SF Pro Text',
                        fontSize: 18,
                        letterSpacing: -0.23999999463558197,
                        fontWeight: FontWeight.normal,
                        height: 1.1111111111111112
                    ),)
                ),Positioned(
                    top: 384,
                    left: 35,
                    child: Divider(
                        color: Color.fromRGBO(0, 0, 0, 1),
                        thickness: 0.30000001192092896
                    )

                ),Positioned(
                    top: 464,
                    left: 35,
                    child: Divider(
                        color: Color.fromRGBO(0, 0, 0, 1),
                        thickness: 0.30000001192092896
                    )

                ),Positioned(
                    top: 487,
                    left: 2,
                    child: Text('반려동물 품종', textAlign: TextAlign.center, style: TextStyle(
                        color: Color.fromRGBO(151, 151, 151, 1),
                        fontFamily: 'SF Pro Text',
                        fontSize: 12,
                        letterSpacing: -0.23999999463558197,
                        fontWeight: FontWeight.normal,
                        height: 1.6666666666666667
                    ),)
                ),Positioned(
                    top: 513,
                    left: 8,
                    child: Text('품종을 작성해주세요', textAlign: TextAlign.center, style: TextStyle(
                        color: Color.fromRGBO(151, 151, 151, 1),
                        fontFamily: 'SF Pro Text',
                        fontSize: 18,
                        letterSpacing: -0.23999999463558197,
                        fontWeight: FontWeight.normal,
                        height: 1.1111111111111112
                    ),)
                ),Positioned(
                    top: 538,
                    left: 34,
                    child: Divider(
                        color: Color.fromRGBO(0, 0, 0, 1),
                        thickness: 0.30000001192092896
                    )

                ),Positioned(
                    top: 568,
                    left: 0,
                    child: Text('반려동물 성별', textAlign: TextAlign.center, style: TextStyle(
                        color: Color.fromRGBO(151, 151, 151, 1),
                        fontFamily: 'SF Pro Text',
                        fontSize: 12,
                        letterSpacing: -0.23999999463558197,
                        fontWeight: FontWeight.normal,
                        height: 1.6666666666666667
                    ),)
                ),Positioned(
                    top: 628,
                    left: 44,
                    child: Text('중성화 했어요!', textAlign: TextAlign.center, style: TextStyle(
                        color: Color.fromRGBO(151, 151, 151, 1),
                        fontFamily: 'SF Pro Text',
                        fontSize: 12,
                        letterSpacing: -0.23999999463558197,
                        fontWeight: FontWeight.normal,
                        height: 1.6666666666666667
                    ),)
                ),Positioned(
                    top: 592,
                    left: 19,
                    child: Text('성별을 클릭해주세요', textAlign: TextAlign.center, style: TextStyle(
                        color: Color.fromRGBO(151, 151, 151, 1),
                        fontFamily: 'SF Pro Text',
                        fontSize: 18,
                        letterSpacing: -0.23999999463558197,
                        fontWeight: FontWeight.normal,
                        height: 1.1111111111111112
                    ),)
                ),Positioned(
                    top: 617,
                    left: 34,
                    child: Divider(
                        color: Color.fromRGBO(0, 0, 0, 1),
                        thickness: 0.30000001192092896
                    )

                ),Positioned(
                    top: 413,
                    left: 172,
                    child: Text('반려동물 몸무게', textAlign: TextAlign.center, style: TextStyle(
                        color: Color.fromRGBO(151, 151, 151, 1),
                        fontFamily: 'SF Pro Text',
                        fontSize: 12,
                        letterSpacing: -0.23999999463558197,
                        fontWeight: FontWeight.normal,
                        height: 1.6666666666666667
                    ),)
                ),Positioned(
                    top: 439,
                    left: 200,
                    child: Text('ex) 0.0          kg', textAlign: TextAlign.center, style: TextStyle(
                        color: Colors.grey,
                        fontFamily: 'SF Pro Text',
                        fontSize: 18,
                        letterSpacing: -0.23999999463558197,
                        fontWeight: FontWeight.normal,
                        height: 1.1111111111111112
                    ),)
                ),Positioned(
                    top: 464,
                    left: 214,
                    child: Divider(
                        color: Color.fromRGBO(0, 0, 0, 1),
                        thickness: 0.30000001192092896
                    )

                ),Positioned(
                    top: 630,
                    left: 35,
                    child: Container(
                        width: 17,
                        height: 15,
                        decoration: BoxDecoration(
                          boxShadow : [BoxShadow(
                              color: Color.fromRGBO(0, 0, 0, 0.25),
                              offset: Offset(0,4),
                              blurRadius: 4
                          )],
                          color : Color.fromRGBO(255, 255, 255, 1),
                        ),
                        child: Stack(
                            children: <Widget>[
                              Positioned(
                                  top: 1.9072409868240356,
                                  left: -0.00007390975952148438,
                                  child: Image.asset(
                                      'assets/images/vector.svg',
                                  ),
                              ),
                            ]
                        )
                    )
                ),Positioned(
                    top: 750,
                    left: -3,
                    child: Container(
                        width: 383,
                        height: 104,
                        decoration: BoxDecoration(
                          color : Color.fromRGBO(229, 229, 229, 1),
                        )
                    )
                ),Positioned(
                    top: 786,
                    left: 39,
                    child: Text('산책', textAlign: TextAlign.center, style: TextStyle(
                        color: Color.fromRGBO(0, 0, 0, 0.800000011920929),
                        fontFamily: 'SF Pro Text',
                        fontSize: 12,
                        letterSpacing: -0.23999999463558197,
                        fontWeight: FontWeight.normal,
                        height: 1.6666666666666667
                    ),)
                ),Positioned(
                    top: 786,
                    left: 129,
                    child: Text('기록', textAlign: TextAlign.center, style: TextStyle(
                        color: Color.fromRGBO(0, 0, 0, 0.800000011920929),
                        fontFamily: 'SF Pro Text',
                        fontSize: 12,
                        letterSpacing: -0.23999999463558197,
                        fontWeight: FontWeight.normal,
                        height: 1.6666666666666667
                    ),)
                ),Positioned(
                    top: 753,
                    left: 39,
                    child: Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          color : Color.fromRGBO(255, 255, 255, 1),
                        ),
                        child: Stack(
                            children: <Widget>[
                              Positioned(
                                  top: 0.46875,
                                  left: 0.46875,
                                  child: Image.asset(
                                      'assets/images/vector.svg',
                                  ),
                              ),
                            ]
                        )
                    )
                ),Positioned(
                    top: 786,
                    left: 207,
                    child: Text('플레이스', textAlign: TextAlign.center, style: TextStyle(
                        color: Color.fromRGBO(0, 0, 0, 0.800000011920929),
                        fontFamily: 'SF Pro Text',
                        fontSize: 12,
                        letterSpacing: -0.23999999463558197,
                        fontWeight: FontWeight.normal,
                        height: 1.6666666666666667
                    ),)
                ),Positioned(
                    top: 786,
                    left: 295,
                    child: Text('MY', textAlign: TextAlign.center, style: TextStyle(
                        color: Color.fromRGBO(0, 0, 0, 0.800000011920929),
                        fontFamily: 'SF Pro Text',
                        fontSize: 12,
                        letterSpacing: -0.23999999463558197,
                        fontWeight: FontWeight.normal,
                        height: 1.6666666666666667
                    ),)
                ),Positioned(
                    top: 755,
                    left: 219,
                    child: Container(
                        width: 32,
                        height: 26,
                        decoration: BoxDecoration(
                          color : Color.fromRGBO(255, 255, 255, 1),
                        ),
                        child: Stack(
                            children: <Widget>[
                              Positioned(
                                  top: 0,
                                  left: 0.0031753848306834698,
                                  child: Image.asset(
                                      'assets/images/vector.svg',
                                     ),
                              ),
                            ]
                        )
                    )
                ),Positioned(
                    top: 753,
                    left: 135,
                    child: Container(
                        width: 20,
                        height: 27,
                        decoration: BoxDecoration(
                          color : Color.fromRGBO(255, 255, 255, 1),
                        ),
                        child: Stack(
                            children: <Widget>[
                              Positioned(
                                  top: 0,
                                  left: 0,
                                  child: Image.asset(
                                      'assets/images/vector.svg',
                                     ),
                              ),
                            ]
                        )
                    )
                ),Positioned(
                    top: 753,
                    left: 308,
                    child: Container(
                        width: 32,
                        height: 29,
                        decoration: BoxDecoration(
                          color : Color.fromRGBO(255, 255, 255, 1),
                        ),
                        child: Stack(
                            children: <Widget>[
                              Positioned(
                                  top: 1.8153586387634277,
                                  left: -0.0007057502516545355,
                                  child: Image.asset(
                                      'assets/images/vector.svg',
                                     ),
                              ),
                            ]
                        )
                    )
                ),Positioned(
                    top: 680,
                    left: 32,
                    child: Image.asset(
                        'assets/images/rectangle231.svg',
                    ),
                ),Positioned(
                    top: 680,
                    left: 32,
                    child: Image.asset(
                        'assets/images/rectangle232.svg',
                    ),
                ),Positioned(
                    top: 691,
                    left: 176,
                    child: Text('완 료', textAlign: TextAlign.left, style: TextStyle(
                        color: Color.fromRGBO(255, 255, 255, 1),
                        fontFamily: 'Noto Sans',
                        fontSize: 15,
                        letterSpacing: -0.4099999964237213,
                        fontWeight: FontWeight.normal,
                        height: 1.4666666666666666
                    ),)
                ),Positioned(
                    top: 169,
                    left: 135,
                    child: Container(
                        width: 120,
                        height: 120,

                        child: Stack(
                            children: <Widget>[
                              Positioned(
                                  top: 0,
                                  left: 0,
                                  child: Container(
                                      width: 120,
                                      height: 120,

                                      child: Stack(
                                          children: <Widget>[
                                            Positioned(
                                                top: 0,
                                                left: 0,
                                                child: Container(
                                                    width: 120,
                                                    height: 120,

                                                    child: Stack(
                                                        children: <Widget>[
                                                          Positioned(
                                                              top: 0,
                                                              left: 0,
                                                              child: Container(
                                                                  width: 120,
                                                                  height: 120,
                                                                  decoration: BoxDecoration(
                                                                    color : Color.fromRGBO(184, 233, 255, 1),
                                                                    borderRadius : BorderRadius.all(Radius.elliptical(120, 120)),
                                                                  )
                                                              )
                                                          ),
                                                        ]
                                                    )
                                                )
                                            ),Positioned(
                                                top: 16,
                                                left: 16,
                                                child: Container(
                                                    width: 85,
                                                    height: 75,
                                                    decoration: BoxDecoration(
                                                      color : Color.fromRGBO(255, 255, 255, 1),
                                                    ),
                                                    child: Stack(
                                                        children: <Widget>[
                                                          Positioned(
                                                              top: 4.6832756996154785,
                                                              left: 4.722224235534668,
                                                              child: Image.asset(
                                                                  'assets/images/vector.svg',
                                                              ),
                                                          ),
                                                        ]
                                                    )
                                                )
                                            ),
                                          ]
                                      )
                                  )
                              ),Positioned(
                                  top: 78,
                                  left: 81,
                                  child: Container(
                                      width: 27,
                                      height: 27,

                                      child: Stack(
                                          children: <Widget>[
                                            Positioned(
                                                top: 0,
                                                left: 0,
                                                child: Container(
                                                    width: 27,
                                                    height: 27,

                                                    child: Stack(
                                                        children: <Widget>[
                                                          Positioned(
                                                              top: 0,
                                                              left: 0,
                                                              child: Container(
                                                                  width: 27,
                                                                  height: 27,
                                                                  decoration: BoxDecoration(
                                                                    color : Color.fromRGBO(255, 255, 255, 1),
                                                                    borderRadius : BorderRadius.all(Radius.elliptical(27, 27)),
                                                                  )
                                                              )
                                                          ),
                                                        ]
                                                    )
                                                )
                                            ),Positioned(
                                                top: 3,
                                                left: 5,
                                                child: Container(
                                                    width: 18,
                                                    height: 20,
                                                    decoration: BoxDecoration(
                                                      color : Color.fromRGBO(184, 233, 255, 1),
                                                    ),
                                                    child: Stack(
                                                        children: <Widget>[
                                                          Positioned(
                                                              top: 1.25,
                                                              left: 0,
                                                              child: Image.asset(
                                                                  'assets/images/vector.svg',
                                                              ),
                                                          ),
                                                        ]
                                                    )
                                                )
                                            ),
                                          ]
                                      )
                                  )
                              ),
                            ]
                        )
                    )
                ),
              ]
          )
      );
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
