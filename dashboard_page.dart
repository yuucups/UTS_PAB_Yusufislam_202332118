// lib/pages/dashboard_page.dart
import 'package:flutter/material.dart';
import 'login_page.dart';
import 'detail_page.dart';

class Activity {
  final String id;
  final String title;
  final DateTime dateTime;
  final String location;
  final String description;
  double estimatedCost;

  Activity({
    required this.id,
    required this.title,
    required this.dateTime,
    required this.location,
    required this.description,
    required this.estimatedCost,
  });
}

class DashboardPage extends StatefulWidget {
  final VoidCallback? onToggleTheme;
  const DashboardPage({super.key, this.onToggleTheme});
  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final List<Activity> _activities = [
    Activity(
      id: 'a1',
      title: 'Explore Ubud',
      dateTime: DateTime.now().add(const Duration(days: 1, hours: 9)),
      location: 'Ubud, Bali',
      description: 'Jalan sawah & pasar lokal',
      estimatedCost: 350000,
    ),
    Activity(
      id: 'a2',
      title: 'Snorkeling Nusa Penida',
      dateTime: DateTime.now().add(const Duration(days: 2, hours: 7)),
      location: 'Nusa Penida',
      description: 'Paket snorkeling',
      estimatedCost: 500000,
    ),
    Activity(
      id: 'a3',
      title: 'Check-in Hotel',
      dateTime: DateTime.now().add(const Duration(days: 3, hours: 15)),
      location: 'Kuta',
      description: 'Check-in & istirahat',
      estimatedCost: 200000,
    ),
  ];

  double totalBudget = 2000000;

  double get spent =>
      _activities.fold<double>(0.0, (s, a) => s + a.estimatedCost);
  double get remaining => (totalBudget - spent).clamp(0, double.infinity);

