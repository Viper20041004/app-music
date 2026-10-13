import 'package:app_music/core/constant/app_assets.dart';
import 'package:app_music/features/main_page/explore/data/topic_model.dart';

class TopicData {
  /// Danh sách các playlist chuẩn thuộc chủ đề "Pop Ballad" (như trong ảnh mẫu)
  static const List<TopicPlaylist> popBalladPlaylists = [
    TopicPlaylist(
      title: 'Hồi Ức 8x 9x',
      image: AppAssets.balladHoiUc,
      subtitle: 'wanbi Tuấn Anh, Cẩm Ly, Mỹ Tâm',
      searchQuery: 'Hồi ức 8x 9x',
      description: 'Những bản tình ca sống mãi cùng thời gian của thế hệ 8x, 9x',
    ),
    TopicPlaylist(
      title: 'Nhạc Âu Mỹ 8x 9x',
      image: AppAssets.balladAuMy,
      subtitle: 'Westlife, Backstreet Boys, Boyzone',
      searchQuery: 'Nhạc Âu Mỹ 8x 9x',
      description: 'Giai điệu bất hủ từ các boyband và huyền thoại US-UK thập niên 90 - 2000',
    ),
    TopicPlaylist(
      title: 'Top nhạc AI hay nhất 2026',
      image: AppAssets.balladAi2026,
      subtitle: 'AI Music Hits, Future Melodies',
      searchQuery: 'Top nhạc AI hay nhất',
      description: 'Tuyển tập những ca khúc AI sáng tác cực bắt tai và gây nghiện nhất 2026',
    ),
    TopicPlaylist(
      title: 'V-POP 2010-2015',
      image: AppAssets.balladVpop,
      subtitle: 'Various Artists',
      searchQuery: 'V-POP 2010-2015',
      description: 'Thời kỳ hoàng kim của V-Pop với loạt hit đình đám một thời',
    ),
    TopicPlaylist(
      title: 'Nhạc Buồn Cho Người Thất Tình',
      image: AppAssets.balladBuonThatTinh,
      subtitle: 'Giai điệu da diết chạm đáy nỗi đau',
      searchQuery: 'Nhạc buồn thất tình',
      description: 'Dành cho những trái tim đang tổn thương với những khúc ca da diết nhất',
    ),
  ];

  static const List<TopicPlaylist> trendingPopPlaylists = [
    TopicPlaylist(
      title: 'Hit Việt Quốc Dân',
      image: AppAssets.vnImage1,
      subtitle: 'Sơn Tùng M-TP, Wren Evans, MONO',
      searchQuery: 'Hit Việt',
      description: 'Tuyển tập các bản hit quốc dân được nghe nhiều nhất hiện nay',
    ),
    TopicPlaylist(
      title: 'V-Pop Thịnh Hành',
      image: AppAssets.vnImage2,
      subtitle: 'Hòa Minzy, Grey D, Vũ, Tlinh',
      searchQuery: 'V-Pop Thịnh Hành',
      description: 'Những ca khúc V-Pop đang đứng đầu bảng xếp hạng',
    ),
    TopicPlaylist(
      title: 'Ballad Việt Êm Đềm',
      image: AppAssets.vnImage3,
      subtitle: 'Quân A.P, Mr. Siro, Hương Tràm, Trung Quân',
      searchQuery: 'Ballad Việt',
      description: 'Những bản ballad ngọt ngào, sâu lắng làm say đắm lòng người',
    ),
    TopicPlaylist(
      title: 'Nữ Thần R&B',
      image: AppAssets.vnImage4,
      subtitle: 'tlinh, Phùng Khánh Linh, Orange, MIN',
      searchQuery: 'Nữ Thần R&B',
      description: 'Giọng ca nữ cuốn hút cùng những giai điệu R&B hiện đại',
    ),
    TopicPlaylist(
      title: 'Tiềm Năng V-Pop',
      image: AppAssets.vnImage5,
      subtitle: 'Rhyder, Captain Boy, Quang Hùng MasterD',
      searchQuery: 'Tiềm Năng V-Pop',
      description: 'Gương mặt mới cùng những sản phẩm âm nhạc bùng nổ',
    ),
  ];

