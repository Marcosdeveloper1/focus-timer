import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await MobileAds.instance.initialize();
  await NotificationService.instance.init();
  runApp(const PomodoroApp());
}

// ─── AD IDs ───────────────────────────────────────────────────────────────────

class AdIds {
  static const String banner = 'ca-app-pub-6589272823210777/7656775535';
  static const String rewarded = 'ca-app-pub-6589272823210777/2623940708';
}

// ─── NOTIFICATION SERVICE ─────────────────────────────────────────────────────

class NotificationService {
  NotificationService._();
  static final NotificationService instance = NotificationService._();
  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    await _plugin
        .initialize(const InitializationSettings(android: androidSettings));
    await _plugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
    const channel = AndroidNotificationChannel(
      'pomodoro_timer',
      'Pomodoro Timer',
      description: 'Notificações do timer',
      importance: Importance.low,
      playSound: false,
      enableVibration: false,
    );
    await _plugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  Future<void> showTimerRunning({
    required int secondsLeft,
    required String modeName,
    required Color color,
  }) async {
    final endTime = DateTime.now().millisecondsSinceEpoch + secondsLeft * 1000;
    final details = AndroidNotificationDetails(
      'pomodoro_timer',
      'Pomodoro Timer',
      importance: Importance.low,
      priority: Priority.low,
      ongoing: true,
      autoCancel: false,
      showWhen: true,
      when: endTime,
      usesChronometer: true,
      chronometerCountDown: true,
      playSound: false,
      enableVibration: false,
      color: color,
    );
    await _plugin.show(1, modeName, 'Mantendo o foco 🍅',
        NotificationDetails(android: details));
  }

  Future<void> showTimerComplete(String modeName) async {
    const details = AndroidNotificationDetails(
      'pomodoro_timer',
      'Pomodoro Timer',
      importance: Importance.high,
      priority: Priority.high,
    );
    final isFocus = modeName.contains('Foco');
    await _plugin.show(
      2,
      '⏰ $modeName concluído!',
      isFocus ? 'Hora de descansar 🎉' : 'Hora de focar! 💪',
      const NotificationDetails(android: details),
    );
  }

  Future<void> cancelTimer() => _plugin.cancel(1);
}

// ─── THEMES ───────────────────────────────────────────────────────────────────

class AppTheme {
  final String id, name, emoji;
  final Color background, surface, primary, textPrimary, textSecondary;
  final bool isPremium;
  const AppTheme({
    required this.id,
    required this.name,
    required this.emoji,
    required this.background,
    required this.surface,
    required this.primary,
    required this.textPrimary,
    required this.textSecondary,
    required this.isPremium,
  });
}

