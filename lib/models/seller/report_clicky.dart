import 'package:cloud_firestore/cloud_firestore.dart';

class ReportClicky {
  final String id;
  final String reportBy;
  late String reportTo;
  late String reportFor;
  final String issue;

  ReportClicky({
    required this.id,
    required this.reportBy,
    required this.reportTo,
    required this.reportFor,
    required this.issue,
  });

  Map<String, dynamic> toJson() => {
        "id": id,
        "reportBy": reportBy,
        "issue": issue,
        "reportTo": reportTo,
        "reportFor": reportFor,
      };

  static ReportClicky fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return ReportClicky(
      id: snapshot['id'],
      reportBy: snapshot['reportBy'],
      reportTo: snapshot['reportTo'],
      reportFor: snapshot['reportFor'],
      issue: snapshot['issue'],
    );
  }
}
