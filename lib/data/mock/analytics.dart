enum ReportPeriod { daily, weekly, monthly }

extension ReportPeriodX on ReportPeriod {
  String get label => switch (this) {
        ReportPeriod.daily => 'Daily',
        ReportPeriod.weekly => 'Weekly',
        ReportPeriod.monthly => 'Monthly',
      };
}

class SeriesPoint {
  const SeriesPoint(this.label, this.value);
  final String label;
  final double value;
}

/// Mock ticket-sales series per reporting period.
List<SeriesPoint> ticketSales(ReportPeriod period) => switch (period) {
      ReportPeriod.daily => const [
          SeriesPoint('Mon', 24),
          SeriesPoint('Tue', 38),
          SeriesPoint('Wed', 30),
          SeriesPoint('Thu', 52),
          SeriesPoint('Fri', 74),
          SeriesPoint('Sat', 96),
          SeriesPoint('Sun', 61),
        ],
      ReportPeriod.weekly => const [
          SeriesPoint('W1', 180),
          SeriesPoint('W2', 240),
          SeriesPoint('W3', 205),
          SeriesPoint('W4', 312),
        ],
      ReportPeriod.monthly => const [
          SeriesPoint('Apr', 620),
          SeriesPoint('May', 780),
          SeriesPoint('Jun', 910),
          SeriesPoint('Jul', 1140),
        ],
    };

/// Mock auditorium-usage series (events hosted) for the admin reports.
List<SeriesPoint> auditoriumUsage(ReportPeriod period) => switch (period) {
      ReportPeriod.daily => const [
          SeriesPoint('Mon', 1),
          SeriesPoint('Tue', 2),
          SeriesPoint('Wed', 1),
          SeriesPoint('Thu', 3),
          SeriesPoint('Fri', 2),
          SeriesPoint('Sat', 4),
          SeriesPoint('Sun', 3),
        ],
      ReportPeriod.weekly => const [
          SeriesPoint('W1', 9),
          SeriesPoint('W2', 12),
          SeriesPoint('W3', 7),
          SeriesPoint('W4', 14),
        ],
      ReportPeriod.monthly => const [
          SeriesPoint('Apr', 28),
          SeriesPoint('May', 31),
          SeriesPoint('Jun', 26),
          SeriesPoint('Jul', 35),
        ],
    };

double seriesTotal(List<SeriesPoint> points) =>
    points.fold(0, (a, b) => a + b.value);