final List<AppTheme> appThemes = [
  const AppTheme(
      id: 'midnight', name: 'Midnight', emoji: '🌑',
      background: Color(0xFF0D0D0D), surface: Color(0xFF1A1A1A),
      primary: Color(0xFF00C896), textPrimary: Color(0xFFF0F0F0),
      textSecondary: Color(0xFF888888), isPremium: false),
  const AppTheme(
      id: 'ocean', name: 'Ocean', emoji: '🌊',
      background: Color(0xFF0A1628), surface: Color(0xFF112240),
      primary: Color(0xFF64FFDA), textPrimary: Color(0xFFCCD6F6),
      textSecondary: Color(0xFF8892B0), isPremium: true),
  const AppTheme(
      id: 'ember', name: 'Ember', emoji: '🔥',
      background: Color(0xFF120A00), surface: Color(0xFF1E1100),
      primary: Color(0xFFFF6B35), textPrimary: Color(0xFFFFF3E0),
      textSecondary: Color(0xFFBCAAA4), isPremium: true),
  const AppTheme(
      id: 'forest', name: 'Forest', emoji: '🌿',
      background: Color(0xFF071A0E), surface: Color(0xFF0E2618),
      primary: Color(0xFF52B788), textPrimary: Color(0xFFD8F3DC),
      textSecondary: Color(0xFF74C69D), isPremium: true),
  const AppTheme(
      id: 'sakura', name: 'Sakura', emoji: '🌸',
      background: Color(0xFF1A080F), surface: Color(0xFF280D18),
      primary: Color(0xFFFF85A1), textPrimary: Color(0xFFFFE0EC),
      textSecondary: Color(0xFFBB7A8A), isPremium: true),
  const AppTheme(
      id: 'neon', name: 'Neon', emoji: '⚡',
      background: Color(0xFF050010), surface: Color(0xFF0A0020),
      primary: Color(0xFFE040FB), textPrimary: Color(0xFFF8F0FF),
      textSecondary: Color(0xFF9C6CB7), isPremium: true),
  const AppTheme(
      id: 'galaxy', name: 'Galaxy', emoji: '🌌',
      background: Color(0xFF05020F), surface: Color(0xFF0D0820),
      primary: Color(0xFFC77DFF), textPrimary: Color(0xFFE8D5FF),
      textSecondary: Color(0xFF9E77BD), isPremium: true),
  const AppTheme(
      id: 'coffee', name: 'Coffee', emoji: '☕',
      background: Color(0xFF120B06), surface: Color(0xFF1E1208),
      primary: Color(0xFFC4895A), textPrimary: Color(0xFFF5E6D3),
      textSecondary: Color(0xFF9A7055), isPremium: true),
  const AppTheme(
      id: 'desert', name: 'Desert', emoji: '🏜️',
      background: Color(0xFF1A1000), surface: Color(0xFF261800),
      primary: Color(0xFFFFB347), textPrimary: Color(0xFFFFF3DC),
      textSecondary: Color(0xFFC49450), isPremium: true),
  const AppTheme(
      id: 'arctic', name: 'Arctic', emoji: '❄️',
      background: Color(0xFF071520), surface: Color(0xFF0D2030),
      primary: Color(0xFFA8DADC), textPrimary: Color(0xFFE0F4FF),
      textSecondary: Color(0xFF7AAABB), isPremium: true),
];

// ─── AD MANAGER ───────────────────────────────────────────────────────────────

class AdManager {
  BannerAd? _bannerAd;
  bool _bannerLoaded = false;
  RewardedAd? _rewardedAd;
  BannerAd? get bannerAd => _bannerLoaded ? _bannerAd : null;

  void loadBanner(VoidCallback onLoaded) {
    _bannerAd = BannerAd(
      adUnitId: AdIds.banner,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (_) { _bannerLoaded = true; onLoaded(); },
        onAdFailedToLoad: (ad, _) { ad.dispose(); _bannerLoaded = false; },
      ),
    )..load();
  }

  void loadRewarded() {
    RewardedAd.load(
      adUnitId: AdIds.rewarded,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) => _rewardedAd = ad,
        onAdFailedToLoad: (_) => _rewardedAd = null,
      ),
    );
  }

  void showRewarded({required VoidCallback onRewarded, required VoidCallback onFailed}) {
    if (_rewardedAd == null) { onFailed(); return; }
    _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose(); _rewardedAd = null; loadRewarded();
      },
      onAdFailedToShowFullScreenContent: (ad, _) {
        ad.dispose(); _rewardedAd = null; onFailed(); loadRewarded();
      },
    );
    _rewardedAd!.show(onUserEarnedReward: (_, __) => onRewarded());
  }

  void dispose() { _bannerAd?.dispose(); _rewardedAd?.dispose(); }
}

// ─── STATE ────────────────────────────────────────────────────────────────────

enum TimerMode { pomodoro, shortBreak, longBreak }

class PomodoroState extends ChangeNotifier {
  TimerMode _mode = TimerMode.pomodoro;
  bool _isRunning = false;
  Timer? _timer;
  int _completedPomodoros = 0;
  AppTheme _theme = appThemes[0];
  final Set<String> _unlockedThemes = {'midnight'};
  final AdManager adManager = AdManager();

  int focusDuration = 25;
  int shortBreakDuration = 5;
  int longBreakDuration = 15;
  late int _secondsLeft = focusDuration * 60;

  TimerMode get mode => _mode;
  int get secondsLeft => _secondsLeft;
  bool get isRunning => _isRunning;
  int get completedPomodoros => _completedPomodoros;
  AppTheme get theme => _theme;
  Set<String> get unlockedThemes => _unlockedThemes;

