import 'package:cloud_firestore/cloud_firestore.dart';

class ReportIssue {
  final String id;
  final String reportBy;
  late String reportTo;
  final String issue;

  ReportIssue({
    required this.id,
    required this.reportBy,
    required this.reportTo,
    required this.issue,
  });

  Map<String, dynamic> toJson() => {
        "id": id,
        "reportBy": reportBy,
        "issue": issue,
        "reportTo": reportTo,
      };

  static ReportIssue fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return ReportIssue(
      id: snapshot['id'],
      reportBy: snapshot['reportBy'],
      reportTo: snapshot['reportTo'],
      issue: snapshot['issue'],
    );
  }
}
