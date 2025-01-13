import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pinned/screens/home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      // home: const NamePage(title: 'Input Name'),
      home: SelectPage(),
    );
  }
}

class SelectPage extends StatefulWidget {
  const SelectPage({super.key});

  @override
  _SelectPageState createState() => _SelectPageState();
}

class _SelectPageState extends State<SelectPage> {
  // selectedChar가 null이면 0을 기본값으로 사용
  bool logined = false;

  @override
  void initState() {
    super.initState();
  }

  void toggleSelect(value) {
    setState(() {
      logined = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffffffff),
      appBar: AppBar(),
      body: Center(
        child: Column(
          children: [
            SizedBox(
              height: 200,
            ),
            Image.asset('assets/images/logo.png'),
            SizedBox(
              height: 288,
            ),
            SizedBox(
              width: 320,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  toggleSelect(false);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EmailPage(
                        logined: logined,
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xffFFFFFF),
                  side: BorderSide(
                    color: Color(0xffFF516A),
                    width: 1.0,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(7)),
                  ),
                ),
                child: Text(
                  "처음이에요",
                  style: TextStyle(color: Color(0xffFF516A), fontSize: 18),
                ),
              ),
            ),
            SizedBox(
              height: 11,
            ),
            SizedBox(
              width: 320,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  toggleSelect(true);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EmailPage(logined: logined),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xffFF516A),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(7)),
                  ),
                ),
                child: Text(
                  "사용해봤어요",
                  style: TextStyle(color: Color(0xffFFFFFF), fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class EmailPage extends StatefulWidget {
  final bool logined;
  const EmailPage({super.key, required this.logined});

  @override
  _EmailPageState createState() => _EmailPageState();
}

class _EmailPageState extends State<EmailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffFFFFFF),
      appBar: AppBar(),
      body: Column(
        children: [],
      ),
    );
  }
}

class NamePage extends StatefulWidget {
  const NamePage({super.key});

  @override
  _NamePageState createState() => _NamePageState();
}

class _NamePageState extends State<NamePage> {
  String inputedName = '';
  @override
  void initState() {
    // TODO: implement initState
    inputedName = "";
    super.initState();
  }

  Future<void> storeEmail(String email) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('email', email); // 'email' 키에 이메일 저장
  }