  int get totalSeconds {
    switch (_mode) {
      case TimerMode.pomodoro:   return focusDuration * 60;
      case TimerMode.shortBreak: return shortBreakDuration * 60;
      case TimerMode.longBreak:  return longBreakDuration * 60;
    }
  }

  double get progress => 1.0 - (_secondsLeft / totalSeconds);

  String get timeString {
    final m = (_secondsLeft ~/ 60).toString().padLeft(2, '0');
    final s = (_secondsLeft % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  String get modeLabel {
    switch (_mode) {
      case TimerMode.pomodoro:   return 'Foco';
      case TimerMode.shortBreak: return 'Pausa Curta';
      case TimerMode.longBreak:  return 'Pausa Longa';
    }
  }

  void setMode(TimerMode mode) {
    _timer?.cancel();
    _isRunning = false;
    _mode = mode;
    _secondsLeft = totalSeconds;
    NotificationService.instance.cancelTimer();
    notifyListeners();
  }

  void toggleTimer() {
    if (_isRunning) {
      _timer?.cancel();
      _isRunning = false;
      NotificationService.instance.cancelTimer();
    } else {
      _isRunning = true;
      NotificationService.instance.showTimerRunning(
          secondsLeft: _secondsLeft, modeName: modeLabel, color: _theme.primary);
      _timer = Timer.periodic(const Duration(seconds: 1), (_) {
        if (_secondsLeft > 0) {
          _secondsLeft--;
          notifyListeners();
        } else {
          _timer?.cancel();
          _isRunning = false;
          if (_mode == TimerMode.pomodoro) _completedPomodoros++;
          NotificationService.instance.cancelTimer();
          NotificationService.instance.showTimerComplete(modeLabel);
          notifyListeners();
        }
      });
    }
    notifyListeners();
  }

  void reset() {
    _timer?.cancel();
    _isRunning = false;
    _secondsLeft = totalSeconds;
    NotificationService.instance.cancelTimer();
    notifyListeners();
  }

  void setTheme(AppTheme t) {
    if (!t.isPremium || _unlockedThemes.contains(t.id)) {
      _theme = t;
      notifyListeners();
    }
  }

  void unlockTheme(String themeId) {
    _unlockedThemes.add(themeId);
    _theme = appThemes.firstWhere((t) => t.id == themeId);
    notifyListeners();
  }

  void updateDurations({required int focus, required int shortBreak, required int longBreak}) {
    focusDuration = focus;
    shortBreakDuration = shortBreak;
    longBreakDuration = longBreak;
    _timer?.cancel();
    _isRunning = false;
    _secondsLeft = totalSeconds;
    NotificationService.instance.cancelTimer();
    notifyListeners();
  }

  @override
  void dispose() {
    _timer?.cancel();
    adManager.dispose();
    super.dispose();
  }
}

// ─── APP ROOT ─────────────────────────────────────────────────────────────────

class PomodoroApp extends StatefulWidget {
  const PomodoroApp({super.key});
  @override
  State<PomodoroApp> createState() => _PomodoroAppState();
}

class _PomodoroAppState extends State<PomodoroApp> {
  final PomodoroState _state = PomodoroState();

  @override
  void initState() {
    super.initState();
    _state.adManager.loadBanner(() => setState(() {}));
    _state.adManager.loadRewarded();
  }

  @override
  void dispose() { _state.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _state,
      builder: (context, _) {
        final t = _state.theme;
        return MaterialApp(
          title: 'Focus Timer',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            scaffoldBackgroundColor: t.background,
            colorScheme: ColorScheme.dark(primary: t.primary, surface: t.surface),
          ),
          home: HomeScreen(state: _state),
        );
      },
    );
  }
}

// ─── HOME SCREEN ──────────────────────────────────────────────────────────────

