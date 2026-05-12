// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customization_option.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CustomizationOption _$CustomizationOptionFromJson(Map<String, dynamic> json) =>
    CustomizationOption(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      priceModifier: (json['price_modifier'] as num).toDouble(),
    );

Map<String, dynamic> _$CustomizationOptionToJson(
  CustomizationOption instance,
) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'price_modifier': instance.priceModifier,
};
