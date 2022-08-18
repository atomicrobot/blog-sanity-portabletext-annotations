import 'dart:convert';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:json_annotation/json_annotation.dart';

part 'main.g.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pets Project',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Pets Project'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Future<List<Pet>> _findPets() async {
    const projectId = 'ofq4hkcl';
    const dataset = 'production';
    const query = '*[_type == "pet" && name == "Tybalt"]';
    //const query = '*[_type == "pet"]';
    //const query = '*[_type == "pet" && !(_id in path("drafts.**")) && name != null]';

    final Map<String, dynamic> queryParameters = <String, dynamic>{
      'query': query
    };

    final uri = Uri(
      scheme: 'https',
      host: '$projectId.api.sanity.io',
      path: '/v2021-10-21/data/query/$dataset',
      queryParameters: queryParameters,
    );

    final http.Client client = http.Client();
    final http.Response response = await client.get(uri);
    //print(response.body);
    final body = jsonDecode(response.body);
    //print(body);
    final result = PetQueryResponse.fromJson(body);
    return result.result;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: FutureBuilder<List<Pet>>(
                future: _findPets(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    print(snapshot.error);
                    return Container();
                  }
                  final pets = snapshot.data ?? [];
                  return ListView.builder(
                    padding: const EdgeInsets.all(8),
                    itemCount: pets.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Card(
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                pets[index].name ?? "Unknown",
                                style: Theme.of(context).textTheme.bodyText1,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                pets[index].shortDescription ?? "Unknown",
                                style: Theme.of(context).textTheme.bodyText1,
                              ),
                              const SizedBox(height: 8),
                              PortableTextWidget(pets[index].description ?? [])
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}

class PortableTextWidget extends StatelessWidget {
  final List<PortableText> portableText;

  const PortableTextWidget(this.portableText, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [...portableText.map((pt) => PortableTextStatelessWidget(pt))],
    );
  }
}

class PortableTextStatelessWidget extends StatelessWidget {
  final PortableText portableText;

  const PortableTextStatelessWidget(this.portableText, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: DefaultTextStyle.of(context).style,
        children: portableText.children?.map((child) {
          String text = child.text;
          Color? color;
          FontWeight? fontWeight;
          TapGestureRecognizer? recognizer;
          for (var mark in child.marks) {
            final markDef = portableText.findMark(mark);
            if (markDef != null) {
              if (markDef.type == "productAnnotation") {
                fontWeight = FontWeight.bold;
                color = Colors.blue;
                recognizer = TapGestureRecognizer()
                  ..onTap = () {
                    Navigator.of(context).restorablePush(_dialogBuilder,
                        arguments: markDef.prompt);
                  };
              }
            }
          }
          TextStyle style = TextStyle(fontWeight: fontWeight, color: color);
          return TextSpan(text: text, style: style, recognizer: recognizer);
        }).toList(),
      ),
    );
  }

  static Route<Object?> _dialogBuilder(
      BuildContext context, Object? arguments) {
    return DialogRoute<void>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Buy Pet Toy'),
        content: Text('$arguments'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, 'No'),
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, 'Yes'),
            child: const Text('Yes'),
          ),
        ],
      ),
    );
  }
}

@JsonSerializable()
class PetQueryResponse {
  factory PetQueryResponse.fromJson(Map<String, dynamic> json) =>
      _$PetQueryResponseFromJson(json);

  final List<Pet> result;

  PetQueryResponse(this.result);
}

@JsonSerializable()
class Pet {
  final String? birthday;
  final List<PortableText>? description;
  final int? fluffiness;
  final String? hair;
  final String? name;
  final String? shortDescription;

  Pet(
      {this.description,
      this.birthday,
      this.fluffiness,
      this.hair,
      this.name,
      this.shortDescription});
  factory Pet.fromJson(Map<String, dynamic> json) => _$PetFromJson(json);
}

@JsonSerializable()
class PortableText {
  factory PortableText.fromJson(Map<String, dynamic> json) =>
      _$PortableTextFromJson(json);

  final List<PortableTextChild>? children;
  final List<PortableTextMarkDef>? markDefs;

  PortableText(this.children, this.markDefs);

  PortableTextMarkDef? findMark(String key) {
    final results = markDefs?.where((item) => item.key == key);
    if (results != null && results.isNotEmpty) {
      return results.first;
    }
    return null;
  }
}

@JsonSerializable()
class PortableTextMarkDef {
  factory PortableTextMarkDef.fromJson(Map<String, dynamic> json) =>
      _$PortableTextMarkDefFromJson(json);

  @JsonKey(name: "_key")
  final String key;

  @JsonKey(name: "_ref")
  final String? ref;

  @JsonKey(name: "_type")
  final String type;

  @JsonKey(name: "prompt")
  final String? prompt;

  PortableTextMarkDef(this.key, this.type, this.ref, this.prompt);
}

@JsonSerializable()
class PortableTextChild {
  factory PortableTextChild.fromJson(Map<String, dynamic> json) =>
      _$PortableTextChildFromJson(json);

  final String text;
  final List<String> marks;

  PortableTextChild(this.text, this.marks);
}
