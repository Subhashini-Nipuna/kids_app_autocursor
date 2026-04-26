import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter_tts/flutter_tts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Kids Tracing Fun',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.pinkAccent),
        useMaterial3: true,
      ),
      home: GreetingScreen(), // no const here
    );
  }
}

class GreetingScreen extends StatefulWidget {
  const GreetingScreen({super.key});

  @override
  State<GreetingScreen> createState() => _GreetingScreenState();
}

class _GreetingScreenState extends State<GreetingScreen> {
  late final AudioPlayer _player;
  bool _playedOnce = false;

  @override
  void initState() {
    super.initState();
    _player = AudioPlayer();
    _playWelcome();
  }

  Future<void> _playWelcome() async {
    if (_playedOnce) return;
    try {
      await _player.play(AssetSource('audio/welcome.mp3'));
      _playedOnce = true;
    } catch (_) {
      // On web, autoplay can fail without user gesture.
      // Keep _playedOnce false so a later tap can retry playback.
    }
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: _playWelcome,
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFFFFE6E6),
                Color(0xFFFFF7C4),
                Color(0xFFCFFAFE),
              ],
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'Hi SHANMUK ',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.pinkAccent,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          "Let's learn by tracing",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      width: 64,
                      height: 64,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 8,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.brush,
                        color: Colors.pinkAccent,
                        size: 32,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                Expanded(
                  child: Column(
                    children: [
                      SizedBox(
                        height: size.height * 0.25,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(32),
                                color: Colors.white.withOpacity(0.9),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 10,
                                    offset: Offset(0, 6),
                                  ),
                                ],
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 16,
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Text(
                                    'Welcome to',
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.black54,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    'Trace - Have Fun',
                                    style: TextStyle(
                                      fontSize: 32,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.orange,
                                      letterSpacing: 1.5,
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    'Choose what you want to practice today!',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.black54,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Positioned(
                              top: -8,
                              right: 24,
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (_) => const ProgressScreen(),
                                    ),
                                  );
                                },
                                child: const _FloatingSticker(
                                  icon: Icons.star_rounded,
                                  color: Colors.amber,
                                ),
                              ),
                            ),
                            const Positioned(
                              bottom: -8,
                              left: 32,
                              child: _FloatingSticker(
                                icon: Icons.favorite,
                                color: Colors.redAccent,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 32),
                      Expanded(
                        child: Column(
                          children: [
                            _OptionCard(
                              title: 'Alphabets (A - Z)',
                              description:
                                  'Trace big letters and learn sounds.',
                              color: const Color(0xFFFFC1E3),
                              icon: Icons.abc,
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => const SymbolTracingScreen(
                                      category: TracingCategory.capitalLetters,
                                    ),
                                  ),
                                );
                              },
                            ),
                            const SizedBox(height: 16),
                            _OptionCard(
                              title: 'Numbers (0 - 9)',
                              description:
                                  'Trace numbers and count together.',
                              color: const Color(0xFFBDE0FE),
                              icon: Icons.filter_1,
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => const SymbolTracingScreen(
                                      category: TracingCategory.numbers,
                                    ),
                                  ),
                                );
                              },
                            ),
                            const SizedBox(height: 16),
                            _OptionCard(
                              title: 'Small Alphabets (a - z)',
                              description: 'Trace tiny letters with care.',
                              color: const Color(0xFFC6F6D5),
                              icon: Icons.text_fields,
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => const SymbolTracingScreen(
                                      category: TracingCategory.smallLetters,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      ),
    );
  }
}

class _OptionCard extends StatelessWidget {
  final String title;
  final String description;
  final Color color;
  final IconData icon;
  final VoidCallback onTap;

