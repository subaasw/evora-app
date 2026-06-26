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
    name: 'Aarav Sharma',
    org: 'Soundwave Productions',
    email: 'aarav@soundwave.com',
    phone: '+977 98-1234 5678',
    events: 8,
  ),
  const Organizer(
    name: 'Bishal Thapa',
    org: 'TechMeet Asia',
    email: 'bishal@techmeet.asia',
    phone: '+977 98-2222 4455',
    events: 5,
  ),
  const Organizer(
    name: 'Anjali Gurung',
    org: 'Craft Collective',
    email: 'anjali@craftcollective.io',
    phone: '+977 98-7654 3210',
    events: 3,
  ),
  const Organizer(
    name: 'Nirajan Shrestha',
    org: 'Stage One Events',
    email: 'nirajan@stageone.my',
    phone: '+977 98-5551 2120',
    events: 11,
  ),
];