class HomeScreen extends StatelessWidget {
  final PomodoroState state;
  const HomeScreen({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: state,
      builder: (context, _) {
        final t = state.theme;
        final bannerAd = state.adManager.bannerAd;
        return Scaffold(
          backgroundColor: t.background,
          body: SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('FOCUS TIMER',
                          style: TextStyle(color: t.primary, fontSize: 13,
                              fontWeight: FontWeight.w700, letterSpacing: 3)),
                      Row(children: [
                        _StatChip(label: '${state.completedPomodoros}', icon: '🍅', theme: t),
                        const SizedBox(width: 4),
                        IconButton(
                            icon: Icon(Icons.tune_rounded, color: t.textSecondary, size: 22),
                            onPressed: () => _showSettingsSheet(context)),
                        IconButton(
                            icon: Icon(Icons.palette_outlined, color: t.textSecondary, size: 22),
                            onPressed: () => _showThemeSheet(context)),
                      ]),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    decoration: BoxDecoration(color: t.surface, borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.all(4),
                    child: Row(
                      children: TimerMode.values.map((mode) {
                        final isSelected = state.mode == mode;
                        final labels = ['Foco', 'Pausa', 'Longa'];
                        final idx = TimerMode.values.indexOf(mode);
                        return Expanded(
                          child: GestureDetector(
                            onTap: () => state.setMode(mode),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              decoration: BoxDecoration(
                                color: isSelected ? t.primary : Colors.transparent,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(labels[idx],
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: isSelected ? t.background : t.textSecondary,
                                      fontSize: 13, fontWeight: FontWeight.w600)),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
                const Spacer(),
                _TimerRing(state: state),
                const Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                        onPressed: state.reset,
                        icon: Icon(Icons.refresh_rounded, color: t.textSecondary, size: 28)),
                    const SizedBox(width: 24),
                    _PlayButton(state: state),
                    const SizedBox(width: 24),
                    IconButton(
                        onPressed: () => state.setMode(
                            state.mode == TimerMode.pomodoro
                                ? TimerMode.shortBreak
                                : TimerMode.pomodoro),
                        icon: Icon(Icons.skip_next_rounded, color: t.textSecondary, size: 28)),
                  ],
                ),
                const SizedBox(height: 12),
                Text(state.modeLabel.toUpperCase(),
                    style: TextStyle(color: t.textSecondary, fontSize: 11, letterSpacing: 3)),
                const SizedBox(height: 20),
                if (bannerAd != null)
                  SizedBox(
                    width: bannerAd.size.width.toDouble(),
                    height: bannerAd.size.height.toDouble(),
                    child: AdWidget(ad: bannerAd),
                  )
                else
                  Container(
                    width: double.infinity, height: 52,
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                        color: t.surface, borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: t.primary.withValues(alpha: 0.2))),
                    child: Center(child: Text('Carregando anúncio...',
                        style: TextStyle(color: t.textSecondary, fontSize: 11))),
                  ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showThemeSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: state.theme.surface,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.75,
        maxChildSize: 0.92,
        minChildSize: 0.4,
        builder: (_, controller) => ThemeSheet(state: state, scrollController: controller),
      ),
    );
  }

  void _showSettingsSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: state.theme.surface,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => SettingsSheet(state: state),
    );
  }
}

// ─── TIMER RING ───────────────────────────────────────────────────────────────

class _TimerRing extends StatelessWidget {
  final PomodoroState state;
  const _TimerRing({required this.state});
  @override
  Widget build(BuildContext context) {
    final t = state.theme;
    return SizedBox(
      width: 260, height: 260,
      child: Stack(alignment: Alignment.center, children: [
        SizedBox.expand(child: CircularProgressIndicator(value: 1.0, strokeWidth: 6, color: t.surface)),
        SizedBox.expand(child: CircularProgressIndicator(
            value: state.progress, strokeWidth: 6, color: t.primary, strokeCap: StrokeCap.round)),
        Column(mainAxisSize: MainAxisSize.min, children: [
          Text(state.timeString,
              style: TextStyle(color: t.textPrimary, fontSize: 58,
                  fontWeight: FontWeight.w300, letterSpacing: 4)),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
                color: t.primary.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(20)),
            child: Text(state.isRunning ? '● EM FOCO' : '○ PAUSADO',
                style: TextStyle(color: t.primary, fontSize: 11,
                    letterSpacing: 2, fontWeight: FontWeight.w600)),
          ),
        ]),
      ]),
    );
  }
}

