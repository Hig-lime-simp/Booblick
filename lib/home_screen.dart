import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fl_chart/fl_chart.dart';
import 'bublik_calculator.dart';
import 'text_field_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _sleepController = TextEditingController();
  final TextEditingController _gamesController = TextEditingController();

  final FocusNode _nameFocus = FocusNode();
  final FocusNode _sleepFocus = FocusNode();
  final FocusNode _gamesFocus = FocusNode();

  double _bublikPercent = 0.0;

  @override
  void initState() {
    super.initState();
    _nameFocus.addListener(_onFocusChange);
    _sleepFocus.addListener(_onFocusChange);
    _gamesFocus.addListener(_onFocusChange);
  }

  void _onFocusChange() {
    if (_nameFocus.hasFocus || _sleepFocus.hasFocus || _gamesFocus.hasFocus) {
      _hideHintDialog();
    }
  }

  void _hideHintDialog() {
    if (mounted && Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    }
  }

  void _updatePercent() {
    final String name = _nameController.text;
    final double sleep = double.tryParse(_sleepController.text) ?? 0.0;
    final double games = double.tryParse(_gamesController.text) ?? 0.0;

    setState(() {
      _bublikPercent = BublikCalculator.calculatePercent(
        name: name,
        sleep: sleep,
        games: games,
      );
    });
  }

  void _showHintDialog() {
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
      return;
    }
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Секрет бублика 🥯'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Для 100% бублика введи:'),
            SizedBox(height: 8),
            Text('Имя: Гриша', style: TextStyle(fontWeight: FontWeight.bold)),
            Text('Сон: 2 часа', style: TextStyle(fontWeight: FontWeight.bold)),
            Text('Игры: 22 часа', style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Понял!'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _sleepController.dispose();
    _gamesController.dispose();
    _nameFocus.dispose();
    _sleepFocus.dispose();
    _gamesFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isPortrait = MediaQuery.of(context).size.width < MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Бубликометр',
          style: GoogleFonts.lobster(fontSize: 28, color: Colors.white),
        ),
        backgroundColor: Colors.lightGreen,
        centerTitle: true,
        elevation: 4,
      ),
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 10),
                  Text(
                    'На сколько ты бублик?',
                    style: GoogleFonts.comfortaa(
                      fontSize: isPortrait ? 28 : 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.lightGreen.shade800,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  // Диаграмма
                  SizedBox(
                    height: isPortrait ? 280 : 220,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        AspectRatio(
                          aspectRatio: 1,
                          child: PieChart(
                            PieChartData(
                              sections: [
                                PieChartSectionData(
                                  value: _bublikPercent,
                                  title: '',
                                  color: Colors.lightGreen,
                                  radius: 80,
                                  showTitle: false,
                                ),
                                PieChartSectionData(
                                  value: 100 - _bublikPercent,
                                  title: '',
                                  color: Colors.grey.shade300,
                                  radius: 80,
                                  showTitle: false,
                                ),
                              ],
                              sectionsSpace: 0,
                              centerSpaceRadius: 50,
                              startDegreeOffset: -90,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 8,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: Text(
                            '${_bublikPercent.toInt()}%',
                            style: GoogleFonts.comfortaa(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.lightGreen.shade800,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          TextFieldWidget(
                            label: 'Ваше имя',
                            controller: _nameController,
                            focusNode: _nameFocus,
                            keyboardType: TextInputType.text,
                            onTap: _hideHintDialog,
                          ),
                          const SizedBox(height: 16),
                          TextFieldWidget(
                            label: 'Часы сна (0-24)',
                            controller: _sleepController,
                            focusNode: _sleepFocus,
                            keyboardType: TextInputType.number,
                            onTap: _hideHintDialog,
                          ),
                          const SizedBox(height: 16),
                          TextFieldWidget(
                            label: 'Часы в видеоиграх (0-24)',
                            controller: _gamesController,
                            focusNode: _gamesFocus,
                            keyboardType: TextInputType.number,
                            onTap: _hideHintDialog,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: _updatePercent,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.lightGreen,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 54),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                      elevation: 5,
                    ),
                    child: Text(
                      'ПРОВЕРИТЬ БУБЛИЧНОСТЬ',
                      style: GoogleFonts.comfortaa(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
            Positioned(
              left: 16,
              bottom: 16,
              child: FloatingActionButton.small(
                heroTag: null,
                onPressed: _showHintDialog,
                backgroundColor: Colors.lightGreen.shade700,
                child: const Icon(Icons.help_outline, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}