  static const List<TopicPlaylist> chillMoodPlaylists = [
    TopicPlaylist(
      title: 'Từ TikTok Qua Đây',
      image: AppAssets.moodImg1,
      subtitle: 'Tinh hà say hi, Quang Hùng MasterD',
      searchQuery: 'tiktok viral',
      description: 'Những đoạn âm thanh viral nhất trên TikTok nay đã có bản đầy đủ',
    ),
    TopicPlaylist(
      title: 'Thật Tình Thật Chill',
      image: AppAssets.moodImg3,
      subtitle: 'Acoustic nhẹ nhàng cho buổi tối',
      searchQuery: 'chill acoustic',
      description: 'Giai điệu mộc mạc đưa tâm hồn bạn về chốn bình yên',
    ),
    TopicPlaylist(
      title: 'Chút Nhạc Chill Mỗi Sáng',
      image: AppAssets.moodImg4,
      subtitle: 'Năng lượng tích cực ngày mới',
      searchQuery: 'morning chill',
      description: 'Khởi đầu ngày mới tràn đầy sức sống và cảm hứng sáng tạo',
    ),
    TopicPlaylist(
      title: 'Lofi Chill Cho Ngày Mưa',
      image: AppAssets.moodImg5,
      subtitle: 'Tiếng mưa rơi cùng giai điệu lofi',
      searchQuery: 'lofi rain',
      description: 'Thả hồn vào từng giọt mưa cùng âm hưởng lofi êm dịu',
    ),
  ];

  static const List<TopicPlaylist> rapVietPlaylists = [
    TopicPlaylist(
      title: 'Rap Việt Đỉnh Cao',
      image: AppAssets.topSongMCK,
      subtitle: 'MCK, Wxrdie, Tage, Tlinh',
      searchQuery: 'rap viet',
      description: 'Tuyển tập rap Việt đỉnh cao được giới trẻ yêu thích nhất',
    ),
    TopicPlaylist(
      title: 'Top Hits B Ray',
      image: AppAssets.topSongBray,
      subtitle: 'B Ray, Masew, Đạt G',
      searchQuery: 'b ray',
      description: 'Những bản rap storytelling cuốn hút của B Ray',
    ),
    TopicPlaylist(
      title: 'Giai Điệu Đen Vâu',
      image: AppAssets.topSongDen,
      subtitle: 'Đen Vâu, JustaTee, Biên',
      searchQuery: 'den vau',
      description: 'Những triết lý đời thường bình dị qua lời rap của Đen',
    ),
    TopicPlaylist(
      title: 'HIEUTHUHAI & Friends',
      image: AppAssets.topSongHieuThu2,
      subtitle: 'HIEUTHUHAI, HURRYKNG, MANBO',
      searchQuery: 'hieuthuhai',
      description: 'Dòng rap hiện đại, cuốn hút và phóng khoáng của GERDNANG',
    ),
    TopicPlaylist(
      title: 'King of Melody JustaTee',
      image: AppAssets.topSongJustatee,
      subtitle: 'JustaTee, BigDaddy, Rhymastic',
      searchQuery: 'justatee',
      description: 'Bậc thầy R&B và Melodic Rap hàng đầu Việt Nam',
    ),
  ];

  /// Lấy danh sách sections cho từng topic
  static List<TopicSection> getSectionsForTopic(String topicTitle) {
    final titleLower = topicTitle.toLowerCase();

    // Đối với V-Rap / Rap
    if (titleLower.contains('rap')) {
      return [
        const TopicSection(
          title: 'Rap Việt Nổi Bật',
          playlists: rapVietPlaylists,
        ),
        const TopicSection(
          title: 'Pop Ballad',
          playlists: popBalladPlaylists,
        ),
        const TopicSection(
          title: 'Thịnh Hành',
          playlists: trendingPopPlaylists,
        ),
      ];
    }

    // Đối với Chill Out / Relax / Sad
    if (titleLower.contains('chill') || titleLower.contains('relax') || titleLower.contains('sad')) {
      return [
        const TopicSection(
          title: 'Tâm Trạng & Cảm Xúc',
          playlists: chillMoodPlaylists,
        ),
        const TopicSection(
          title: 'Pop Ballad',
          playlists: popBalladPlaylists,
        ),
        const TopicSection(
          title: 'Thịnh Hành',
          playlists: trendingPopPlaylists,
        ),
      ];
    }

    // Mặc định hoặc Pop / V-Pop: Luôn đưa Pop Ballad lên đầu tiên chính xác như ảnh mẫu
    return [
      const TopicSection(
        title: 'Pop Ballad',
        playlists: popBalladPlaylists,
      ),
      const TopicSection(
        title: 'Thịnh Hành & Nổi Bật',
        playlists: trendingPopPlaylists,
      ),
      const TopicSection(
        title: 'Tâm Trạng & Thư Giãn',
        playlists: chillMoodPlaylists,
      ),
    ];
  }
}