// 회원가입 함수
  Future<void> signup(int id, String email, String name, int character) async {
    try {
      final response = await http.post(
        Uri.parse('http://localhost:3000/user/signup'), // Node.js 서버의 IP 주소 사용
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode({
          'email': email,
          'name': name,
          'character': character,
        }),
      );

      final data = json.decode(response.body);

      if (response.statusCode == 201 && data['success']) {
        print('Signup successful: $data');
        await storeEmail(email); // 이메일 저장
      } else {
        print('Signup failed: ${data['errorMessage']}');
      }
    } catch (error) {
      print('Error during signup: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffFFF9F8),
      appBar: AppBar(
        title: const Text("First"),
      ),
      body: Container(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            // 레이아웃을 세로 방향으로 정렬
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 81,
              ),
              const Text(
                "이름을 작성해주세요",
                style: TextStyle(fontFamily: 'LeeSeoYun', fontSize: 24),
              ),
              const SizedBox(height: 121), // 텍스트와 TextField 간 간격 추가
              SizedBox(
                width: 320,
                height: 55,
                child: TextField(
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white, // 내부 배경색 설정
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xffDADADA), // 외부 테두리 색상
                        width: 1.0, // 외부 테두리 두께
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xffDADADA), // 포커스 시 동일한 색상 유지
                        width: 1.0, // 외부 테두리 두께
                      ),
                    ),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.transparent, // 기본 테두리 투명
                        width: 0, // 두께 0
                      ),
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      inputedName = value;
                      print(inputedName);
                    });
                  },
                ),
              ),
              const SizedBox(height: 329),
              SizedBox(
                width: 320,
                height: 52,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xffFF516A),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(7))),
                    ),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BirthPage(
                                title: 'Input Birth', name: inputedName),
                          ));
                    },
                    child: Text(
                      '다음',
                      style: TextStyle(
                          fontFamily: 'LeeSeoYun',
                          fontSize: 20,
                          color: Colors.white),
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class BirthPage extends StatefulWidget {
  final String title;
  final String name;
  const BirthPage({super.key, required this.title, required this.name});

  @override
  _BirthPageState createState() => _BirthPageState();
}

class _BirthPageState extends State<BirthPage> {
  // 연도, 월, 날짜 목록
  final years = [
    '2007',
    '2006',
    '2005',
    '2004',
    '2003',
    '2002',
    '2001',
    '2000'
  ];

  final months = [
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9',
    '10',
    '11',
    '12'
  ];

  final dates = ['1', '2', '3'];

  String date = "";

  // 선택된 연도, 월, 날짜
  String selectedYear = '2007';
  String selectedMonth = '1';
  String selectedDate = '1';

  // 상태 초기화
  @override
  void initState() {
    super.initState();
    // 첫 번째 연도를 기본 선택값으로 설정
    date = "";
    selectedYear = years[0];
    selectedMonth = months[0];
    selectedDate = dates[0];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffFFF9F8),
      appBar: AppBar(
        title: const Text("Birth Input"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 81),
            const Text(
              "생년월일을 선택해주세요",
              style: TextStyle(fontFamily: 'LeeSeoYun', fontSize: 24),
            ),
            const SizedBox(height: 121),
            // 연도 선택
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: 126,
                  height: 53,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(color: Color(0xffDADADA), width: 1),
                    ),
                    child: DropdownButton<String>(
                      padding: EdgeInsets.only(
                          top: 16, bottom: 16, right: 26.5, left: 26.5),
                      isExpanded: true,
                      value: selectedYear,
                      onChanged: (newValue) {
                        setState(() {
                          selectedYear = newValue!;
                        });
                      },
                      items:
                          years.map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(
                            value,
                            style: TextStyle(
                              fontFamily: 'LeeSeoYun',
                              fontSize: 20,
                              color: Colors.black, // 텍스트 색상 설정
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
                SizedBox(
                    width: 93,
                    height: 53,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(color: Color(0xffDADADA), width: 1),
                      ),
                      child: DropdownButton<String>(
                        padding: EdgeInsets.only(
                            top: 16, bottom: 16, right: 17, left: 17),
                        isExpanded: true,
                        value: selectedMonth,
                        onChanged: (newValue) {
                          setState(() {
                            selectedMonth = newValue!;
                          });
                        },
                        items: months
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(
                              value,
                              style: TextStyle(
                                fontFamily: 'LeeSeoYun',
                                fontSize: 20,
                                color: Colors.black, // 텍스트 색상 설정
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    )),
                SizedBox(
                  width: 93,
                  height: 53,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(color: Color(0xffDADADA), width: 1),
                    ),
                    child: DropdownButton<String>(
                      padding: EdgeInsets.only(
                          top: 16, bottom: 16, right: 17, left: 17),
                      isExpanded: true,
                      value: selectedDate,
                      items:
                          dates.map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(
                            value,
                            style: TextStyle(
                              fontFamily: 'LeeSeoYun',
                              fontSize: 20,
                              color: Colors.black, // 텍스트 색상 설정
                            ),
                          ),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        setState(() {
                          selectedDate = newValue!;
                        });
                      },
                    ),
                  ),
                )
              ],
            ),
            SizedBox(height: 329),
            SizedBox(
              width: 320,
              height: 52,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xffFF516A),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(7))),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CharacterPage(
                        name: widget.name,
                        birthDate: '$selectedYear-$selectedMonth-$selectedDate',
                      ),
                    ),
                  );
                },
                child: Text(
                  '다음',
                  style: TextStyle(
                    fontFamily: 'LeeSeoYun',
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CharacterPage extends StatefulWidget {
  final String name;
  final String birthDate;
  const CharacterPage({super.key, required this.name, required this.birthDate});

  @override
  _CharacterPageState createState() => _CharacterPageState();
}

class _CharacterPageState extends State<CharacterPage> {
  late List<bool> isSelected = [true, false, false];
  // selectedChar가 null이면 0을 기본값으로 사용
  String selectedChar = "";
  int testNum = 0;

  void answerPressed() {
    testNum++;
  }

  @override
  void initState() {
    super.initState();
  }

  void toggleSelect(value) {
    setState(() {
      selectedChar = '$value';
      isSelected = [value == 0, value == 1, value == 2];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffFFF9F8),
      appBar: AppBar(
        title: const Text("Birth Input"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 81),
            const Text(
              "캐릭터를 선택해주세요",
              style: TextStyle(fontFamily: 'LeeSeoYun', fontSize: 24),
            ),
            const SizedBox(height: 121),
            // 캐릭터 선택
            ToggleButtons(
              isSelected: isSelected,
              onPressed: toggleSelect,
              selectedColor: Colors.black,
              borderRadius: BorderRadius.circular(7),
              borderColor: Color(0xffDADADA),
              selectedBorderColor: Color(0xffFB5D6F),
              children: [
                Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(6),
                      child: Image.asset('assets/images/Kangeroo.png'),
                    ),
                    Text(
                      "코코",
                      style: TextStyle(fontFamily: 'LeeSeoYun', fontSize: 25),
                    )
                  ],
                ),
                Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(6),
                      child: Image.asset('assets/images/Kangeroo.png'),
                    ),
                    Text(
                      "코코",
                      style: TextStyle(fontFamily: 'LeeSeoYun', fontSize: 25),
                    )
                  ],
                ),
                Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(6),
                      child: Image.asset('assets/images/Kangeroo.png'),
                    ),
                    Text(
                      "코코",
                      style: TextStyle(fontFamily: 'LeeSeoYun', fontSize: 25),
                    )
                  ],
                ),
              ],
            ),
            SizedBox(height: 235),
            SizedBox(
              width: 320,
              height: 52,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xffFF516A),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(7))),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FinalPage(
                        name: widget.name,
                        birthDate: widget.birthDate,
                        selectedCharacter: selectedChar,
                      ),
                    ),
                  );
                },
                child: Text(
                  '다음',
                  style: TextStyle(
                    fontFamily: 'LeeSeoYun',
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FinalPage extends StatelessWidget {
  final String name;
  final String birthDate;
  final String selectedCharacter;

  const FinalPage({
    super.key,
    required this.name,
    required this.birthDate,
    required this.selectedCharacter,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffFFF9F8),
      appBar: AppBar(
        title: const Text("Final Page"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 81),
            const Text(
              "입력한 정보",
              style: TextStyle(fontFamily: 'LeeSeoYun', fontSize: 24),
            ),
            const SizedBox(height: 40),
            Text(
              '이름: $name',
              style: TextStyle(fontFamily: 'LeeSeoYun', fontSize: 20),
            ),
            SizedBox(height: 20),
            Text(
              '생년월일: $birthDate',
              style: TextStyle(fontFamily: 'LeeSeoYun', fontSize: 20),
            ),
            SizedBox(height: 20),
            Text(
              '선택한 캐릭터: $selectedCharacter',
              style: TextStyle(fontFamily: 'LeeSeoYun', fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }
}
