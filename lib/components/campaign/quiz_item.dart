import 'package:flutter/material.dart';
import 'package:quizzy/components/campaign/campaign_quiz.dart';
import 'package:quizzy/configs/variables.dart';
import 'dart:async';

import 'package:quizzy/models/campaign_quiz.dart';

class CampaignQuizItem extends StatefulWidget {
  final String title;
  final bool isAttempted;
  final int? points;
  final DateTime startTime;
  final DateTime endTime;
  final CampaignModel quiz;

  const CampaignQuizItem(
      {super.key,
      required this.title,
      required this.isAttempted,
      this.points,
      required this.startTime,
      required this.endTime,
      required this.quiz});

  @override
  State<CampaignQuizItem> createState() => _CampaignQuizItemState();
}

class _CampaignQuizItemState extends State<CampaignQuizItem> {
  late Timer _timer;
  Duration _remainingDuration = Duration.zero;
  late bool isRunning;
  late bool isClosed;
  late bool isUpcoming;
  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  bool _isStartTime = true;
  void _startTimer() {
    DateTime now = DateTime.now();
    if (now.isBefore(widget.startTime)) {
      _remainingDuration = widget.startTime.difference(now);
      _isStartTime = true;
    } else if (now.isBefore(widget.endTime)) {
      _remainingDuration = widget.endTime.difference(now);
      _isStartTime = false;
    } else {
      _remainingDuration = Duration.zero;
      _isStartTime = false;
    }

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        DateTime now = DateTime.now();
        if (_isStartTime) {
          if (now.isBefore(widget.startTime)) {
            _remainingDuration = widget.startTime.difference(now);
          } else {
            _remainingDuration = widget.endTime.difference(now);
            _isStartTime = false;
          }
        } else {
          if (now.isBefore(widget.endTime)) {
            _remainingDuration = widget.endTime.difference(now);
          } else {
            _remainingDuration = Duration.zero;
            _timer.cancel();
          }
        }
      });
    });
  }

  String _formatDuration(Duration duration) {
    String hours = duration.inHours.toString().padLeft(2, '0');
    String minutes = (duration.inMinutes % 60).toString().padLeft(2, '0');
    String seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
    return '$hours:$minutes:$seconds';
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    DateTime currentDate = DateTime.now();
    bool isUpcoming = widget.startTime.isAfter(currentDate) == true;
    isClosed = widget.endTime.isBefore(currentDate) == true;
    bool isRunning = widget.startTime.isBefore(currentDate) == true &&
        widget.endTime.isAfter(currentDate) == true;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Variables.primaryColor,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.title,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (widget.isAttempted)
                Row(
                  children: [
                    Icon(
                      widget.isAttempted ? Icons.check_circle : Icons.cancel,
                      color: Colors.green,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      'Points: ${widget.points ?? 0}',
                      style: const TextStyle(
                        color: Colors.blue,
                      ),
                    ),
                  ],
                )
              else if (isUpcoming || isRunning)
                Row(
                  children: [
                    Icon(Icons.timer,
                        color: isRunning ? Colors.red : Colors.white),
                    const SizedBox(width: 5),
                    Text(
                      'Time ${isRunning ? "Left" : "Start"}: ${_formatDuration(_remainingDuration)}',
                      style: TextStyle(
                          color: isRunning ? Colors.red : Colors.white),
                    ),
                  ],
                )
            ],
          ),
          const SizedBox(height: 10),
          if (widget.isAttempted)
            const Text(
              'Attempted',
              style: TextStyle(
                color: Colors.orange,
              ),
            )
          else
            Row(
              children: [
                const Text(
                  'Not Attempted',
                  style: TextStyle(
                    color: Colors.orange,
                  ),
                ),
                const Spacer(),
                if (isRunning)
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                CampaignQuiz(quiz: widget.quiz)),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 20),
                    ),
                    child: const Text(
                      'Attempt',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                if (isUpcoming)
                  const Text(
                    'Upcoming',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                if (isClosed)
                  const Text(
                    'Closed',
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  )
              ],
            )
        ],
      ),
    );
  }
}