// ─── PLAY BUTTON ──────────────────────────────────────────────────────────────

class _PlayButton extends StatelessWidget {
  final PomodoroState state;
  const _PlayButton({required this.state});
  @override
  Widget build(BuildContext context) {
    final t = state.theme;
    return GestureDetector(
      onTap: () { HapticFeedback.mediumImpact(); state.toggleTimer(); },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 72, height: 72,
        decoration: BoxDecoration(
          color: state.isRunning ? t.surface : t.primary,
          shape: BoxShape.circle,
          border: Border.all(color: t.primary, width: 2),
          boxShadow: state.isRunning ? []
              : [BoxShadow(color: t.primary.withValues(alpha: 0.4), blurRadius: 20, spreadRadius: 2)],
        ),
        child: Icon(state.isRunning ? Icons.pause_rounded : Icons.play_arrow_rounded,
            color: state.isRunning ? t.primary : t.background, size: 36),
      ),
    );
  }
}

// ─── STAT CHIP ────────────────────────────────────────────────────────────────

class _StatChip extends StatelessWidget {
  final String label, icon;
  final AppTheme theme;
  const _StatChip({required this.label, required this.icon, required this.theme});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(color: theme.surface, borderRadius: BorderRadius.circular(20)),
      child: Text('$icon $label', style: TextStyle(color: theme.textSecondary, fontSize: 13)),
    );
  }
}

// ─── SETTINGS SHEET ───────────────────────────────────────────────────────────

class SettingsSheet extends StatefulWidget {
  final PomodoroState state;
  const SettingsSheet({super.key, required this.state});
  @override
  State<SettingsSheet> createState() => _SettingsSheetState();
}

class _SettingsSheetState extends State<SettingsSheet> {
  late int _focus, _shortBreak, _longBreak;
  @override
  void initState() {
    super.initState();
    _focus = widget.state.focusDuration;
    _shortBreak = widget.state.shortBreakDuration;
    _longBreak = widget.state.longBreakDuration;
  }

  @override
  Widget build(BuildContext context) {
    final t = widget.state.theme;
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('CONFIGURAÇÕES',
            style: TextStyle(color: t.primary, fontSize: 12, letterSpacing: 3, fontWeight: FontWeight.w700)),
        const SizedBox(height: 24),
        _DurationSlider(label: '⏱ Foco', value: _focus, min: 1, max: 60, theme: t,
            onChanged: (v) => setState(() => _focus = v)),
        const SizedBox(height: 12),
        _DurationSlider(label: '☕ Pausa Curta', value: _shortBreak, min: 1, max: 30, theme: t,
            onChanged: (v) => setState(() => _shortBreak = v)),
        const SizedBox(height: 12),
        _DurationSlider(label: '🛋 Pausa Longa', value: _longBreak, min: 1, max: 60, theme: t,
            onChanged: (v) => setState(() => _longBreak = v)),
        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: t.primary,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
            onPressed: () {
              widget.state.updateDurations(focus: _focus, shortBreak: _shortBreak, longBreak: _longBreak);
              Navigator.pop(context);
            },
            child: Text('Salvar',
                style: TextStyle(color: t.background, fontWeight: FontWeight.w700, fontSize: 15)),
          ),
        ),
        const SizedBox(height: 8),
      ]),
    );
  }
}

class _DurationSlider extends StatelessWidget {
  final String label;
  final int value, min, max;
  final AppTheme theme;
  final ValueChanged<int> onChanged;
  const _DurationSlider({required this.label, required this.value,
      required this.min, required this.max, required this.theme, required this.onChanged});
  @override
  Widget build(BuildContext context) {
    final t = theme;
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(label, style: TextStyle(color: t.textPrimary, fontSize: 14, fontWeight: FontWeight.w600)),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
              color: t.primary.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(20)),
          child: Text('$value min',
              style: TextStyle(color: t.primary, fontSize: 13, fontWeight: FontWeight.w700)),
        ),
      ]),
      SliderTheme(
        data: SliderThemeData(
            activeTrackColor: t.primary,
            inactiveTrackColor: t.primary.withValues(alpha: 0.2),
            thumbColor: t.primary,
            overlayColor: t.primary.withValues(alpha: 0.15)),
        child: Slider(
            value: value.toDouble(), min: min.toDouble(), max: max.toDouble(),
            divisions: max - min, onChanged: (v) => onChanged(v.round())),
      ),
    ]);
  }
}

