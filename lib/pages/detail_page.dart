import 'package:flutter/material.dart';
import 'dashboard_page.dart';

class DetailPage extends StatelessWidget {
  final Activity activity;
  final void Function(String id) onDelete;
  final void Function(Activity updated) onEdit;

  const DetailPage({
    super.key,
    required this.activity,
    required this.onDelete,
    required this.onEdit,
  });

  void _edit(BuildContext context) {
    final t = TextEditingController(text: activity.title);
    final l = TextEditingController(text: activity.location);
    final d = TextEditingController(text: activity.description);
    final c = TextEditingController(text: activity.estimatedCost.toInt().toString());
    DateTime chosen = activity.dateTime;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        final theme = Theme.of(ctx);
        final surface = theme.colorScheme.surface;
        return StatefulBuilder(builder: (ctx2, setModal) {
          return Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(ctx).viewInsets.bottom,
              left: 20,
              right: 20,
              top: 16,
            ),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              Container(width: 40, height: 4, decoration: BoxDecoration(color: theme.dividerColor, borderRadius: BorderRadius.circular(2))),
              const SizedBox(height: 12),
              Text('Edit Kegiatan', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700)),
              const SizedBox(height: 14),
              TextField(controller: t, decoration: InputDecoration(labelText: 'Judul', prefixIcon: const Icon(Icons.event))),
              const SizedBox(height: 10),
              TextField(controller: l, decoration: InputDecoration(labelText: 'Lokasi', prefixIcon: const Icon(Icons.location_on))),
              const SizedBox(height: 10),
              TextField(controller: d, minLines: 2, maxLines: 4, decoration: InputDecoration(labelText: 'Deskripsi', prefixIcon: const Icon(Icons.description_outlined))),
              const SizedBox(height: 10),
              TextField(controller: c, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Estimasi biaya (IDR)', prefixText: 'Rp ')),
              const SizedBox(height: 12),
              Row(children: [
                Expanded(
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.calendar_month_outlined),
                    label: Text('${chosen.day.toString().padLeft(2, '0')}/${chosen.month.toString().padLeft(2, '0')}/${chosen.year}'),
                    onPressed: () async {
                      final picked = await showDatePicker(
                        context: ctx,
                        initialDate: chosen,
                        firstDate: DateTime.now().subtract(const Duration(days: 365)),
                        lastDate: DateTime.now().add(const Duration(days: 3650)),
                      );
                      if (picked != null) setModal(() => chosen = DateTime(picked.year, picked.month, picked.day, chosen.hour, chosen.minute));
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.access_time_outlined),
                    label: Text('${chosen.hour.toString().padLeft(2, '0')}:${chosen.minute.toString().padLeft(2, '0')}'),
                    onPressed: () async {
                      final picked = await showTimePicker(context: ctx, initialTime: TimeOfDay.fromDateTime(chosen));
                      if (picked != null) setModal(() => chosen = DateTime(chosen.year, chosen.month, chosen.day, picked.hour, picked.minute));
                    },
                  ),
                ),
              ]),
              const SizedBox(height: 14),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    final title = t.text.trim();
                    if (title.isEmpty) return;
                    final cost = double.tryParse(c.text.replaceAll('.', '').replaceAll(',', '')) ?? 0.0;
                    onEdit(Activity(
                      id: activity.id,
                      title: title,
                      dateTime: chosen,
                      location: l.text.trim(),
                      description: d.text.trim(),
                      estimatedCost: cost,
                    ));
                    Navigator.pop(ctx);
                  },
                  child: const Text('Simpan Perubahan'),
                ),
              ),
              const SizedBox(height: 12),
            ]),
          );
        });
      },
    );
  }

  String _fmt(double v) => v.toInt().toString().replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+\b)'), (m) => '${m[1]}.');

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Hapus kegiatan?'),
        content: const Text('Kegiatan akan dihapus permanen.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Batal')),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              onDelete(activity.id);
            },
            child: const Text('Hapus', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    const primary = Color(0xFF0A6B67);

    return Scaffold(
      body: SafeArea(
        child: Row(
          children: [
            Container(
              width: 88,
              margin: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: primary, borderRadius: BorderRadius.circular(32)),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 18),
                    child: IconButton(icon: const Icon(Icons.arrow_back, color: Colors.white, size: 28), onPressed: () => Navigator.pop(context)),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.travel_explore, color: Colors.white, size: 28),
                        const SizedBox(height: 12),
                        RotatedBox(quarterTurns: -1, child: Text('TripPlan', style: const TextStyle(color: Colors.white, fontFamily: 'Poppins', fontSize: 18, fontWeight: FontWeight.w700))),
                      ],
                    ),
                  ),
                  const SizedBox(height: 66),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  SizedBox(
                    width: double.infinity,
                    child: Text(activity.title, textAlign: TextAlign.center, style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700)),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: theme.cardColor,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.12), blurRadius: 8, offset: const Offset(0, 4))],
                    ),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text('Estimasi Biaya', style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700)),
                      const SizedBox(height: 8),
                      Text('Rp ${_fmt(activity.estimatedCost)}', style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800, color: primary)),
                    ]),
                  ),
                  const SizedBox(height: 18),
                  Text('Waktu', style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700)),
                  const SizedBox(height: 6),
                  Text('${activity.dateTime.day.toString().padLeft(2, '0')}/${activity.dateTime.month.toString().padLeft(2, '0')}  ${activity.dateTime.hour.toString().padLeft(2, '0')}:${activity.dateTime.minute.toString().padLeft(2, '0')}'),
                  const SizedBox(height: 12),
                  Text('Lokasi', style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700)),
                  const SizedBox(height: 6),
                  Text(activity.location),
                  const SizedBox(height: 12),
                  Text('Deskripsi', style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700)),
                  const SizedBox(height: 6),
                  Text(activity.description.isEmpty ? 'Tidak ada deskripsi.' : activity.description),
                  const SizedBox(height: 12),
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: Row(children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          icon: const Icon(Icons.edit_outlined),
                          label: const Text('Edit'),
                          onPressed: () => _edit(context),
                          style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 14)),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton.icon(
                          icon: const Icon(Icons.delete_outline),
                          label: const Text('Hapus'),
                          onPressed: () => _confirmDelete(context),
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.red.shade700, padding: const EdgeInsets.symmetric(vertical: 14)),
                        ),
                      ),
                    ]),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      icon: const Icon(Icons.notifications_active_outlined),
                      label: const Text('Tambah Pengingat'),
                      onPressed: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Pengingat ditambahkan (demo)'))),
                      style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                    ),
                  ),
                  const SizedBox(height: 8),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
