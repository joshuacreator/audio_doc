import 'package:flutter/material.dart';

class ControlPanelWidget extends StatelessWidget {
  const ControlPanelWidget({
    super.key,
    required this.isPlaying,
    required this.onPlayPausePressed,
    required this.onNextPagePressed,
    required this.onPreviousPagePressed,
    required this.onClosePressed,
    required this.currentPage,
    required this.totalPageCount,
  });

  final bool isPlaying;
  final VoidCallback onPlayPausePressed,
      onNextPagePressed,
      onPreviousPagePressed,
      onClosePressed;
  final int currentPage, totalPageCount;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(5.0),
      margin: EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 15.0),
            child: Text(
              "$currentPage/$totalPageCount",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                onPressed: onPreviousPagePressed,
                icon: Icon(Icons.skip_previous_rounded),
              ),
              IconButton.filledTonal(
                onPressed: onPlayPausePressed,
                icon: Icon(
                  isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                ),
                style: IconButton.styleFrom(
                  backgroundColor: Color(0xFF152b51),
                  foregroundColor: Colors.white,
                ),
              ),
              IconButton(
                onPressed: onNextPagePressed,
                icon: Icon(Icons.skip_next_rounded),
              ),
            ],
          ),
          IconButton(
            onPressed: onClosePressed,
            icon: Icon(Icons.cancel),
          ),
        ],
      ),
    );
  }
}