  const _OptionCard({
    required this.title,
    required this.description,
    required this.color,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(24),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10,
              offset: Offset(0, 6),
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Row(
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(
                icon,
                size: 36,
                color: Colors.deepPurple,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    description,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.play_arrow_rounded,
              size: 32,
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}

class TracingPlaceholderScreen extends StatelessWidget {
  final String title;
  final String hint;
  final Color accentColor;

  const TracingPlaceholderScreen({
    super.key,
    required this.title,
    required this.hint,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: accentColor,
        foregroundColor: Colors.white,
      ),
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              accentColor.withOpacity(0.1),
              Colors.white,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.gesture_rounded,
                size: 80,
                color: Colors.black26,
              ),
              const SizedBox(height: 16),
              Text(
                'Tracing area coming soon!',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: accentColor,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                hint,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FloatingSticker extends StatelessWidget {
  final IconData icon;
  final Color color;

  const _FloatingSticker({
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Center(
        child: Icon(
          icon,
          color: Colors.white,
          size: 20,
        ),
      ),
    );
  }
}

class ProgressScreen extends StatelessWidget {
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final progress = ProgressStore.instance;
    final int capitalDone = progress.completedTodayCount(
      TracingCategory.capitalLetters,
    );
    final int smallDone = progress.completedTodayCount(
      TracingCategory.smallLetters,
    );
    final int numbersDone = progress.completedTodayCount(TracingCategory.numbers);
    final int totalDoneToday = capitalDone + smallDone + numbersDone;
    final int totalTarget = progress.totalCount(TracingCategory.capitalLetters) +
        progress.totalCount(TracingCategory.smallLetters) +
        progress.totalCount(TracingCategory.numbers);
    final int streakDays = progress.currentStreakDays();
    final List<DailyProgressPoint> recentWeek = progress.recentDailyTotals(7);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Daily Progress'),
        backgroundColor: Colors.pinkAccent,
        foregroundColor: Colors.white,
      ),
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Today: ${_todayLabel()}',
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Great job! You finished $totalDoneToday symbols today.',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.pinkAccent,
                ),
              ),
              const SizedBox(height: 20),
              _DailyProgressCard(
                title: 'Capital Alphabets',
                done: capitalDone,
                total: progress.totalCount(TracingCategory.capitalLetters),
                color: Colors.pinkAccent,
              ),
              const SizedBox(height: 12),
              _DailyProgressCard(
                title: 'Small Alphabets',
                done: smallDone,
                total: progress.totalCount(TracingCategory.smallLetters),
                color: Colors.green,
              ),
              const SizedBox(height: 12),
              _DailyProgressCard(
                title: 'Numbers',
                done: numbersDone,
                total: progress.totalCount(TracingCategory.numbers),
                color: Colors.blueAccent,
              ),
              const SizedBox(height: 16),
              Text(
                'Overall today: $totalDoneToday / $totalTarget',
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 18),
              _WeeklyProgressCard(
                streakDays: streakDays,
                weekData: recentWeek,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

String _todayLabel() {
  final now = DateTime.now();
  const weekdays = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ];
  const months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];
  return '${weekdays[now.weekday - 1]}, ${months[now.month - 1]} ${now.day}';
}

class _DailyProgressCard extends StatelessWidget {
  const _DailyProgressCard({
    required this.title,
    required this.done,
    required this.total,
    required this.color,
  });

  final String title;
  final int done;
  final int total;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final double value = total == 0 ? 0 : done / total;
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            '$done / $total completed',
            style: const TextStyle(fontSize: 13, color: Colors.black54),
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: value,
            minHeight: 10,
            borderRadius: BorderRadius.circular(10),
            color: color,
            backgroundColor: color.withOpacity(0.2),
          ),
        ],
      ),
    );
  }
}

class _WeeklyProgressCard extends StatelessWidget {
  const _WeeklyProgressCard({
    required this.streakDays,
    required this.weekData,
  });

