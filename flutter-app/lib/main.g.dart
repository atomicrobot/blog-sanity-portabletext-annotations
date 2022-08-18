// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'main.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PetQueryResponse _$PetQueryResponseFromJson(Map<String, dynamic> json) =>
    PetQueryResponse(
      (json['result'] as List<dynamic>)
          .map((e) => Pet.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$PetQueryResponseToJson(PetQueryResponse instance) =>
    <String, dynamic>{
      'result': instance.result,
    };

Pet _$PetFromJson(Map<String, dynamic> json) => Pet(
      description: (json['description'] as List<dynamic>?)
          ?.map((e) => PortableText.fromJson(e as Map<String, dynamic>))
          .toList(),
      birthday: json['birthday'] as String?,
      fluffiness: json['fluffiness'] as int?,
      hair: json['hair'] as String?,
      name: json['name'] as String?,
      shortDescription: json['shortDescription'] as String?,
    );

Map<String, dynamic> _$PetToJson(Pet instance) => <String, dynamic>{
      'birthday': instance.birthday,
      'description': instance.description,
      'fluffiness': instance.fluffiness,
      'hair': instance.hair,
      'name': instance.name,
      'shortDescription': instance.shortDescription,
    };

PortableText _$PortableTextFromJson(Map<String, dynamic> json) => PortableText(
      (json['children'] as List<dynamic>?)
          ?.map((e) => PortableTextChild.fromJson(e as Map<String, dynamic>))
          .toList(),
      (json['markDefs'] as List<dynamic>?)
          ?.map((e) => PortableTextMarkDef.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$PortableTextToJson(PortableText instance) =>
    <String, dynamic>{
      'children': instance.children,
      'markDefs': instance.markDefs,
    };

PortableTextMarkDef _$PortableTextMarkDefFromJson(Map<String, dynamic> json) =>
    PortableTextMarkDef(
      json['_key'] as String,
      json['_type'] as String,
      json['_ref'] as String?,
      json['prompt'] as String?,
    );

Map<String, dynamic> _$PortableTextMarkDefToJson(
        PortableTextMarkDef instance) =>
    <String, dynamic>{
      '_key': instance.key,
      '_ref': instance.ref,
      '_type': instance.type,
      'prompt': instance.prompt,
    };

PortableTextChild _$PortableTextChildFromJson(Map<String, dynamic> json) =>
    PortableTextChild(
      json['text'] as String,
      (json['marks'] as List<dynamic>).map((e) => e as String).toList(),
    );

Map<String, dynamic> _$PortableTextChildToJson(PortableTextChild instance) =>
    <String, dynamic>{
      'text': instance.text,
      'marks': instance.marks,
    };
