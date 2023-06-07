import 'dart:convert';

class Claim {
  final int amount;
  final monthlyRepayment, rate, repaymentPeriod, totalRepayment;

  Claim({
    required this.amount,
    required this.monthlyRepayment,
    required this.rate,
    required this.repaymentPeriod,
    required this.totalRepayment,
  });

  factory Claim.fromJson(Map<String, dynamic> jsonData) {
    return Claim(
      amount: jsonData['amount'],
      monthlyRepayment: jsonData['monthlyRepayment'],
      rate: jsonData['rate'],
      repaymentPeriod: jsonData['repaymentPeriod'],
      totalRepayment: jsonData['totalRepayment'],
    );
  }

  static Map<String, dynamic> toMap(Claim claim) => {
    'amount': claim.amount,
    'monthlyRepayment': claim.monthlyRepayment,
    'rate': claim.rate,
    'repaymentPeriod': claim.repaymentPeriod,
    'totalRepayment': claim.totalRepayment,
  };

  static String encode(List<Claim> claims) => json.encode(
    claims
        .map<Map<String, dynamic>>((claim) => Claim.toMap(claim))
        .toList(),
  );

  static List<Claim> decode(String claims) =>
      (json.decode(claims) as List<dynamic>)
          .map<Claim>((item) => Claim.fromJson(item))
          .toList();
}