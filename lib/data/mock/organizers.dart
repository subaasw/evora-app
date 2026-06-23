class Organizer {
  const Organizer({
    required this.name,
    required this.org,
    required this.email,
    required this.phone,
    required this.events,
  });

  final String name;
  final String org;
  final String email;
  final String phone;
  final int events;

  String get initials {
    final parts = name.trim().split(' ');
    if (parts.length == 1) return parts.first.substring(0, 1).toUpperCase();
    return (parts.first.substring(0, 1) + parts.last.substring(0, 1)).toUpperCase();
  }
}

final List<Organizer> seedOrganizers = [
  const Organizer(
    name: 'Aisha Rahman',
    org: 'Soundwave Productions',
    email: 'aisha@soundwave.com',
    phone: '+60 12-345 6789',
    events: 8,
  ),
  const Organizer(
    name: 'Daniel Lee',
    org: 'TechMeet Asia',
    email: 'daniel@techmeet.asia',
    phone: '+60 13-222 4455',
    events: 5,
  ),
  const Organizer(
    name: 'Priya Nair',
    org: 'Craft Collective',
    email: 'priya@craftcollective.io',
    phone: '+60 11-987 6543',
    events: 3,
  ),
  const Organizer(
    name: 'Marcus Tan',
    org: 'Stage One Events',
    email: 'marcus@stageone.my',
    phone: '+60 16-555 1212',
    events: 11,
  ),
];
