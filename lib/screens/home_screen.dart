import 'dart:io';

import 'package:audio_doc/services/file_service.dart';
import 'package:audio_doc/widgets/control_panel_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  File? doc;
  String? title;

  bool isPlaying = false;

  int currentPage = 0, totalPageCount = 0;
  PDFViewController? _pdfViewController;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        dividerTheme: DividerThemeData(color: Colors.transparent),
      ),
      child: Scaffold(
        appBar: AppBar(
          title: Text(doc != null ? (title ?? "") : "Audio Doc"),
        ),
        body: doc == null
            ? Center(
                child: TextButton.icon(
                  onPressed: () {
                    FileService.pickPdfFile().then((value) {
                      if (value != null) {
                        setState(() {
                          doc = value;
                          title = value.path.split("/").last;
                        });
                      }
                    });
                  },
                  icon: Icon(Icons.add_rounded),
                  label: Text("Select document"),
                ),
              )
            : PDFView(
                filePath: doc!.path,
                swipeHorizontal: true,
                pageFling: false,
                backgroundColor: Color(0xFF152b51),
                onRender: (pages) {
                  setState(() {
                    totalPageCount = pages ?? 0;
                  });
                },
                onError: (error) {
                  debugPrint(error.toString());
                },
                onPageError: (page, error) {
                  debugPrint('$page: ${error.toString()}');
                },
                onViewCreated: (pdfViewController) {
                  setState(() {
                    _pdfViewController = pdfViewController;
                  });
                },
                onPageChanged: (page, total) {
                  setState(() {
                    currentPage = page ?? 1;
                  });
                },
              ),
        persistentFooterButtons: [
          Visibility(
            visible: doc != null,
            child: ControlPanelWidget(
              isPlaying: isPlaying,
              onPlayPausePressed: () {
                setState(() {
                  isPlaying = !isPlaying;
                });
              },
              onNextPagePressed: () {
                if (currentPage == totalPageCount) return;

                _pdfViewController?.setPage(currentPage + 1);
              },
              onPreviousPagePressed: () {
                if (currentPage == 0) return;

                _pdfViewController?.setPage(currentPage - 1);
              },
              onClosePressed: () {
                setState(() {
                  isPlaying = false;
                  doc = null;
                });
              },
              currentPage: currentPage + 1,
              totalPageCount: totalPageCount,
            ),
          ),
        ],
      ),
    );
  }
}
