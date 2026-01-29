import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import '../services/api_service.dart';
import '../models/discover_model.dart';

class DiscoverMethodDetailScreen extends StatefulWidget {
  final String methodId;
  final String title;

  const DiscoverMethodDetailScreen({
    super.key,
    required this.methodId,
    required this.title,
  });

  @override
  State<DiscoverMethodDetailScreen> createState() => _DiscoverMethodDetailScreenState();
}

class _DiscoverMethodDetailScreenState extends State<DiscoverMethodDetailScreen> {
  final ApiService _apiService = ApiService();
  DiscoverMethodDetailModel? _detail;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadDetail();
  }

  Future<void> _loadDetail() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final detail = await _apiService.getDiscoverMethodDetail(widget.methodId);
      setState(() {
        _detail = detail;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF73C6D9),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          widget.title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(child: Text(_error!))
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: MarkdownBody(
                    data: _detail?.content ?? '',
                    styleSheet: MarkdownStyleSheet(
                      h1: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black87),
                      h2: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
                      h3: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
                      p: TextStyle(fontSize: 16, color: Colors.grey[800], height: 1.5),
                    ),
                  ),
                ),
    );
  }
}
