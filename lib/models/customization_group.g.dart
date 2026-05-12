// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customization_group.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CustomizationGroup _$CustomizationGroupFromJson(Map<String, dynamic> json) =>
    CustomizationGroup(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      required: json['required'] as bool,
      maxSelections: (json['max_selections'] as num).toInt(),
      options: (json['options'] as List<dynamic>)
          .map((e) => CustomizationOption.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$CustomizationGroupToJson(CustomizationGroup instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'required': instance.required,
      'max_selections': instance.maxSelections,
      'options': instance.options,
    };
