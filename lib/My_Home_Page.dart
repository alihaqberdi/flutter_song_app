import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app_colors.dart' as AppColors;
import 'my_tabs.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  MyHomePageState createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  List popularbooks = [];
  List books = [];
  late ScrollController _scrollcontroler;
  late TabController _tabcontrler;

  ReadData() async {
    await DefaultAssetBundle.of(context)
        .loadString("assets/popularbooks.json")
        .then((value) {
      setState(() {
        popularbooks = json.decode(value);
      });
    });

    await DefaultAssetBundle.of(context)
        .loadString("assets/books.json")
        .then((value) {
      setState(() {
        books = json.decode(value);
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _tabcontrler = TabController(length: 3, vsync: this);
    _scrollcontroler = ScrollController();
    ReadData();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.backroung,
      child: SafeArea(
        child: Scaffold(
          body: Column(
            children: [
              Container(
                margin:
                    const EdgeInsets.only(left: 20.0, right: 20.0, top: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const ImageIcon(
                      AssetImage('assets/images/menu.png'),
                      size: 24,
                      color: Colors.black,
                    ),
                    Row(
                      children: const [
                        Icon(Icons.search),
                        SizedBox(
                          width: 10.0,
                        ),
                        Icon(Icons.notifications)
                      ],
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 20.0,
              ),
              Row(children: [
                Container(
                  margin: const EdgeInsets.only(left: 20.0),
                  child: const Text(
                    "Popular Books",
                    style: TextStyle(fontSize: 30),
                  ),
                ),
              ]),
              const SizedBox(
                height: 20.0,
              ),
              SizedBox(
                height: 180.0,
                child: Stack(
                  children: [
                    Positioned(
                      right: 0,
                      left: 0,
                      top: 0,
                      child: SizedBox(
                        height: 180.0,
                        child: PageView.builder(
                            controller: PageController(viewportFraction: 0.9),
                            itemCount:
                                popularbooks == null ? 0 : popularbooks.length,
                            itemBuilder: (_, i) {
                              return Container(
                                height: 180,
                                margin: EdgeInsets.only(right: 10.0),
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15.0),
                                  image: DecorationImage(
                                      image: AssetImage(
                                          "assets/images/${popularbooks[i]['img']}"),
                                      fit: BoxFit.cover),
                                ),
                              );
                            }),
                      ),
                    )
                  ],
                ),
              ),
              Expanded(
                child: NestedScrollView(
                  controller: _scrollcontroler,
                  headerSliverBuilder: (BuildContext context, bool isScroll) {
                    return [
                      SliverAppBar(
                        pinned: true,
                        backgroundColor: AppColors.silverBackground,
                        bottom: PreferredSize(
                          preferredSize: Size.fromHeight(50.0),
                          child: Container(
                            margin: EdgeInsets.only(bottom: 20.0),
                            child: TabBar(
                              indicatorPadding: EdgeInsets.all(0.0),
                              indicatorSize: TabBarIndicatorSize.label,
                              labelPadding:
                                  const EdgeInsets.only(right: 5.0, left: 5.0),
                              controller: _tabcontrler,
                              isScrollable: true,
                              indicator: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.0),
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.grey.withOpacity(0.2),
                                        blurRadius: 7,
                                        offset: Offset(0, 0))
                                  ]),
                              tabs: [
                                AppTabs(
                                    color: AppColors.menu1Color, text: 'New'),
                                AppTabs(
                                    color: AppColors.menu2Color,
                                    text: 'popular'),
                                AppTabs(
                                    color: AppColors.menu3Color,
                                    text: 'tranding'),
                              ],
                            ),
                          ),
                        ),
                      )
                    ];
                  },
                  body: TabBarView(
                    controller: _tabcontrler,
                    children: [
                      ListView.builder(
                          itemCount: books == null ? 0 : books.length,
                          itemBuilder: (_, i) {
                            return Container(
                              margin: const EdgeInsets.only(
                                  left: 20.0,
                                  right: 20.0,
                                  top: 10.0,
                                  bottom: 10.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: AppColors.tabVarviewColor,
                                  borderRadius: BorderRadius.circular(10.0),
                                  boxShadow: [
                                    BoxShadow(
                                        blurRadius: 2.0,
                                        offset: const Offset(0, 0),
                                        color: Colors.grey.withOpacity(0.2)),
                                  ],
                                ),
                                child: Container(
                                  padding: EdgeInsets.all(8.0),
                                  child: Container(
                                    child: Row(
                                      children: [
                                        Container(
                                          height: 120.0,
                                          width: 90.0,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                              image: DecorationImage(
                                                image: AssetImage(
                                                    'assets/images/${books[i]['img']}'),
                                              )),
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(left: 10.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              Row(
                                                children: [
                                                  Icon(
                                                    Icons.star,
                                                    color: Colors.yellow,
                                                    size: 24,
                                                  ),
                                                  SizedBox(
                                                    width: 5.0,
                                                  ),
                                                  Text(
                                                    books[i]['rating'],
                                                    style: TextStyle(
                                                        color:
                                                            AppColors.starColor,
                                                        fontWeight:
                                                            FontWeight.w600),
                                                  )
                                                ],
                                              ),
                                              SizedBox(
                                                height: 5.0,
                                              ),
                                              Text(
                                                  books[i]['title'],
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 20.0,
                                                    fontWeight: FontWeight.bold,
                                                    fontFamily: 'Avenir'),
                                              ),
                                              SizedBox(
                                                height: 5.0,
                                              ),
                                              Text(
                                                  books[i]['text'],
                                                style: TextStyle(
                                                    color:
                                                        AppColors.subTitleText,
                                                    fontSize: 12.0,
                                                    fontWeight:
                                                        FontWeight.w300),
                                              ),
                                              SizedBox(
                                                height: 5.0,
                                              ),
                                              Container(
                                                height: 20.0,
                                                width: 50.0,
                                                alignment: Alignment.center,
                                                decoration: BoxDecoration(
                                                  color: AppColors.loveColor,
                                                  borderRadius: BorderRadius.circular(5)
                                                ),
                                                child: const Text(
                                                  "Love",
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 14.0,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontFamily: 'Avenir'),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }),
                      Material(
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.grey,
                          ),
                          title: Text("Content"),
                        ),
                      ),
                      Material(
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.grey,
                          ),
                          title: Text("Content"),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
