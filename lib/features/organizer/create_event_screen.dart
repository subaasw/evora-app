import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:evora/data/app_role.dart';
import 'package:evora/data/mock/event_store.dart';
import 'package:evora/data/mock/models.dart';
import 'package:evora/theme/app_tokens.dart';
import 'package:evora/theme/sketch_colors.dart';
import 'package:evora/widgets/profile_menu_button.dart';
import 'package:evora/widgets/sketch_box.dart';
import 'package:evora/widgets/sketch_button.dart';

class CreateEventScreen extends StatefulWidget {
  const CreateEventScreen({super.key, this.eventId});

  /// When set, the screen edits an existing event instead of creating one.
  final String? eventId;

  @override
  State<CreateEventScreen> createState() => _CreateEventScreenState();
}

class _TicketDraft {
  _TicketDraft(this.name, this.price);
  final TextEditingController name;
  final TextEditingController price;

  _TicketDraft.of(String name, String price)
      : name = TextEditingController(text: name),
        price = TextEditingController(text: price);

  void dispose() {
    name.dispose();
    price.dispose();
  }
}

class _CreateEventScreenState extends State<CreateEventScreen> {
  final _name = TextEditingController();
  final _venue = TextEditingController();
  final _description = TextEditingController();
  EventCategory _category = EventCategory.concert;
  DateTime? _date;
  TimeOfDay? _time;
  final _tickets = <_TicketDraft>[];
  int _seatsLeft = 150;

  bool get _isEdit => widget.eventId != null;

  @override
  void initState() {
    super.initState();
    if (_isEdit) {
      final e = context.read<EventStore>().byId(widget.eventId!);
      _name.text = e.title;
      _venue.text = e.venue;
      _description.text = e.description;
      _category = e.category;
      _date = e.date;
      _time = TimeOfDay.fromDateTime(e.date);
      _seatsLeft = e.seatsLeft;
      for (final t in e.ticketTypes) {
        _tickets.add(_TicketDraft.of(t.name, t.price.toStringAsFixed(0)));
      }
    } else {
      _tickets.add(_TicketDraft.of('General', '25'));
    }
  }

