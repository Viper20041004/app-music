
import 'package:app_music/core/constant/app_assets.dart';
import 'package:app_music/features/main_page/home/data/mix_item.dart';
import 'package:app_music/features/main_page/home/presentation/widget/continue_listening.dart';
import 'package:app_music/features/main_page/home/presentation/widget/home_header.dart';
import 'package:app_music/features/main_page/home/presentation/widget/top_mixes.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  static final mixes = [
    MixItem(
      title: 'Hit Việt Quốc Dân',
      subtitle: 'Hngle, Bảo Anh, TINH HÀ "SAY HI", ...',
      image: AppAssets.vnImage1,
      searchQuery: 'Vpop hit',
    ),
    MixItem(
      title: 'V-Pop Thịnh Hành',
      subtitle: 'Sơn Tùng M-TP, Wren Evans, MONO, Grey D',
      image: AppAssets.vnImage2,
      searchQuery: 'Son Tung MTP',
    ),
    MixItem(
      title: 'Ballad Việt',
      subtitle: 'Quân A.P, Mr. Siro, Hương Tràm, Trung Quân',
      image: AppAssets.vnImage3,
      searchQuery: 'Vietnamese ballad',
    ),
    MixItem(
      title: 'Nữ Thần R&B',
      subtitle: 'tlinh, Phùng Khánh Linh, Orange, MIN',
      image: AppAssets.vnImage4,
      searchQuery: 'rnb pop',
    ),
    MixItem(
      title: 'Tiềm Năng V-Pop',
      subtitle: 'Rhyder, Captain Boy, Quang Hùng MasterD, WEAN',
      image: AppAssets.vnImage5,
      searchQuery: 'indie pop 2024',
    ),
  ];
  static final moods = [
    MixItem(
      title: 'Từ tiktok qua đây...',
      subtitle: 'Tinh hà say hi, Quang Hùng MasterD',
      image: AppAssets.moodImg1,
      searchQuery: 'tiktok viral',
    ),
    MixItem(
      title: 'Hồi Ức 8x 9x',
      subtitle: 'wanbi Tuấn Anh,Cẩm Ly, Mỹ Tâm',
      image: AppAssets.moodImg2,
      searchQuery: 'nhac vang bolero',
    ),
    MixItem(
      title: 'Thật tình thật chill',
      subtitle: 'Quân A.P, Mr. Siro, Hương Tràm, Trung Quân',
      image: AppAssets.moodImg3,
      searchQuery: 'chill acoustic',
    ),
    MixItem(
      title: 'Chút nhạc chill mỗi sáng',
      subtitle: 'Rhyder, Captain Boy, Quang Hùng MasterD, WEAN',
      image: AppAssets.moodImg4,
      searchQuery: 'morning chill lofi',
    ),
    MixItem(
      title: 'Lofi chill cho ngày mưa',
      subtitle: 'Kiều Chi,Meme Media,Quốc Thiên',
      image: AppAssets.moodImg5,
      searchQuery: 'lofi rain',
    ),
  ];
  static final tops = [
    MixItem(
      title: 'Top 100 nhạc Hoa hay nhất',
      subtitle: 'Mã Dã(Crabbit),Mr Cole, Bố Lỗ Tích',
      image: AppAssets.topImg1,
      searchQuery: 'mandopop',
    ),
    MixItem(
      title: 'Top 100 Rap Việt hay nhất',
      subtitle: 'Dangrangto,Donal,Smiley Panda',
      image: AppAssets.topImg2,
      searchQuery: 'rap viet',
    ),
    MixItem(
      title: 'Top 100 USUK hay nhất',
      subtitle: 'Dua Lipa,LISA,Ariana Grande',
      image: AppAssets.topImg3,
      searchQuery: 'pop hits',
    ),
    MixItem(
      title: 'Top 100 nhạc Hàn hay nhất',
      subtitle: 'JENNIE,CORTIS,BTS',
      image: AppAssets.topImg4,
      searchQuery: 'kpop',
    ),
    MixItem(
      title: 'Top 100 nhạc chữ tình hay nhất',
      subtitle: 'Lệ Quyên,Đan Trường,Anh Khang',
      image: AppAssets.moodImg5,
      searchQuery: 'romantic ballad',
    ),
  ];

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedIndex = 0;


  void onNavigationChanged(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF073C40),
              Color(0xFF071A1C),
              Color(0xFF071A1C),
              Color(0xFF0E0E0E),
            ],
            stops: [
              0.0,
              0.15,
              0.55,
              1.0,
            ],
          )
        ),
        child: SafeArea(
          bottom: false,
          child: CustomScrollView(
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(
                  20,
                  16,
                  20,
                  110,
                ),
                sliver: SliverList(
                  delegate: SliverChildListDelegate(
                    [
                      const HomeHeader(),

                      const SizedBox(height: 28),

                      const SectionTitle(
                        title: 'Trending',
                      ),

                      const SizedBox(height: 12),

                      const ContinueListening(),

                      const SizedBox(height: 30),

                      const SectionTitle(
                        title: 'All About Viet Music',
                      ),

                      const SizedBox(height: 12),

                      TopMixes(mixes: HomePage.mixes),

                      const SizedBox(height: 30),

                      const SectionTitle(
                        title: "Today's Mood",
                      ),

                      const SizedBox(height: 12),

                      TopMixes(mixes: HomePage.moods),

                      const SectionTitle(
                        title: "Top 100",
                      ),

                      const SizedBox(height: 12),

                      TopMixes(mixes: HomePage.tops),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),

      // bottomNavigationBar: HomeBottomNav(
      //   currentIndex: selectedIndex,
      //   onChanged: onNavigationChanged,
      // ),
    );
  }
}

class SectionTitle extends StatelessWidget {
  final String title;

  const SectionTitle({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.3,
      ),
    );
  }
}