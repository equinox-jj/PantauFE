import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:image_picker/image_picker.dart';
import 'package:latlong2/latlong.dart';

import '../../../../../core/components/button/button.dart';
import '../../../../../core/components/textfield/textfield.dart';
import '../../../../../core/di/core_di.dart';
import '../../../../../core/service/service.dart';
import '../../../../../core/theme/theme.dart';
import 'listener/listener.dart';
import 'provider/provider.dart';
import 'widgets/widgets.dart';

/// Photo slot state: the picked file and the validation message for it.
typedef _PhotoField = ({String? path, String? error});

/// Category slot state: the chosen id and the validation message for it.
typedef _CategoryField = ({int? id, String? error});

/// Compose flow: photo → pin → category → description → submit.
///
/// Form state is local to the page (matching the login/register pages); the
/// notifier owns only the two-call submit sequence. Each field is a
/// [ValueNotifier] rather than `setState` state, so picking a photo or
/// dragging the pin repaints that one row instead of the whole form.
class CreateReportPage extends ConsumerStatefulWidget {
  const CreateReportPage({super.key});

  @override
  ConsumerState<CreateReportPage> createState() => _CreateReportPageState();
}

class _CreateReportPageState extends ConsumerState<CreateReportPage> {
  /// Jakarta — fallback pin when the device position is unavailable.
  static const _fallbackCenter = LatLng(-6.2088, 106.8456);
  static const _maxDescriptionLength = 500;

  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();
  final MapController _mapController = MapController();
  final ImagePicker _imagePicker = ImagePicker();

  final _photo = ValueNotifier<_PhotoField>((path: null, error: null));
  final _category = ValueNotifier<_CategoryField>((id: null, error: null));
  final _pin = ValueNotifier<LatLng>(_fallbackCenter);
  final _isLocating = ValueNotifier<bool>(false);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _useMyLocation());
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    _mapController.dispose();
    _photo.dispose();
    _category.dispose();
    _pin.dispose();
    _isLocating.dispose();
    super.dispose();
  }

  Future<void> _useMyLocation() async {
    _isLocating.value = true;

    final result = await ref.read(locationServiceProvider).getCurrentLocation();

    if (!mounted) return;

    _isLocating.value = false;

    if (result case LocationSuccess(:final latitude, :final longitude)) {
      final center = LatLng(latitude, longitude);
      _pin.value = center;
      _mapController.move(center, 16);

      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Could not read your location. Drag the map to place the pin.',
        ),
      ),
    );
  }

  Future<void> _pickPhoto() async {
    final source = await PhotoSourceSheet.show(context);
    if (source == null) return;

    // image_picker re-encodes and orientation-corrects while picking, which
    // covers the on-device compression requirement without a new package.
    final file = await _imagePicker.pickImage(
      source: source,
      imageQuality: 70,
      maxWidth: 1600,
      maxHeight: 1600,
    );
    if (file == null || !mounted) return;

    _photo.value = (path: file.path, error: null);
  }

  Future<void> _submit() async {
    final photoPath = _photo.value.path;
    final categoryId = _category.value.id;

    _photo.value = (
      path: photoPath,
      error: photoPath == null ? 'A photo is required' : null,
    );
    _category.value = (
      id: categoryId,
      error: categoryId == null ? 'Pick a category' : null,
    );

    final isFormValid = _formKey.currentState?.validate() ?? false;
    if (!isFormValid || photoPath == null || categoryId == null) return;

    await ref
        .read(createReportProvider.notifier)
        .submit(
          photoPath: photoPath,
          categoryId: categoryId,
          description: _descriptionController.text.trim(),
          latitude: _pin.value.latitude,
          longitude: _pin.value.longitude,
        );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      // Submitting streams the photo to the server; leaving mid-flight via
      // the back gesture/button would abandon the flow silently while the
      // request keeps running. Only the gate rebuilds — the form below is
      // handed through as a prebuilt child.
      builder: (context, ref, child) => PopScope(
        canPop: !ref.watch(
          createReportProvider.select((state) => state.isLoading),
        ),
        child: child!,
      ),
      child: Scaffold(
        appBar: AppBar(title: const Text('New report')),
        body: SafeArea(
          child: CreateReportListener(
            child: Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.xl,
                  vertical: AppSpacing.lg,
                ),
                children: [
                  _PhotoSection(field: _photo, onPick: _pickPhoto),
                  const Gap(AppSpacing.lg),
                  ReportLocationPicker(
                    controller: _mapController,
                    initialCenter: _fallbackCenter,
                    center: _pin,
                    isLocating: _isLocating,
                    onMoved: (center) => _pin.value = center,
                    onUseMyLocation: _useMyLocation,
                  ),
                  const Gap(AppSpacing.lg),
                  _CategorySection(field: _category),
                  const Gap(AppSpacing.lg),
                  _DescriptionField(
                    controller: _descriptionController,
                    maxLength: _maxDescriptionLength,
                  ),
                  const Gap(AppSpacing.lg),
                  _SubmitSection(onSubmit: _submit),
                  const Gap(AppSpacing.lg),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Photo row: rebuilds on a pick, a validation message, or the submit lock.
class _PhotoSection extends StatelessWidget {
  const _PhotoSection({required this.field, required this.onPick});

  final ValueListenable<_PhotoField> field;
  final VoidCallback onPick;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<_PhotoField>(
      valueListenable: field,
      builder: (context, photo, _) => Consumer(
        builder: (context, ref, _) {
          final isSubmitting = ref.watch(
            createReportProvider.select((state) => state.isLoading),
          );

          return ReportPhotoPicker(
            photoPath: photo.path,
            onPick: isSubmitting ? null : onPick,
            errorText: photo.error,
          );
        },
      ),
    );
  }
}

/// Category row: rebuilds on a selection or a validation message. The chips
/// themselves subscribe to the taxonomy provider.
class _CategorySection extends StatelessWidget {
  const _CategorySection({required this.field});

  final ValueNotifier<_CategoryField> field;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<_CategoryField>(
      valueListenable: field,
      builder: (context, category, _) => ReportCategorySelector(
        selectedId: category.id,
        errorText: category.error,
        onSelected: (id) => field.value = (id: id, error: null),
      ),
    );
  }
}

/// Description input, disabled for the duration of a submit.
class _DescriptionField extends StatelessWidget {
  const _DescriptionField({required this.controller, required this.maxLength});

  final TextEditingController controller;
  final int maxLength;

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, _) {
        final isSubmitting = ref.watch(
          createReportProvider.select((state) => state.isLoading),
        );

        return AppTextField(
          controller: controller,
          labelText: 'Description (optional)',
          hintText: 'What is wrong, and how bad is it?',
          maxLines: 4,
          minLines: 3,
          maxLength: maxLength,
          counterText: '',
          textCapitalization: TextCapitalization.sentences,
          enabled: !isSubmitting,
        );
      },
    );
  }
}

/// Submit button plus the upload progress caption underneath it.
class _SubmitSection extends StatelessWidget {
  const _SubmitSection({required this.onSubmit});

  final Future<void> Function() onSubmit;

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, _) {
        final isSubmitting = ref.watch(
          createReportProvider.select((state) => state.isLoading),
        );

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppButton(
              text: 'Submit report',
              isLoading: isSubmitting,
              onPressed: isSubmitting ? null : onSubmit,
            ),
            if (isSubmitting) ...[
              const Gap(AppSpacing.xs2),
              Center(
                child: Text(
                  'Uploading photo and submitting report…',
                  style: AppTypography.body,
                ),
              ),
            ],
          ],
        );
      },
    );
  }
}