  String _fmt(double v) {
    final i = v.toInt();
    final s = i.toString();
    return s.replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+$)'), (m) => '${m[1]}.');
  }

  String _formatDate(DateTime dt) =>
      '${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}';
  String _formatTime(DateTime dt) =>
      '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';

  void _logout() => Navigator.pushReplacement(
      context, MaterialPageRoute(builder: (_) => const LoginPage()));

  void _showBudgetEditor() {
    final ctrl = TextEditingController();
    var isAdd = true;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) {
        final theme = Theme.of(ctx);
        return StatefulBuilder(builder: (ctx2, setModalState) {
          return Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(ctx2).viewInsets.bottom,
                left: 20,
                right: 20,
                top: 20),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              Container(
                  height: 4,
                  width: 48,
                  decoration: BoxDecoration(
                      color: theme.dividerColor,
                      borderRadius: BorderRadius.circular(2))),
              const SizedBox(height: 12),
              Text('Ubah Budget',
                  style: theme.textTheme.titleLarge
                      ?.copyWith(fontWeight: FontWeight.w700)),
              const SizedBox(height: 12),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                ChoiceChip(
                    label: const Text('Tambah'),
                    selected: isAdd,
                    onSelected: (_) => setModalState(() => isAdd = true)),
                const SizedBox(width: 8),
                ChoiceChip(
                    label: const Text('Kurangi'),
                    selected: !isAdd,
                    onSelected: (_) => setModalState(() => isAdd = false)),
              ]),
              const SizedBox(height: 12),
              TextField(
                controller: ctrl,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                    labelText: 'Jumlah (contoh: 150000)',
                    prefixText: 'Rp ',
                    border: OutlineInputBorder()),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    final raw =
                        ctrl.text.replaceAll('.', '').replaceAll(',', '');
                    final val = double.tryParse(raw) ?? 0.0;
                    setState(() {
                      totalBudget = isAdd
                          ? totalBudget + val
                          : (totalBudget - val).clamp(0, double.infinity);
                    });
                    Navigator.pop(ctx2);
                  },
                  child: Text(isAdd ? 'Tambah' : 'Kurangi'),
                ),
              ),
              const SizedBox(height: 12),
            ]),
          );
        });
      },
    );
  }

  // === fungsi tambah destinasi (dengan Deskripsi) ===
  void _showAddActivity({Color? primary}) {
    final titleCtrl = TextEditingController();
    final locCtrl = TextEditingController();
    final descCtrl = TextEditingController(); // field deskripsi baru
    final costCtrl = TextEditingController();
    DateTime chosen = DateTime.now().add(const Duration(hours: 1));

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) {
        final theme = Theme.of(ctx);
        final surface = theme.colorScheme.surface;
        return StatefulBuilder(builder: (ctx2, setModalState) {
          return Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(ctx).viewInsets.bottom,
                left: 20,
                right: 20,
                top: 20),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              Container(
                  height: 4,
                  width: 48,
                  decoration: BoxDecoration(
                      color: theme.dividerColor,
                      borderRadius: BorderRadius.circular(2))),
              const SizedBox(height: 12),
              Text('Tambah Destinasi',
                  style: theme.textTheme.titleLarge
                      ?.copyWith(fontWeight: FontWeight.w700)),
              const SizedBox(height: 12),
              TextField(
                controller: titleCtrl,
                decoration: InputDecoration(
                  labelText: 'Judul destinasi',
                  prefixIcon: const Icon(Icons.place),
                  filled: true,
                  fillColor: surface,
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: locCtrl,
                decoration: InputDecoration(
                  labelText: 'Lokasi',
                  prefixIcon: const Icon(Icons.location_city),
                  filled: true,
                  fillColor: surface,
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: descCtrl,
                minLines: 2,
                maxLines: 4,
                decoration: InputDecoration(
                  labelText: 'Deskripsi (opsional)',
                  prefixIcon: const Icon(Icons.description_outlined),
                  filled: true,
                  fillColor: surface,
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: costCtrl,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Estimasi biaya',
                  prefixText: 'Rp ',
                  prefixIcon: const Icon(Icons.account_balance_wallet_outlined),
                  filled: true,
                  fillColor: surface,
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              Row(children: [
                Expanded(
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.calendar_month_outlined),
                    label: Text(
                        '${chosen.day.toString().padLeft(2, '0')}/${chosen.month.toString().padLeft(2, '0')}/${chosen.year}'),
                    onPressed: () async {
                      final picked = await showDatePicker(
                          context: ctx,
                          initialDate: chosen,
                          firstDate:
                              DateTime.now().subtract(const Duration(days: 365)),
                          lastDate:
                              DateTime.now().add(const Duration(days: 3650)));
                      if (picked != null)
                        setModalState(() => chosen = DateTime(
                            picked.year,
                            picked.month,
                            picked.day,
                            chosen.hour,
                            chosen.minute));
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.access_time_outlined),
                    label: Text(_formatTime(chosen)),
                    onPressed: () async {
                      final picked = await showTimePicker(
                          context: ctx,
                          initialTime: TimeOfDay.fromDateTime(chosen));
                      if (picked != null)
                        setModalState(() => chosen = DateTime(
                            chosen.year,
                            chosen.month,
                            chosen.day,
                            picked.hour,
                            picked.minute));
                    },
                  ),
                ),
              ]),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.add_location),
                  label: const Text('Tambah Destinasi'),
                  style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14)),
                  onPressed: () {
                    final title = titleCtrl.text.trim();
                    if (title.isEmpty) return;
                    final cost =
                        double.tryParse(costCtrl.text.replaceAll('.', '').replaceAll(',', '')) ??
                            0.0;
                    setState(() {
                      _activities.add(Activity(
                        id: DateTime.now().millisecondsSinceEpoch.toString(),
                        title: title,
                        dateTime: chosen,
                        location: locCtrl.text.trim(),
                        description: descCtrl.text.trim(),
                        estimatedCost: cost,
                      ));
                    });
                    Navigator.pop(ctx);
                  },
                ),
              ),
              const SizedBox(height: 12),
            ]),
          );
        });
      },
    );
  }

  Widget _cardTop(BuildContext context, Color primary) {
    final theme = Theme.of(context);
    final progress =
        totalBudget == 0 ? 0.0 : (spent / totalBudget).clamp(0.0, 1.0);

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
          color: theme.colorScheme.primary
              .withOpacity(theme.brightness == Brightness.dark ? 0.12 : 0.08),
          borderRadius: BorderRadius.circular(14)),
      padding: const EdgeInsets.all(18),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('Budget perjalanan',
            style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700)),
        const SizedBox(height: 8),
        Text('Rp ${_fmt(totalBudget)}',
            style: theme.textTheme.headlineSmall
                ?.copyWith(fontWeight: FontWeight.w800, color: primary)),
        const SizedBox(height: 12),
        ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
                value: progress,
                color: primary,
                backgroundColor: theme.dividerColor,
                minHeight: 10)),
        const SizedBox(height: 8),
        Text('Terpakai: Rp ${_fmt(spent)}  •  Sisa: Rp ${_fmt(remaining)}',
            style: theme.textTheme.bodySmall),
        const SizedBox(height: 14),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () => _showBudgetEditor(),
            icon: const Icon(Icons.swap_vert),
            label: const Text('Ubah Budget'),
            style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12)),
          ),
        ),
      ]),
    );
  }

  Widget _destinationCard(Activity a) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => DetailPage(
                  activity: a,
                  onDelete: (id) {
                    setState(() => _activities.removeWhere((x) => x.id == id));
                    Navigator.pop(context);
                  },
                  onEdit: (updated) {
                    final idx =
                        _activities.indexWhere((x) => x.id == updated.id);
                    if (idx != -1) setState(() => _activities[idx] = updated);
                    Navigator.pop(context);
                  }))),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 14),
        decoration: BoxDecoration(
            color: theme.cardColor,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                  color: theme.brightness == Brightness.dark
                      ? Colors.black54
                      : Colors.black12,
                  blurRadius: 6,
                  offset: const Offset(0, 2))
            ]),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              margin: const EdgeInsets.only(right: 12),
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withOpacity(0.14),
                  borderRadius: BorderRadius.circular(10)),
              child: Icon(Icons.place,
                  color: theme.colorScheme.primary, size: 22),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(a.title,
                      style: theme.textTheme.titleLarge
                          ?.copyWith(fontSize: 18, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 6),
                  Text('${a.location} • ${_formatDate(a.dateTime)}',
                      style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.textTheme.bodySmall?.color,
                          fontSize: 13)),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(left: 12),
              child: Text('Rp ${_fmt(a.estimatedCost)}',
                  style: const TextStyle(
                      color: Colors.deepOrange,
                      fontWeight: FontWeight.w800,
                      fontSize: 14)),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Row(
          children: [
            // === SIDEBAR (PERBAIKAN WARNA) ===
            Container(
              width: 88,
              margin: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                  color: const Color.fromRGBO(10, 107, 103, 1), borderRadius: BorderRadius.circular(32)),
              child:
                  Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Padding(
                  padding: const EdgeInsets.only(top: 18),
                  child: Column(children: [
                    // --- DIUBAH MENJADI PUTIH ---
                    const Icon(Icons.travel_explore,
                        color: Colors.white, size: 28),
                    const SizedBox(height: 12),
                    RotatedBox(
                        quarterTurns: -1,
                        child: Text('TripPlan',
                            style: const TextStyle(
                                // --- DIUBAH MENJADI PUTIH ---
                                color: Colors.white,
                                fontFamily: 'Poppins',
                                fontSize: 18,
                                fontWeight: FontWeight.w700))),
                  ]),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: IconButton(
                      onPressed: _logout,
                      icon: const Icon(Icons.logout,
                          // --- DIUBAH MENJADI PUTIH ---
                          color: Colors.white,
                          size: 26)),
                ),
              ]),
            ),

            // === MAIN CONTENT ===
            Expanded(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  // --- PERUBAHAN: JUDUL DI TENGAH ---
                  SizedBox(
                    width: double.infinity,
                    child: Text(
                      'Perjalanan Saya',
                      style: theme.textTheme.titleLarge
                          ?.copyWith(fontWeight: FontWeight.w700),
                      textAlign: TextAlign.center, // <-- Tambahkan ini
                    ),
                  ),
                  // ------------------------------------
                  const SizedBox(height: 14),
                  // top budget card
                  _cardTop(context, primary),
                  const SizedBox(height: 18),
                  // grid/list of small cards
                  Expanded(
                    child: LayoutBuilder(builder: (ctx, constraints) {
                      final cross = constraints.maxWidth > 1200
                          ? 3
                          : constraints.maxWidth > 900
                              ? 2
                              : 1;
                      return GridView.builder(
                        itemCount: _activities.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: cross,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          childAspectRatio: 4.2,
                        ),
                        itemBuilder: (ctx, i) =>
                            _destinationCard(_activities[i]),
                      );
                    }),
                  ),
                  const SizedBox(height: 12),
                  // bottom full-width Add button (replaces FAB)
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton.icon(
                      onPressed: () => _showAddActivity(primary: primary),
                      icon: const Icon(Icons.add_location),
                      label: const Text('Tambah Destinasi'),
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),                                                                                                                                
                          padding:
                              const EdgeInsets.symmetric(vertical: 14)),
                    ),
                  ),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}