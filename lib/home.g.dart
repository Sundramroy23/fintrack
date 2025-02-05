// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Transaction _$TransactionFromJson(Map<String, dynamic> json) => Transaction(
      DateTime.parse(json['dateTime'] as String),
      (json['amount'] as num).toDouble(),
      json['type'] as String,
      (json['account'] as num).toInt(),
      (json['category'] as num).toInt(),
      json['notes'] as String,
    );

Map<String, dynamic> _$TransactionToJson(Transaction instance) =>
    <String, dynamic>{
      'dateTime': instance.dateTime.toIso8601String(),
      'amount': instance.amount,
      'type': instance.type,
      'account': instance.account,
      'category': instance.category,
      'notes': instance.notes,
    };