// ─── THEME SHEET ──────────────────────────────────────────────────────────────

class ThemeSheet extends StatelessWidget {
  final PomodoroState state;
  final ScrollController scrollController;
  const ThemeSheet({super.key, required this.state, required this.scrollController});

  @override
  Widget build(BuildContext context) {
    final t = state.theme;
    return AnimatedBuilder(
      animation: state,
      builder: (context, _) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Center(child: Container(
                width: 40, height: 4,
                decoration: BoxDecoration(
                    color: t.textSecondary.withValues(alpha: 0.4),
                    borderRadius: BorderRadius.circular(2)))),
            const SizedBox(height: 16),
            Text('TEMAS', style: TextStyle(color: t.primary, fontSize: 12,
                letterSpacing: 3, fontWeight: FontWeight.w700)),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                controller: scrollController,
                itemCount: appThemes.length,
                itemBuilder: (context, i) {
                  final theme = appThemes[i];
                  final isActive = state.theme.id == theme.id;
                  final isUnlocked = state.unlockedThemes.contains(theme.id);
                  return GestureDetector(
                    onTap: () {
                      if (!theme.isPremium || isUnlocked) {
                        state.setTheme(theme);
                        Navigator.pop(context);
                      } else {
                        _requestUnlock(context, theme);
                      }
                    },
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                          color: isActive ? theme.primary.withValues(alpha: 0.15) : t.background,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                              color: isActive ? theme.primary : Colors.white12,
                              width: isActive ? 1.5 : 1)),
                      child: Row(children: [
                        Text(theme.emoji, style: const TextStyle(fontSize: 24)),
                        const SizedBox(width: 14),
                        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Text(theme.name,
                              style: TextStyle(color: t.textPrimary, fontWeight: FontWeight.w600)),
                          Text(theme.isPremium
                              ? (isUnlocked ? 'Desbloqueado ✓' : 'Assistir anúncio para desbloquear')
                              : 'Grátis',
                              style: TextStyle(color: t.textSecondary, fontSize: 12)),
                        ])),
                        Row(children: [
                          _ColorDot(color: theme.background),
                          _ColorDot(color: theme.surface),
                          _ColorDot(color: theme.primary),
                        ]),
                        const SizedBox(width: 8),
                        if (theme.isPremium && !isUnlocked)
                          Icon(Icons.play_circle_outline_rounded, color: t.primary, size: 22),
                        if (isActive)
                          Icon(Icons.check_circle_rounded, color: theme.primary, size: 22),
                      ]),
                    ),
                  );
                },
              ),
            ),
          ]),
        );
      },
    );
  }

  void _requestUnlock(BuildContext context, AppTheme theme) {
    final t = state.theme;
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: t.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Desbloquear ${theme.name}', style: TextStyle(color: t.textPrimary)),
        content: Text('Assista a um anúncio curto para desbloquear este tema permanentemente.',
            style: TextStyle(color: t.textSecondary)),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancelar', style: TextStyle(color: t.textSecondary))),
          ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: t.primary),
              onPressed: () {
                Navigator.pop(context);
                state.adManager.showRewarded(
                  onRewarded: () { state.unlockTheme(theme.id); Navigator.pop(context); },
                  onFailed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Anúncio não disponível. Tente novamente.')));
                    state.adManager.loadRewarded();
                  },
                );
              },
              child: Text('Assistir', style: TextStyle(color: t.background))),
        ],
      ),
    );
  }
}

class _ColorDot extends StatelessWidget {
  final Color color;
  const _ColorDot({required this.color});
  @override
  Widget build(BuildContext context) => Container(
        width: 12, height: 12,
        margin: const EdgeInsets.only(right: 3),
        decoration: BoxDecoration(
            color: color, shape: BoxShape.circle,
            border: Border.all(color: Colors.white24, width: 0.5)),
      );
}
