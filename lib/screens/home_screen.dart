import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:walk_with_dog/screens/my_screen.dart';

import '../main.dart';

class HomeScreen extends StatefulWidget {
  final int getPageIndex;
  const HomeScreen({required this.getPageIndex, Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  bool isLoading = false;
  int? currentIndex;

  // 페이지 컨트롤
  PageController? pageController;
  int getPageIndex = 0;

  String myToken = '';

  @override
  void initState() {
    super.initState();

    currentIndex = widget.getPageIndex;
    setState(() {
      getPageIndex = widget.getPageIndex;
    });
    pageController = PageController(
      // 다른 페이지에서 넘어올 때도 controller를 통해 어떤 페이지 보여줄 것인지 셋팅
        initialPage: getPageIndex != null ? this.getPageIndex : 0);

    // WidgetsBinding.instance!.addObserver(this);
    // setStatus('Online');
  }

  @override
  void dispose() {
    pageController!.dispose();
    super.dispose();
  }

  whenPageChanges(int pageIndex) {
    setState(() {
      this.getPageIndex = pageIndex;
    });
  }

  onTapChangePage(int pageIndex) {
    pageController!
        .animateToPage(pageIndex, duration: Duration(milliseconds: 100), curve: Curves.bounceInOut);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => showExitDialog(),
      child: DefaultTabController(
        length: 4,
        initialIndex: currentIndex!,
        child: Scaffold(
          body: PageView(
            children: [
              Container(),
              Container(),
              Container(),
              MyScreen(),
            ],
            controller: pageController, // controller를 지정해주면 각 페이지별 인덱스로 컨트롤 가능
            onPageChanged:
            whenPageChanges, // page가 바뀔때마다 whenPageChanges 함수가 호출되고 현재 pageIndex 업데이트해줌
          ),
          bottomNavigationBar: BottomNavigationBar(
            // Bar에 텍스트 라벨 안보이게 변경
            // showSelectedLabels: false,
            // showUnselectedLabels: false,
            backgroundColor: Colors.white,
            currentIndex: this.getPageIndex,
            onTap: onTapChangePage,
            selectedItemColor: Colors.black,
            selectedIconTheme: IconThemeData(size: 40),
            selectedFontSize: 16,
            selectedLabelStyle:
            TextStyle(fontFamily: 'Nanum', fontWeight: FontWeight.bold, color: Colors.black),
            unselectedItemColor: Colors.grey,
            unselectedFontSize: 12,
            // iconSize: 20,
            type: BottomNavigationBarType.fixed,
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                  icon: Image.asset(
                    'assets/icon/bottom1.png',
                    width: 20,
                  ),
                  activeIcon: Image.asset(
                    'assets/icon/bottom1.png',
                    width: 30,
                  ),
                  label: '산책'),
              BottomNavigationBarItem(
                  icon: Image.asset(
                    'assets/icon/bottom2.png',
                    width: 15,
                  ),
                  activeIcon: Image.asset(
                    'assets/icon/bottom2.png',
                    width: 25,
                  ),
                  label: '기록'),
              BottomNavigationBarItem(
                  icon: Image.asset(
                    'assets/icon/bottom3.png',
                    width: 20,
                  ),
                  activeIcon: Image.asset(
                    'assets/icon/bottom3.png',
                    width: 30,
                  ),
                  label: '플레이스'),
              BottomNavigationBarItem(
                  icon: Image.asset(
                    'assets/icon/bottom4.png',
                    width: 20,
                  ),
                  activeIcon: Image.asset(
                    'assets/icon/bottom4.png',
                    width: 30,
                  ),
                  label: 'MY'),
            ],
          ),
        ),
      ),
    );
  }

  showExitDialog() async {
    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('앱 종료',
                style: TextStyle(
                  fontFamily: 'Binggrae',
                )),
            content: Text(
              '종료하시겠습니까?',
              style: TextStyle(fontFamily: 'Binggrae'),
            ),
            actions: [
              ElevatedButton(
                child: Container(
                  padding: const EdgeInsets.all(8),
                  child: Text('확인', style: TextStyle(fontFamily: 'Binggrae', fontSize: 16)),
                ),
                style: ElevatedButton.styleFrom(primary: Colors.blueAccent),
                onPressed: () async {
                  SystemNavigator.pop();
                },
              ),
              ElevatedButton(
                child: Container(
                  padding: const EdgeInsets.all(8),
                  child: Text('취소', style: TextStyle(fontFamily: 'Binggrae', fontSize: 16)),
                ),
                style: ElevatedButton.styleFrom(primary: Colors.grey),
                onPressed: () async {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
  }
}
