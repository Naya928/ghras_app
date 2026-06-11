import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:io';
import '../../core/constants/app_colors.dart';
import '../../providers/reading_provider.dart';
import 'package:path_provider/path_provider.dart';

class ReadingScreen extends ConsumerStatefulWidget {
  const ReadingScreen({super.key});

  @override
  ConsumerState<ReadingScreen> createState() => _ReadingScreenState();
}

class _ReadingScreenState extends ConsumerState<ReadingScreen> {
  String? _localPath;
  int _currentPage = 0;
  int _totalPages = 0;
  bool _isLoading = true;
  PDFViewController? _pdfController;

  @override
  void initState() {
    super.initState();
    _loadPDF();
  }

  // نسخ الـ PDF من assets للذاكرة المؤقتة
  Future<void> _loadPDF() async {
  final dir = await getApplicationDocumentsDirectory();
  final file = File('${dir.path}/book.pdf');
  
  final exists = await file.exists();
  debugPrint('PDF exists: $exists');
  debugPrint('PDF path: ${file.path}');

  if (!exists) {
    debugPrint('Copying PDF...');
    final bytes = await rootBundle.load('assets/book/book.pdf');
    await file.writeAsBytes(bytes.buffer.asUint8List(), flush: true);
    debugPrint('Copy done');
  }

  if (mounted) {
    setState(() {
      _localPath = file.path;
      _isLoading = false;
    });
  }
}

  // عند تغيير الصفحة
void _onPageChanged(int? page, int? total) {
  if (page == null || total == null) return;

    // تحديث التقدم في الـ Provider
    ref.read(readingProvider.notifier).updatePages(page);

    // تحقق لو اكتسب قطعة جديدة
    _checkNewPiece(page);
  }

  void _checkNewPiece(int page) {
    final progress = ref.read(readingProvider);
    final prevPieces = (page - 1) ~/ 15;
    final currentPieces = page ~/ 15;

    if (currentPieces > prevPieces && currentPieces > 0) {
      _showNewPieceDialog();
    }
  }

  void _showNewPieceDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.background,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('✨', style: TextStyle(fontSize: 48)),
            const SizedBox(height: 12),
            const Text(
              'أحسنت!',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColors.textMain,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'اكتسبت قطعة جديدة في لوحتك',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.textMuted),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: const Text(
                'متابعة',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final progress = ref.watch(readingProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: const Text(
          'وردك اليومي',
          style: TextStyle(
            color: AppColors.textMain,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.textMain),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          // شريط التقدم
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            child: Row(
              children: [
                Text(
                  'صفحة $_currentPage من $_totalPages',
                  style: const TextStyle(
                    color: AppColors.textMuted,
                    fontSize: 13,
                  ),
                ),
                const Spacer(),
                Text(
                  '${progress.earnedPieces} / 20 قطعة',
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),

          // شريط تقدم بصري
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: LinearProgressIndicator(
              value: _totalPages > 0 ? _currentPage / _totalPages : 0,
              backgroundColor: AppColors.primary.withOpacity(0.2),
              valueColor:
                  const AlwaysStoppedAnimation<Color>(AppColors.primary),
              borderRadius: BorderRadius.circular(10),
              minHeight: 6,
            ),
          ),

          const SizedBox(height: 8),

          // عارض الـ PDF
          Expanded(
            child: _isLoading
                ? const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.primary,
                    ),
                  )
                : PDFView(
                    filePath: _localPath!,
                    enableSwipe: true,
                    swipeHorizontal: false,
                    autoSpacing: true,
                    pageFling: true,
                    onPageChanged: _onPageChanged,
                    onViewCreated: (controller) {
                      _pdfController = controller;
                    },
                    onError: (error) {
                      debugPrint('PDF Error: $error');
                    },
                  ),
          ),
        ],
      ),
    );
  }
}