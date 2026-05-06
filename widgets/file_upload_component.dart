import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:ipf_flutter_starter_pack/ipf_flutter_starter_pack.dart';
import 'package:solomon/shared/widgets/app_button.dart';
import 'package:solomon/shared/widgets/dotted_container.dart';
import 'package:solomon/services/strings.dart';

class FileUploadComponent extends StatefulWidget {
  const FileUploadComponent({
    super.key,
    this.onFileSelected,
    this.label,
    this.uploadTitle,
    this.instruction,
    this.requiredMessage,
    this.maxFileSizeBytes = 5 * 1024 * 1024, // 5MB
    this.assetPath,
    this.child,
  });

  final ValueChanged<PlatformFile?>? onFileSelected;
  final String? label;
  final String? uploadTitle;
  final String? instruction;
  final String? requiredMessage;
  final String? assetPath;
  final int maxFileSizeBytes;
  final Widget? child;

  @override
  State<FileUploadComponent> createState() => FileUploadComponentState();
}

class FileUploadComponentState extends State<FileUploadComponent> {
  PlatformFile? _selectedFile;
  String? _validationMessage;

  // Returns the selected local file path when available.
  String? get selectedFilePath => _selectedFile?.path;

  bool validateSelection() {
    if (_selectedFile != null) {
      return true;
    }
    setState(() {
      _validationMessage = widget.requiredMessage;
    });
    return false;
  }

  Future<void> _pickFile() async {
    List<String>? allowedExtensions = ['pdf', 'jpg', 'jpeg', 'png'];
    final FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: allowedExtensions,
      withData: false,
    );

    if (!mounted || result == null || result.files.isEmpty) {
      return;
    }

    final PlatformFile file = result.files.first;
    final String extension = (file.extension ?? '').toLowerCase();
    const List<String> allowed = ['pdf', 'jpg', 'jpeg', 'png'];

    if (!allowed.contains(extension)) {
      setState(() {
        _validationMessage = Strings.instance.onlyPdfJpgPngAllowed;
      });
      return;
    }

    if (file.size > widget.maxFileSizeBytes) {
      setState(() {
        _validationMessage = Strings.instance.fileSizeMustBeOrLess(_formatFileSize(widget.maxFileSizeBytes));
      });
      return;
    }

    setState(() {
      _selectedFile = file;
      _validationMessage = null;
    });
    widget.onFileSelected?.call(file);
  }

  String _formatFileSize(int sizeInBytes) {
    if (sizeInBytes < 1024) {
      return '$sizeInBytes B';
    }
    final double sizeInKb = sizeInBytes / 1024;
    if (sizeInKb < 1024) {
      return '${sizeInKb.toStringAsFixed(1)} KB';
    }
    final double sizeInMb = sizeInKb / 1024;
    return '${sizeInMb.toStringAsFixed(1)} MB';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.label ?? '', style: context.bodyMedium.copyWith(color: context.colorScheme.onSurface)),
        const Gap(8),
        InkWell(
          onTap: _pickFile,
          child: Builder(
            builder: (context) {
              if (widget.child != null) {
                return widget.child!;
              }

              return DottedContainer(
                borderColor: _validationMessage == null ? null : context.colorScheme.error,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: context.colorScheme.surface,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ClipOval(
                        child: Container(
                          color: context.colorScheme.inversePrimary,
                          padding: const EdgeInsets.all(16),
                          child: HugeIcon(icon: HugeIcons.strokeRoundedCloudUpload, color: context.colorScheme.primary, size: 32),
                        ),
                      ),
                      const Gap(8),
                      Text(
                        widget.uploadTitle ?? Strings.instance.uploadFile,
                        textAlign: TextAlign.center,
                        style: context.titleMedium.copyWith(color: context.colorScheme.onSurface).semiBold,
                      ),
                      const Gap(8),
                      Text(
                        _selectedFile == null ? widget.instruction ?? "" : '${_selectedFile!.name} (${_formatFileSize(_selectedFile!.size)})',
                        textAlign: TextAlign.center,
                        style: context.bodyMedium.copyWith(
                          color: _validationMessage == null ? context.colorScheme.onSurface.withAlpha(150) : context.colorScheme.error,
                        ),
                      ),
                      if (_validationMessage != null) ...[
                        const Gap(6),
                        Text(
                          _validationMessage!,
                          style: context.bodySmall.copyWith(color: context.colorScheme.error),
                          textAlign: TextAlign.center,
                        ),
                      ],
                      const Gap(16),
                      AppButton.outline(
                        onPressed: _pickFile,
                        title: Strings.instance.browseFiles,
                        borderColor: context.colorScheme.outlineVariant,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
