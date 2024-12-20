import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Input Name',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Input Name'),
    );
  }
}

class MyHomePage extends StatelessWidget {
  final String title;

  const MyHomePage({super.key, required this.title});

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
              const Text(
                "이름을 작성해주세요",
                style: TextStyle(fontFamily: 'LeeSeoYun', fontSize: 24),
              ),
              const SizedBox(height: 20), // 텍스트와 TextField 간 간격 추가
              SizedBox(
                width: 320,
                height: 55,
                child: const TextField(
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
                ),
              ),
              const SizedBox(height: 377),
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
                            builder: (context) =>
                                const BirthPage(title: 'Input Birth'),
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
  const BirthPage({super.key, required this.title});

  @override
  _BirthPageState createState() => _BirthPageState();
}

class _BirthPageState extends State<BirthPage> {
  // 연도, 월, 날짜 목록
  final _years = [
    '2007',
    '2006',
    '2005',
    '2004',
    '2003',
    '2002',
    '2001',
    '2000'
  ];

  final _months = [
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

  final _dates = ['1', '2', '3'];

  // 선택된 연도, 월, 날짜
  String _selectedYear = '2007';
  String _selectedMonth = '1';
  String _selectedDate = '1';

  // 상태 초기화
  @override
  void initState() {
    super.initState();
    // 첫 번째 연도를 기본 선택값으로 설정
    _selectedYear = _years[0];
    _selectedMonth = _months[0];
    _selectedDate = _dates[0];
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
            const Text(
              "생년월일을 선택해주세요",
              style: TextStyle(fontFamily: 'LeeSeoYun', fontSize: 24),
            ),
            const SizedBox(height: 20),
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
                      value: _selectedYear,
                      onChanged: (newValue) {
                        setState(() {
                          _selectedYear = newValue!;
                        });
                      },
                      items:
                          _years.map<DropdownMenuItem<String>>((String value) {
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
                        value: _selectedMonth,
                        onChanged: (newValue) {
                          setState(() {
                            _selectedMonth = newValue!;
                          });
                        },
                        items: _months
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
                      value: _selectedDate,
                      items:
                          _dates.map<DropdownMenuItem<String>>((String value) {
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
                          _selectedDate = newValue!;
                        });
                      },
                    ),
                  ),
                )
              ],
            ),
            SizedBox(height: 379),
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
                      builder: (context) =>
                          const BirthPage(title: 'Input Birth'),
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
