import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import 'dart:async';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'modo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.black,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.black,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      themeMode: ThemeMode.system,
      home: const MyHomePage(title: 'pomo'),
    );
  }
}

class SwipeableTimeComponent extends StatelessWidget {
  final int value;
  final double fontSize;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final VoidCallback onTap;
  final int maxValue;

  const SwipeableTimeComponent({
    Key? key,
    required this.value,
    required this.fontSize,
    required this.onIncrement,
    required this.onDecrement,
    required this.onTap,
    required this.maxValue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');

    return GestureDetector(
      onTap: onTap,
      onPanUpdate: (details) {
        final dy = details.delta.dy * 0.1;
        const threshold = 0.8;
        
        if (dy < -threshold) {
          // Swipe up - increment
          onIncrement();
        } else if (dy > threshold) {
          // Swipe down - decrement
          onDecrement();
        }
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * 0.009,
          vertical: MediaQuery.of(context).size.height * 0.009,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(MediaQuery.of(context).size.width * 0.02),
        ),
        child: Text(
          twoDigits(value),
          textAlign: TextAlign.center,
          style: GoogleFonts.getFont(
            'Roboto Mono',
            textStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}

class TimeDisplay extends StatelessWidget {
  final int hours;
  final int minutes;
  final int seconds;
  final double fontSize;
  final VoidCallback onHoursIncrement;
  final VoidCallback onHoursDecrement;
  final VoidCallback onMinutesIncrement;
  final VoidCallback onMinutesDecrement;
  final VoidCallback onSecondsIncrement;
  final VoidCallback onSecondsDecrement;
  final VoidCallback onHoursTap;
  final VoidCallback onMinutesTap;
  final VoidCallback onSecondsTap;

  const TimeDisplay({
    Key? key,
    required this.hours,
    required this.minutes,
    required this.seconds,
    required this.fontSize,
    required this.onHoursIncrement,
    required this.onHoursDecrement,
    required this.onMinutesIncrement,
    required this.onMinutesDecrement,
    required this.onSecondsIncrement,
    required this.onSecondsDecrement,
    required this.onHoursTap,
    required this.onMinutesTap,
    required this.onSecondsTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SwipeableTimeComponent(
          value: hours,
          fontSize: fontSize,
          onIncrement: onHoursIncrement,
          onDecrement: onHoursDecrement,
          onTap: onHoursTap,
          maxValue: 99,
        ),
        Text(
          ':',
          style: GoogleFonts.getFont(
            'Roboto Mono',
            textStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
        ),
        SwipeableTimeComponent(
          value: minutes,
          fontSize: fontSize,
          onIncrement: onMinutesIncrement,
          onDecrement: onMinutesDecrement,
          onTap: onMinutesTap,
          maxValue: 59,
        ),
        Text(
          ':',
          style: GoogleFonts.getFont(
            'Roboto Mono',
            textStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
        ),
        SwipeableTimeComponent(
          value: seconds,
          fontSize: fontSize,
          onIncrement: onSecondsIncrement,
          onDecrement: onSecondsDecrement,
          onTap: onSecondsTap,
          maxValue: 59,
        ),
      ],
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _hours = 0;
  int _minutes = 0;
  int _seconds = 0;

  int _timeElapsed = 0; // used to track cycles
  int _studyTime = 25 * 60; // 25 min intervals.
  int _breakTime = 5 * 60; //  5 min intervals.
  int _cycleCount = 0; // amount of times cycled.
  int _cycleThresh = 5; // total cycles wanted

  String minConvert(int seconds) {
    int minutes = seconds ~/ 60;
    if (minutes < 1) {
      return "${seconds} sec";
    }else{
      return "${minutes} min";
    }


  }
  // increment setters
  void _incrementSeconds() {
    setState(() {
      if (_seconds + 1 >= 60) {
        _incrementMinutes();
        _seconds = 0;
      } else {
        _seconds++;
      }
    });
  }
  void _incrementMinutes() {
    setState(() {
      if (_minutes + 1 >= 60) {
        _incrementHours();
        _minutes = 0;
      } else {
        _minutes++;
      }
    });
  }
  void _incrementHours() {
    setState(() {
      if (_hours + 1 >= 100) {
        _hours = 0;
      } else {
        _hours++;
      }
    });
  }

  // decrement setters
  void _decrementSeconds() {
    setState(() {
      if (_seconds - 1 <= -1) {
        if (_minutes > 0 || _hours > 0) {
          _decrementMinutes();
          _seconds = 59;
        } else {
          _seconds = 0;
        }
      } else {
        _seconds--;
      }
    });
  }
  void _decrementMinutes() {
    setState(() {
      if (_minutes - 1 <= -1) {
        if (_hours > 0) {
          _decrementHours();
          _minutes = 59;
        } else {
          _minutes = 0;
        }
      } else {
        _minutes--;
      }
    });
  }
  void _decrementHours() {
    setState(() {
      if (_hours - 1 <= -1) {
        _hours = 99;
      } else {
        _hours--;
      }
    });
  }

  Timer? _timer;

  Future<void> _beginBreak() async {
    // pauseFlip() has already been called above
    // now wait for the breakTime without blocking the UI:
    _header = "break";
    await Future.delayed(Duration(seconds: _breakTime));

    // once the break is over, bump the cycle and resume:
    setState(() {
      _cycleCount++;
    });
    _pauseFlip();
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_hours == 0 && _minutes == 0 && _seconds == 0) {
        _timer?.cancel();
        _pauseFlip();
      } else {
         if (_timeElapsed >= _studyTime) {
            // time for a break!
            _pauseFlip();
            _timeElapsed = 0;
            // sleep for break
            _beginBreak();
         }else{
            setState(() {
              _timeElapsed++; // +1 second.
              _decrementSeconds();
             });
         }
      }
    });
  }
  void _pauseTimer() {
    _timer?.cancel(); // stop the timer
    _isPaused = true;
  }


  // Parse time string (supports formats like "2:00", "12:23:00", "1:30:45")
  void _parseTimeString(String timeString) {
    final parts = timeString.split(':');
    
    if (parts.length == 2) {
      // Format: MM:SS
      final minutes = int.tryParse(parts[0]) ?? 0;
      final seconds = int.tryParse(parts[1]) ?? 0;
      
      if (minutes >= 0 && minutes <= 59 && seconds >= 0 && seconds <= 59) {
        setState(() {
          _hours = 0;
          _minutes = minutes;
          _seconds = seconds;
        });
      }
    } else if (parts.length == 3) {
      // Format: HH:MM:SS
      final hours = int.tryParse(parts[0]) ?? 0;
      final minutes = int.tryParse(parts[1]) ?? 0;
      final seconds = int.tryParse(parts[2]) ?? 0;
      
      if (hours >= 0 && hours <= 99 && minutes >= 0 && minutes <= 59 && seconds >= 0 && seconds <= 59) {
        setState(() {
          _hours = hours;
          _minutes = minutes;
          _seconds = seconds;
        });
      }
    }
  }

  // Universal time input dialog
  void _showTimeInputDialog() {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final currentTime = _hours > 0 
        ? '${twoDigits(_hours)}:${twoDigits(_minutes)}:${twoDigits(_seconds)}'
        : '${twoDigits(_minutes)}:${twoDigits(_seconds)}';
    
    final TextEditingController controller = TextEditingController(text: currentTime);
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Enter Time'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: controller,
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(
                  hintText: 'e.g., 2:30 or 1:23:45',
                  border: OutlineInputBorder(),
                ),
                autofocus: true,
              ),
              const SizedBox(height: 8),
              Text(
                'Formats:\n• MM:SS (e.g., 2:30)\n• HH:MM:SS (e.g., 1:23:45)',
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                final timeString = controller.text.trim();
                final parts = timeString.split(':');
                
                bool isValid = false;
                if (parts.length == 2) {
                  // MM:SS format
                  final minutes = int.tryParse(parts[0]);
                  final seconds = int.tryParse(parts[1]);
                  isValid = minutes != null && seconds != null && 
                           minutes >= 0 && minutes <= 59 && 
                           seconds >= 0 && seconds <= 59;
                } else if (parts.length == 3) {
                  // HH:MM:SS format
                  final hours = int.tryParse(parts[0]);
                  final minutes = int.tryParse(parts[1]);
                  final seconds = int.tryParse(parts[2]);
                  isValid = hours != null && minutes != null && seconds != null &&
                           hours >= 0 && hours <= 99 &&
                           minutes >= 0 && minutes <= 59 &&
                           seconds >= 0 && seconds <= 59;
                }
                
                if (isValid) {
                  _parseTimeString(timeString);
                  Navigator.of(context).pop();
                } 
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _onHoursTap() {
    _showTimeInputDialog();
  }

  void _onMinutesTap() {
    _showTimeInputDialog();
  }

  void _onSecondsTap() {
    _showTimeInputDialog();
  }
  
  // appbar stuff
  String _header = "pace"; // pace -> paused
  bool _isPaused = true;
  void _pauseFlip() {
    setState(() {
      _isPaused = !_isPaused; // flip pause
      if (_isPaused) {
        _header = "pace";
        _pauseTimer();
      }else{
        _header = "pause";
        _startTimer();
      }
    });
  }
  void _reset() {
    setState(() {
      
      _hours = 0;
      _minutes = 0;
      _seconds = 0;

      _timeElapsed = 0; // used to track cycles
      _studyTime = 25 * 60; // 25 min intervals.
      _breakTime = 5 * 60; //  5 min intervals.
      _cycleCount = 0; // amount of times cycled.
      _cycleThresh = 5; // total cycles wanted
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(MediaQuery.of(context).size.width * 0.05), 
        child: AppBar(
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
          title: Row(
            children: [
              // Left-aligned
              Expanded(
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "${_cycleCount}/${_cycleThresh}",
                    style: TextStyle(
                      fontSize: MediaQuery.of(context).size.height * 0.05,
                    ),
                  ),
                ),
              ),

              // Centered
              Expanded(
                child: Center(
                  child: TextButton(
                    onPressed: _pauseFlip,
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: Size(0, 0),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: Text(
                      _header,
                      style: TextStyle(
                        fontSize: MediaQuery.of(context).size.height * 0.05,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),

              Expanded(
                child: Center(
                  child: TextButton(
                    onPressed: _reset,
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: Size(0, 0),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: Text(
                      "reset",
                      style: TextStyle(
                        fontSize: MediaQuery.of(context).size.height * 0.05,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            
              // settings page 
              Expanded(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    '${minConvert(_studyTime - _timeElapsed)}',
                    style: TextStyle (
                      fontSize: MediaQuery.of(context).size.height * 0.05,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            // +increment row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                TextButton(
                  child: Text(
                    "+",
                    style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width * 0.02,
                      color: Colors.grey,
                    ),
                  ),
                  onPressed: _incrementHours,
                ),
                TextButton(
                  child: Text(
                    "+",
                    style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width * 0.02,
                      color: Colors.grey,
                    ),
                  ),
                  onPressed: _incrementMinutes,
                ),
                TextButton(
                  child: Text(
                    "+",
                    style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width * 0.02,
                      color: Colors.grey,
                    ),
                  ),
                  onPressed: _incrementSeconds,
                ),
              ],
            ),
            
            // Enhanced time display with swipe and tap functionality
            TimeDisplay(
              hours: _hours,
              minutes: _minutes,
              seconds: _seconds,
              fontSize: MediaQuery.of(context).size.width * 0.13,
              onHoursIncrement: _incrementHours,
              onHoursDecrement: _decrementHours,
              onMinutesIncrement: _incrementMinutes,
              onMinutesDecrement: _decrementMinutes,
              onSecondsIncrement: _incrementSeconds,
              onSecondsDecrement: _decrementSeconds,
              onHoursTap: _onHoursTap,
              onMinutesTap: _onMinutesTap,
              onSecondsTap: _onSecondsTap,
            ),
            
            // -decrement row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                TextButton(
                  child: Text(
                    "-",
                    style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width * 0.02,
                      color: Colors.grey,
                    ),
                  ),
                  onPressed: _decrementHours,
                ),
                TextButton(
                  child: Text(
                    "-",
                    style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width * 0.02,
                      color: Colors.grey,
                    ),
                  ),
                  onPressed: _decrementMinutes,
                ),
                TextButton(
                  child: Text(
                    "-",
                    style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width * 0.02,
                      color: Colors.grey,
                    ),
                  ),
                  onPressed: _decrementSeconds,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