  final int streakDays;
  final List<DailyProgressPoint> weekData;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Streak: $streakDays day${streakDays == 1 ? '' : 's'}',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Colors.orange,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Last 7 days',
            style: TextStyle(fontSize: 13, color: Colors.black54),
          ),
          const SizedBox(height: 12),
          Row(
            children: weekData
                .map(
                  (item) => Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 3),
                      child: Column(
                        children: [
                          Text(
                            item.shortWeekday,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.black54,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Container(
                            width: 34,
                            height: 34,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: item.total == 0
                                  ? Colors.grey.shade200
                                  : Colors.orange.shade200,
                              border: Border.all(
                                color: item.total == 0
                                    ? Colors.grey.shade400
                                    : Colors.orange.shade400,
                              ),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              '${item.total}',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: item.total == 0
                                    ? Colors.grey.shade600
                                    : Colors.orange.shade900,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}

class DailyProgressPoint {
  const DailyProgressPoint({
    required this.date,
    required this.total,
    required this.shortWeekday,
  });

  final DateTime date;
  final int total;
  final String shortWeekday;
}

/// Simple in-memory progress store (resets when app restarts).
class ProgressStore {
  ProgressStore._();

  static final ProgressStore instance = ProgressStore._();

  final Map<String, Set<String>> _capitalLettersDoneByDate =
      <String, Set<String>>{};
  final Map<String, Set<String>> _smallLettersDoneByDate =
      <String, Set<String>>{};
  final Map<String, Set<String>> _numbersDoneByDate = <String, Set<String>>{};

  void markDone(TracingCategory category, String symbol) {
    final String todayKey = _dateKey(DateTime.now());
    switch (category) {
      case TracingCategory.capitalLetters:
        _capitalLettersDoneByDate
            .putIfAbsent(todayKey, () => <String>{})
            .add(symbol);
        break;
      case TracingCategory.smallLetters:
        _smallLettersDoneByDate
            .putIfAbsent(todayKey, () => <String>{})
            .add(symbol);
        break;
      case TracingCategory.numbers:
        _numbersDoneByDate.putIfAbsent(todayKey, () => <String>{}).add(symbol);
        break;
    }
  }

  int completedTodayCount(TracingCategory category) {
    final String todayKey = _dateKey(DateTime.now());
    switch (category) {
      case TracingCategory.capitalLetters:
        return _capitalLettersDoneByDate[todayKey]?.length ?? 0;
      case TracingCategory.smallLetters:
        return _smallLettersDoneByDate[todayKey]?.length ?? 0;
      case TracingCategory.numbers:
        return _numbersDoneByDate[todayKey]?.length ?? 0;
    }
  }

  int completedCount(TracingCategory category) {
    switch (category) {
      case TracingCategory.capitalLetters:
        return _capitalLettersDoneByDate.values.fold<int>(
          0,
          (sum, set) => sum + set.length,
        );
      case TracingCategory.smallLetters:
        return _smallLettersDoneByDate.values.fold<int>(
          0,
          (sum, set) => sum + set.length,
        );
      case TracingCategory.numbers:
        return _numbersDoneByDate.values.fold<int>(
          0,
          (sum, set) => sum + set.length,
        );
    }
  }

  int totalCount(TracingCategory category) {
    switch (category) {
      case TracingCategory.capitalLetters:
        return 26;
      case TracingCategory.smallLetters:
        return 26;
      case TracingCategory.numbers:
        return 10;
    }
  }

  int totalDoneOnDate(DateTime date) {
    return _completedForKey(_dateKey(date));
  }

  int currentStreakDays() {
    int streak = 0;
    DateTime date = DateTime.now();

    while (totalDoneOnDate(date) > 0) {
      streak++;
      date = date.subtract(const Duration(days: 1));
    }
    return streak;
  }

  List<DailyProgressPoint> recentDailyTotals(int days) {
    final DateTime now = DateTime.now();
    final List<DailyProgressPoint> points = [];
    const labels = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];

    for (int i = days - 1; i >= 0; i--) {
      final DateTime date = now.subtract(Duration(days: i));
      points.add(
        DailyProgressPoint(
          date: date,
          total: totalDoneOnDate(date),
          shortWeekday: labels[date.weekday - 1],
        ),
      );
    }
    return points;
  }

  int _completedForKey(String key) {
    return (_capitalLettersDoneByDate[key]?.length ?? 0) +
        (_smallLettersDoneByDate[key]?.length ?? 0) +
        (_numbersDoneByDate[key]?.length ?? 0);
  }

  String _dateKey(DateTime date) {
    final String month = date.month.toString().padLeft(2, '0');
    final String day = date.day.toString().padLeft(2, '0');
    return '${date.year}-$month-$day';
  }
}

enum TracingCategory { capitalLetters, smallLetters, numbers }

class Stroke {
  Stroke(this.points, this.color);

  final List<Offset> points;
  final Color color;
}

class TracingCanvas extends StatefulWidget {
  const TracingCanvas({
    super.key,
    required this.onStrokesChanged,
    this.strokeColor = Colors.deepPurple,
    this.strokeWidth = 10,
    this.clearVersion = 0,
  });

  final void Function(List<Stroke> strokes, Size size) onStrokesChanged;
  final Color strokeColor;
  final double strokeWidth;
  /// When this integer changes, the canvas clears all strokes.
  final int clearVersion;

  @override
  State<TracingCanvas> createState() => _TracingCanvasState();
}

class _TracingCanvasState extends State<TracingCanvas> {
  final List<Stroke> _strokes = [];
  Stroke? _currentStroke;
  Size _lastSize = Size.zero;
  int _seenClearVersion = 0;
  Rect? _allowedRect;

  void _notify(Size size) {
    _lastSize = size;
    widget.onStrokesChanged(List<Stroke>.unmodifiable(_strokes), _lastSize);
  }

  @override
  void didUpdateWidget(covariant TracingCanvas oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.clearVersion != _seenClearVersion) {
      _seenClearVersion = widget.clearVersion;
      _strokes.clear();
      _currentStroke = null;
      if (_lastSize != Size.zero) {
        _notify(_lastSize);
      }
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final size = Size(constraints.maxWidth, constraints.maxHeight);
        _allowedRect = _letterRectForSize(size);

        return GestureDetector(
          onPanStart: (details) {
            final RenderBox box = context.findRenderObject() as RenderBox;
            final localPos = box.globalToLocal(details.globalPosition);
            final rect = _allowedRect ?? _letterRectForSize(size);
            if (rect.contains(localPos)) {
              _currentStroke = Stroke([localPos], widget.strokeColor);
              _strokes.add(_currentStroke!);
              setState(() {});
              _notify(size);
            }
          },
          onPanUpdate: (details) {
            if (_currentStroke == null) return;
            final RenderBox box = context.findRenderObject() as RenderBox;
            final localPos = box.globalToLocal(details.globalPosition);
            if (_allowedRect?.contains(localPos) ?? true) {
              _currentStroke!.points.add(localPos);
              setState(() {});
              _notify(size);
            }
          },
          onPanEnd: (_) {
            _currentStroke = null;
            _notify(size);
          },
          child: CustomPaint(
            size: size,
            painter: _TracingPainter(
              strokes: _strokes,
              color: widget.strokeColor,
              strokeWidth: widget.strokeWidth,
            ),
          ),
        );
      },
    );
  }
}

class _TracingPainter extends CustomPainter {
  _TracingPainter({
    required this.strokes,
    required this.color,
    required this.strokeWidth,
  });

  final List<Stroke> strokes;
  final Color color;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    for (final stroke in strokes) {
      if (stroke.points.length < 2) continue;
      final paint = Paint()
        ..color = stroke.color
        ..strokeWidth = strokeWidth
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round;
      final path = Path()..moveTo(stroke.points.first.dx, stroke.points.first.dy);
      for (int i = 1; i < stroke.points.length; i++) {
        final p = stroke.points[i];
        path.lineTo(p.dx, p.dy);
      }
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _TracingPainter oldDelegate) {
    return oldDelegate.strokes != strokes ||
        oldDelegate.color != color ||
        oldDelegate.strokeWidth != strokeWidth;
  }
}

class _CheckpointPainter extends CustomPainter {
  _CheckpointPainter({
    required this.checkpoints,
    required this.hitIndices,
    required this.accentColor,
  });

  final List<Offset> checkpoints;
  final Set<int> hitIndices;
  final Color accentColor;

  @override
  void paint(Canvas canvas, Size size) {
    if (checkpoints.isEmpty) return;

    for (int i = 0; i < checkpoints.length; i++) {
      final cp = checkpoints[i];
      final bool hit = hitIndices.contains(i);
      final paint = Paint()
        ..color = hit ? accentColor : Colors.grey.withOpacity(0.4)
        ..style = PaintingStyle.fill;
      canvas.drawCircle(cp, hit ? 6 : 4, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _CheckpointPainter oldDelegate) {
    return oldDelegate.checkpoints != checkpoints ||
        oldDelegate.hitIndices.length != hitIndices.length ||
        oldDelegate.accentColor != accentColor;
  }
}

class _LetterPainter extends CustomPainter {
  _LetterPainter({
    required this.symbol,
    required this.color,
  });

  final String symbol;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = _letterRectForSize(size);

    // Draw a big grey character centered in the letter rect – same for all symbols.
    final textPainter = TextPainter(
      text: TextSpan(
        text: symbol,
        style: TextStyle(
          fontSize: rect.height * 0.8,
          fontWeight: FontWeight.bold,
          color: color,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    final offset = Offset(
      rect.left + (rect.width - textPainter.width) / 2,
      rect.top + (rect.height - textPainter.height) / 2,
    );
    textPainter.paint(canvas, offset);
  }

  @override
  bool shouldRepaint(covariant _LetterPainter oldDelegate) {
    return oldDelegate.symbol != symbol || oldDelegate.color != color;
  }
}

bool isTracingCoverageSufficient(
  List<Stroke> strokes,
  Size canvasSize, {
  double coverageThreshold = 0.6,
  double hitDistance = 20,
}) {
  // Deprecated: superseded by visual checkpoints logic.
  if (strokes.isEmpty || canvasSize.isEmpty) return false;
  return true;
}

Rect _letterRectForSize(Size size) {
  final width = size.width;
  final height = size.height;
  // Larger box so the letter fills more of the tracing area.
  // Still centered to keep proportions on phones and tablets.
  final double rectWidth = width * 0.55;
  final double rectHeight = height * 0.75;
  final double left = (width - rectWidth) / 2;
  final double top = (height - rectHeight) / 2;
  return Rect.fromLTWH(left, top, rectWidth, rectHeight);
}

class SymbolTracingScreen extends StatefulWidget {
  const SymbolTracingScreen({
    super.key,
    required this.category,
  });

  final TracingCategory category;

  @override
  State<SymbolTracingScreen> createState() => _SymbolTracingScreenState();
}

class _SymbolTracingScreenState extends State<SymbolTracingScreen> {
  late final List<String> _symbols;
  late final String _title;
  late final Color _accentColor;
  int _currentIndex = 0;
  List<Stroke> _currentStrokes = [];
  Size _canvasSize = Size.zero;
  bool _lastCheckSuccess = false;
  int _clearVersion = 0;
  Color _currentStrokeColor = Colors.deepPurple;
  final List<Color> _palette = const [
    Colors.red,
    Colors.green,
    Colors.blue,
    Colors.yellow,
    Colors.orange,
    Colors.black,
  ];

  late final ConfettiController _confettiController;
  late final AudioPlayer _clapPlayer;
  late final AudioPlayer _symbolSoundPlayer;
  late final FlutterTts _tts;

  @override
  void initState() {
    super.initState();
    _confettiController =
        ConfettiController(duration: const Duration(seconds: 2));
    _clapPlayer = AudioPlayer();
    _symbolSoundPlayer = AudioPlayer();
    _tts = FlutterTts();
    switch (widget.category) {
      case TracingCategory.capitalLetters:
        _symbols = List<String>.generate(26, (i) => String.fromCharCode(65 + i));
        _title = 'Capital Alphabets (A - Z)';
        _accentColor = Colors.pinkAccent;
        break;
      case TracingCategory.smallLetters:
        _symbols = List<String>.generate(26, (i) => String.fromCharCode(97 + i));
        _title = 'Small Alphabets (a - z)';
        _accentColor = Colors.greenAccent;
        break;
      case TracingCategory.numbers:
        _symbols = List<String>.generate(10, (i) => i.toString());
        _title = 'Numbers (0 - 9)';
        _accentColor = Colors.lightBlueAccent;
        break;
    }
    _configureAndSpeakCurrentSymbol();
  }

  @override
  void dispose() {
    _confettiController.dispose();
    _clapPlayer.dispose();
    _symbolSoundPlayer.dispose();
    _tts.stop();
    super.dispose();
  }

  String get _currentSymbol => _symbols[_currentIndex];

  Future<void> _configureAndSpeakCurrentSymbol() async {
    try {
      await _tts.setLanguage('en-US');
      await _tts.setSpeechRate(0.45);
      await _tts.setPitch(1.0);
    } catch (_) {
      // Continue even if TTS setup is not fully supported on device.
    }
    await _playCurrentSymbolSound();
  }

  Future<void> _playCurrentSymbolSound() async {
    final List<String> candidates = _customAudioCandidatesForCurrentSymbol();
    for (final assetPath in candidates) {
      final bool played = await _tryPlayCustomAsset(assetPath);
      if (played) return;
    }

    final String textToSpeak = _currentSymbol;
    try {
      await _tts.stop();
      await _tts.speak(textToSpeak);
    } catch (_) {
      // Ignore TTS failures to keep tracing experience smooth.
    }
  }

  List<String> _customAudioCandidatesForCurrentSymbol() {
    final String symbol = _currentSymbol;
    switch (widget.category) {
      case TracingCategory.capitalLetters:
        return <String>[
          'audio/$symbol.mp3',
          'audio/letters/capital/$symbol.mp3',
        ];
      case TracingCategory.smallLetters:
        return <String>[
          'audio/$symbol.mp3',
          'audio/letters/small/$symbol.mp3',
        ];
      case TracingCategory.numbers:
        return <String>[
          'audio/$symbol.mp3',
          'audio/numbers/$symbol.mp3',
        ];
    }
  }

  Future<bool> _tryPlayCustomAsset(String relativePath) async {
    try {
      await _symbolSoundPlayer.stop();
      await _symbolSoundPlayer.play(AssetSource(relativePath));
      return true;
    } catch (_) {
      return false;
    }
  }

  void _onStrokesChanged(List<Stroke> strokes, Size size) {
    _currentStrokes = strokes;
    _canvasSize = size;
  }

  Future<void> _checkTracing() async {
    final ok = _hasEnoughDrawing();
    setState(() {
      _lastCheckSuccess = ok;
    });
    if (ok) {
      ProgressStore.instance.markDone(widget.category, _currentSymbol);
      // Celebrate with confetti + clap sound.
      _confettiController.play();
      try {
        await _clapPlayer.play(AssetSource('audio/clap.mp3'));
      } catch (_) {
        // Ignore audio errors so UI continues smoothly.
      }
      await showDialog<void>(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Awesome!'),
            content: Text('You traced $_currentSymbol so well!'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Yay!'),
              ),
            ],
          );
        },
      );
    } else {
      await showDialog<void>(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Almost there'),
            content: const Text(
              'Try tracing over the whole shape of the letter or number.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Try again'),
              ),
            ],
          );
        },
      );
    }
  }

  bool _hasEnoughDrawing() {
    if (_canvasSize.isEmpty) return false;
    if (_currentStrokes.isEmpty) return false;

    // Kid-friendly: require a minimum number of drawn points inside the letter area.
    final Rect letterRect = _letterRectForSize(_canvasSize);
    int insidePoints = 0;
    for (final stroke in _currentStrokes) {
      for (final p in stroke.points) {
        if (letterRect.contains(p)) {
          insidePoints++;
        }
      }
    }
    return insidePoints >= 80;
  }

  Future<void> _goNext() async {
    if (_currentIndex < _symbols.length - 1) {
      setState(() {
        _currentIndex++;
        _currentStrokes = [];
        _lastCheckSuccess = false;
        _clearVersion++;
      });
      await _playCurrentSymbolSound();
    } else {
      showDialog<void>(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('All done!'),
            content: Text('You have finished all ${_symbols.length} symbols!'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Great'),
              ),
            ],
          );
        },
      );
    }
  }

  Future<void> _goPrevious() async {
    if (_currentIndex > 0) {
      setState(() {
        _currentIndex--;
        _currentStrokes = [];
        _lastCheckSuccess = false;
        _clearVersion++;
      });
      await _playCurrentSymbolSound();
    }
  }

  @override
  Widget build(BuildContext context) {
    final double bottomInset = MediaQuery.of(context).viewPadding.bottom;
    return Scaffold(
      appBar: AppBar(
        title: Text(_title),
        backgroundColor: _accentColor,
        foregroundColor: Colors.white,
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  _accentColor.withOpacity(0.1),
                  Colors.white,
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: SafeArea(
              bottom: true,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
            children: [
              Text(
                'Trace the $_currentSymbol',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: _accentColor,
                ),
              ),
              const SizedBox(height: 6),
              TextButton.icon(
                onPressed: _playCurrentSymbolSound,
                icon: const Icon(Icons.volume_up_rounded),
                label: const Text('Play sound'),
              ),
              const SizedBox(height: 8),
              Text(
                'Symbol ${_currentIndex + 1} of ${_symbols.length}',
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 16),
              // Color picker row
              SizedBox(
                height: 48,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(_palette.length, (index) {
                    final color = _palette[index];
                    final bool selected = color == _currentStrokeColor;
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 6),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _currentStrokeColor = color;
                          });
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          width: selected ? 44 : 38,
                          height: selected ? 44 : 38,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: color,
                            border: Border.all(
                              color:
                                  selected ? Colors.white : Colors.black12,
                              width: selected ? 3 : 2,
                            ),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 6,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 10,
                            offset: Offset(0, 6),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(16),
                      child: Stack(
                        children: [
                          Center(
                            child: CustomPaint(
                              painter: _LetterPainter(
                                symbol: _currentSymbol,
                                color: Colors.grey.withOpacity(0.2),
                              ),
                              size: Size.infinite,
                            ),
                          ),
                          Positioned.fill(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(24),
                              child: TracingCanvas(
                                onStrokesChanged: _onStrokesChanged,
                                strokeColor: _currentStrokeColor,
                                strokeWidth: 10,
                                clearVersion: _clearVersion,
                              ),
                            ),
                          ),
                          // Clear button with eraser icon at top-right
                          Positioned(
                            top: 0,
                            right: 0,
                            child: IconButton(
                              icon: const Icon(Icons.cleaning_services_outlined),
                              color: Colors.grey.shade700,
                              tooltip: 'Clear drawing',
                              onPressed: () {
                                setState(() {
                                  _currentStrokes = [];
                                  _lastCheckSuccess = false;
                                  _clearVersion++;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: EdgeInsets.only(bottom: bottomInset + 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: _currentIndex == 0 ? null : _goPrevious,
                      child: const Text('Previous'),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _accentColor,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: _checkTracing,
                      child: const Text('Done'),
                    ),
                    TextButton(
                      onPressed: _goNext,
                      child: const Text('Next'),
                    ),
                  ],
                ),
              ),
              if (_lastCheckSuccess)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    'Great tracing on $_currentSymbol!',
                    style: TextStyle(
                      color: _accentColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
          ),
          // Confetti overlay
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirectionality: BlastDirectionality.explosive,
              shouldLoop: false,
              maxBlastForce: 30,
              minBlastForce: 10,
              emissionFrequency: 0.2,
              numberOfParticles: 25,
            ),
          ),
        ],
      ),
    );
  }
}

