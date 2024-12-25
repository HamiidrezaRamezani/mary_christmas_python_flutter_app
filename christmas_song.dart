import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:audioplayers/audioplayers.dart';

class MusicPlayer extends StatefulWidget {
  @override
  _MusicPlayerState createState() => _MusicPlayerState();
}

class _MusicPlayerState extends State<MusicPlayer> {
  final AudioPlayer _audioPlayer = AudioPlayer();


  // درخواست به api مربوط به موسیقی کریسمس با استفاده از ip ایی که سیستم برای وب سرویس تعریف کرده است.
  Future<void> _fetchAndPlayMusic() async {
    try {
      // Fetch the music file from API
      final response =
          await http.get(Uri.parse('http://192.168.100.142:5000/get-music'));

      if (response.statusCode == 200) {
        // Save the file locally
        final tempDir = await getTemporaryDirectory();
        final filePath = '${tempDir.path}/jingle_bells.wav';
        final file = File(filePath);
        print(filePath);
        await file.writeAsBytes(response.bodyBytes);

        // Play the music
        await _audioPlayer.play(DeviceFileSource(filePath));
      } else {
        print('Failed to fetch music. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching music: $e');
    }
  }

  @override
  void initState() {
    _fetchAndPlayMusic();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          "Mary Christmas",
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          InkWell(
            onTap: () {
              _fetchAndPlayMusic();
            },
            child: Row(
              children: [
                Text(
                  "refresh",
                  style: TextStyle(color: Colors.white),
                ),
                SizedBox(
                  width: 8.0,
                ),
                Icon(
                  Icons.refresh,
                  color: Colors.white,
                ),
              ],
            ),
          )
        ],
      ),
      body: Center(
        child: CustomPaint(
          size: Size(width, height * 0.8), // اندازه درخت
          painter: ChristmasTreePainter(),
        ),
      ),
    );
  }
}

class ChristmasTreePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..isAntiAlias = true;

    // رسم بدنه درخت
    final treePaint = Paint()
      ..color = Colors.green
      ..style = PaintingStyle.fill;

    // لایه‌های درخت
    final path1 = Path()
      ..moveTo(size.width / 2, size.height * 0.1)
      ..lineTo(size.width * 0.15, size.height * 0.4)
      ..lineTo(size.width * 0.85, size.height * 0.4)
      ..close();

    final path2 = Path()
      ..moveTo(size.width / 2, size.height * 0.3)
      ..lineTo(size.width * 0.2, size.height * 0.6)
      ..lineTo(size.width * 0.8, size.height * 0.6)
      ..close();

    final path3 = Path()
      ..moveTo(size.width / 2, size.height * 0.5)
      ..lineTo(size.width * 0.25, size.height * 0.8)
      ..lineTo(size.width * 0.75, size.height * 0.8)
      ..close();

    canvas.drawPath(path1, treePaint);
    canvas.drawPath(path2, treePaint);
    canvas.drawPath(path3, treePaint);

    // رسم تنه درخت
    final trunkPaint = Paint()
      ..color = Colors.brown
      ..style = PaintingStyle.fill;

    final trunkRect = Rect.fromCenter(
      center: Offset(size.width / 2, size.height * 0.9),
      width: size.width * 0.1,
      height: size.height * 0.1,
    );
    canvas.drawRect(trunkRect, trunkPaint);

    // رسم ستاره بالای درخت
    final starPaint = Paint()
      ..color = Colors.yellow
      ..style = PaintingStyle.fill;

    final starPath = Path()
      ..moveTo(size.width / 2, size.height * 0.05)
      ..lineTo(size.width * 0.45, size.height * 0.12)
      ..lineTo(size.width * 0.55, size.height * 0.12)
      ..close();
    canvas.drawPath(starPath, starPaint);

    // رسم تزئینات
    final ornamentPaint = Paint()..color = Colors.red;

    final ornaments = [
      Offset(size.width * 0.4, size.height * 0.35),
      Offset(size.width * 0.6, size.height * 0.45),
      Offset(size.width * 0.5, size.height * 0.65),
      Offset(size.width * 0.35, size.height * 0.55),
      Offset(size.width * 0.7, size.height * 0.7),
    ];

    for (var ornament in ornaments) {
      canvas.drawCircle(ornament, 8, ornamentPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
