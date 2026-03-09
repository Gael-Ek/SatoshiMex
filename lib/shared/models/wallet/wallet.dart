class WalletModel {
  final String address;
  final String balance;

  WalletModel({required this.address, required this.balance});

  Map<String, dynamic> toJson() => {'address': address, 'balance': balance};

  factory WalletModel.fromJson(Map<String, dynamic> json) =>
      WalletModel(address: json['address'], balance: json['balance']);
}
