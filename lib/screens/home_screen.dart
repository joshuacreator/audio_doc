import 'dart:io';

import 'package:audio_doc/services/file_service.dart';
import 'package:audio_doc/widgets/control_panel_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:read_pdf_text/read_pdf_text.dart';
import 'package:flutter_tts/flutter_tts.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  File? doc;
  String? title;
  bool isSpeaking = false;
  bool isLoading = false;
  int currentPage = 0, totalPageCount = 0;
  PDFViewController? _pdfViewController;
  FlutterTts flutterTts = FlutterTts();
  String? extractedText;

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
                  onPressed: () async {
                    await FileService.pickPdfFile().then((value) async {
                      if (value != null) {
                        setState(() {
                          doc = value;
                          title = value.path.split("/").last;
                        });

                        await _extractText();
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
              isPlaying: isSpeaking,
              isLoading: isLoading,
              onPlayPausePressed: () {
                if (isSpeaking) {
                  flutterTts.pause();
                } else {
                  _speak();
                }
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
                flutterTts.stop();
                setState(() {
                  isSpeaking = false;
                  isLoading = false;
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

  Future<void> _extractText() async {
    if (doc != null) {
      try {
        setState(() {
          isLoading = true;
        });
        extractedText = await ReadPdfText.getPDFtext(doc!.path);
        setState(() {
          isLoading = false;
        });
      } catch (e) {
        debugPrint("Error extracting text: $e");
      }
    }
  }

  Future<void> _speak() async {
    if (extractedText != null && extractedText!.isNotEmpty) {
      setState(() {
        isSpeaking = true;
      });
      await flutterTts.setVoice({"name": "en-GB", "locale": "en-GB"});
      await flutterTts.awaitSpeakCompletion(true);
      await flutterTts
          .speak(extractedText ?? "Unable to read text from file")
          .then((value) {
        setState(() {
          isSpeaking = false;
        });
      });
    } else {
      debugPrint("No text to speak or text extraction failed.");
      setState(() {
        isSpeaking = false;
      });
    }
  }
}
