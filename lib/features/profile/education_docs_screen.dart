import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../core/theme/app_theme.dart';
import 'profile_provider.dart';

class EducationDocsScreen extends ConsumerWidget {
  const EducationDocsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final docsAsync = ref.watch(educationDocumentsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Education Documents'),
      ),
      body: docsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => const Center(child: Text('Error loading documents')),
        data: (docs) => docs.isEmpty
            ? const Center(child: Text('No documents found'))
            : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: docs.length,
                itemBuilder: (context, index) {
                  final doc = docs[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: const BorderSide(color: AppTheme.outline, width: 0.5),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      leading: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFEF2F2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(Icons.picture_as_pdf, color: Color(0xFFEF4444), size: 24),
                      ),
                      title: Text(
                        doc.name,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 4),
                          Text('Level: ${doc.educationLevel}', style: const TextStyle(fontSize: 12)),
                          Text(
                            'Uploaded: ${DateFormat('dd MMM yyyy').format(doc.uploadDate)}',
                            style: const TextStyle(fontSize: 11, color: AppTheme.textMuted),
                          ),
                        ],
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.download, color: AppTheme.primaryBlue),
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Download started...')),
                          );
                        },
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