  @override
  void dispose() {
    _name.dispose();
    _venue.dispose();
    _description.dispose();
    for (final t in _tickets) {
      t.dispose();
    }
    super.dispose();
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      firstDate: now,
      lastDate: DateTime(now.year + 2),
      initialDate: _date ?? now,
    );
    if (picked != null) setState(() => _date = picked);
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _time ?? const TimeOfDay(hour: 19, minute: 0),
    );
    if (picked != null) setState(() => _time = picked);
  }

  String? _validate() {
    if (_name.text.trim().isEmpty) return 'Enter an event name';
    if (_date == null || _time == null) return 'Pick a date and time';
    final hasTicket = _tickets.any((t) => t.name.text.trim().isNotEmpty);
    if (!hasTicket) return 'Add at least one ticket type';
    return null;
  }

  void _submit() {
    final error = _validate();
    if (error != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error)));
      return;
    }
    final date = DateTime(
        _date!.year, _date!.month, _date!.day, _time!.hour, _time!.minute);
    final tickets = [
      for (final t in _tickets)
        if (t.name.text.trim().isNotEmpty)
          TicketType(
            name: t.name.text.trim(),
            price: double.tryParse(t.price.text.trim()) ?? 0,
          ),
    ];
    final store = context.read<EventStore>();
    final event = EventModel(
      id: widget.eventId ?? 'e${DateTime.now().millisecondsSinceEpoch}',
      title: _name.text.trim(),
      category: _category,
      date: date,
      venue: _venue.text.trim().isEmpty ? 'HELP Auditorium' : _venue.text.trim(),
      description: _description.text.trim(),
      ticketTypes: tickets,
      seatsLeft: _seatsLeft,
    );
    if (_isEdit) {
      store.update(event);
    } else {
      store.add(event);
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(_isEdit ? 'Event updated' : 'Event created')),
    );
    if (_isEdit) context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(_isEdit ? 'Edit Event' : 'Create Event'),
        actions: profileActions(AppRole.organizer),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
            AppSpacing.md, AppSpacing.sm, AppSpacing.md, AppSpacing.xl),
        children: [
          _Label('Event name'),
          TextField(
            controller: _name,
            decoration: const InputDecoration(hintText: 'e.g. Midnight Echoes Live'),
          ),
          const SizedBox(height: AppSpacing.lg),
          _Label('Category'),
          Wrap(
            spacing: 8,
            children: [
              for (final c in EventCategory.values)
                ChoiceChip(
                  selected: _category == c,
                  onSelected: (_) => setState(() => _category = c),
                  avatar: Icon(c.icon,
                      size: 16,
                      color: _category == c
                          ? theme.colorScheme.onPrimary
                          : theme.colorScheme.onSurface),
                  label: Text(c.label),
                  showCheckmark: false,
                  selectedColor: theme.colorScheme.primary,
                  labelStyle: TextStyle(
                    color: _category == c
                        ? theme.colorScheme.onPrimary
                        : theme.colorScheme.onSurface,
                  ),
                  side: BorderSide(color: theme.colorScheme.outline, width: 2),
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          Row(
            children: [
              Expanded(
                child: _PickerField(
                  label: 'Date',
                  icon: Icons.calendar_today_outlined,
                  value: _date == null ? 'Select' : formatDay(_date!),
                  onTap: _pickDate,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: _PickerField(
                  label: 'Time',
                  icon: Icons.schedule_outlined,
                  value: _time == null ? 'Select' : _time!.format(context),
                  onTap: _pickTime,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          _Label('Venue'),
          TextField(
            controller: _venue,
            decoration: const InputDecoration(hintText: 'HELP Auditorium, Main Hall'),
          ),
          const SizedBox(height: AppSpacing.lg),
          _Label('Description'),
          TextField(
            controller: _description,
            maxLines: 4,
            decoration: const InputDecoration(hintText: 'Tell attendees about the event'),
          ),
          const SizedBox(height: AppSpacing.lg),
          _Label('Event poster'),
          _PosterUpload(accent: _category.accent),
          const SizedBox(height: AppSpacing.lg),
          Row(
            children: [
              Expanded(child: _Label('Ticket types')),
              TextButton.icon(
                onPressed: () =>
                    setState(() => _tickets.add(_TicketDraft.of('', ''))),
                icon: const Icon(Icons.add, size: 18),
                label: const Text('Add'),
              ),
            ],
          ),
          for (var i = 0; i < _tickets.length; i++) ...[
            _TicketRow(
              draft: _tickets[i],
              onRemove: _tickets.length > 1
                  ? () => setState(() => _tickets.removeAt(i).dispose())
                  : null,
            ),
            const SizedBox(height: AppSpacing.sm),
          ],
          const SizedBox(height: AppSpacing.lg),
          SketchButton(
            label: _isEdit ? 'Save changes' : 'Create event',
            icon: Icons.check,
            onPressed: _submit,
          ),
        ],
      ),
    );
  }
}

class _Label extends StatelessWidget {
  const _Label(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: AppSpacing.sm),
      child: Text(text, style: Theme.of(context).textTheme.titleSmall),
    );
  }
}

class _PickerField extends StatelessWidget {
  const _PickerField({
    required this.label,
    required this.icon,
    required this.value,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final String value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final s = context.sketch;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _Label(label),
        GestureDetector(
          onTap: onTap,
          child: SketchBox(
            fill: s.paperSoft,
            radius: 999,
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
            child: Row(
              children: [
                Icon(icon, size: 18, color: s.body),
                const SizedBox(width: AppSpacing.sm),
                Text(value, style: TextStyle(color: s.heading)),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _PosterUpload extends StatelessWidget {
  const _PosterUpload({required this.accent});
  final Color accent;

  @override
  Widget build(BuildContext context) {
    final s = context.sketch;
    return GestureDetector(
      onTap: () => ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Poster upload (mock)')),
      ),
      child: SketchBox(
        fill: accent.withValues(alpha: 0.12),
        radius: AppRadius.lg,
        padding: const EdgeInsets.symmetric(vertical: 28),
        child: Column(
          children: [
            Icon(Icons.add_photo_alternate_outlined, size: 32, color: accent),
            const SizedBox(height: AppSpacing.sm),
            Text('Upload poster', style: TextStyle(color: s.bodySubtle)),
          ],
        ),
      ),
    );
  }
}

class _TicketRow extends StatelessWidget {
  const _TicketRow({required this.draft, required this.onRemove});

  final _TicketDraft draft;
  final VoidCallback? onRemove;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: TextField(
            controller: draft.name,
            decoration: const InputDecoration(hintText: 'Type (e.g. VIP)'),
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: TextField(
            controller: draft.price,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(prefixText: '\$ ', hintText: '0'),
          ),
        ),
        if (onRemove != null)
          IconButton(
            onPressed: onRemove,
            icon: Icon(Icons.remove_circle_outline, color: context.sketch.danger),
          ),
      ],
    );
  }
}
