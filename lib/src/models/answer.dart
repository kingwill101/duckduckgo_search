import 'package:json_annotation/json_annotation.dart';

part 'answer.g.dart';


class InfoboxConverter implements JsonConverter<Infobox?, dynamic> {
  const InfoboxConverter();

  @override
  Infobox? fromJson(dynamic json) {
    if (json is String && json.isEmpty) {
      return null; // or return an empty Infobox instance if preferred
    }
    if (json is Map<String, dynamic>) {
      return Infobox.fromJson(json);
    }
    return null;
  }

  @override
  dynamic toJson(Infobox? object) {
    return object?.toJson();
  }
}

class EmptyStringToNullNumberConverter implements JsonConverter<int?, dynamic> {
  const EmptyStringToNullNumberConverter();

  @override
  int? fromJson(dynamic json) {
    if (json is String && json.isEmpty) {
      return null;
    }
    if (json is int) {
      return json;
    }
    return null;
  }

  @override
  dynamic toJson(int? object) {
    return object;
  }
}


@JsonSerializable()
class Answer {
  @JsonKey(name: "Abstract")
  final String? answerAbstract;
  @JsonKey(name: "AbstractSource")
  final String? abstractSource;
  @JsonKey(name: "AbstractText")
  final String? abstractText;
  @JsonKey(name: "AbstractURL")
  final String? abstractUrl;
  @JsonKey(name: "Answer")
  final String? answer;
  @JsonKey(name: "AnswerType")
  final String? answerType;
  @JsonKey(name: "Definition")
  final String? definition;
  @JsonKey(name: "DefinitionSource")
  final String? definitionSource;
  @JsonKey(name: "DefinitionURL")
  final String? definitionUrl;
  @JsonKey(name: "Entity")
  final String? entity;
  @JsonKey(name: "Heading")
  final String? heading;
  @JsonKey(name: "Image")
  final String? image;
  @JsonKey(name: "ImageHeight")
  @EmptyStringToNullNumberConverter()
  final int? imageHeight;
  @JsonKey(name: "ImageIsLogo")
  final int? imageIsLogo;
  @JsonKey(name: "ImageWidth")
  @EmptyStringToNullNumberConverter()
  final int? imageWidth;
  @JsonKey(name: "Infobox")
  @InfoboxConverter()
  final Infobox? infobox;
  @JsonKey(name: "Redirect")
  final String? redirect;
  @JsonKey(name: "RelatedTopics")
  final List<RelatedTopic>? relatedTopics;
  @JsonKey(name: "Results")
  final List<dynamic>? results;
  @JsonKey(name: "Type")
  final String? type;
  @JsonKey(name: "meta")
  final AnswerMeta? meta;

  Answer({
    this.answerAbstract,
    this.abstractSource,
    this.abstractText,
    this.abstractUrl,
    this.answer,
    this.answerType,
    this.definition,
    this.definitionSource,
    this.definitionUrl,
    this.entity,
    this.heading,
    this.image,
    this.imageHeight,
    this.imageIsLogo,
    this.imageWidth,
    this.infobox,
    this.redirect,
    this.relatedTopics,
    this.results,
    this.type,
    this.meta,
  });

  factory Answer.fromJson(Map<String, dynamic> json) => _$AnswerFromJson(json);

  Map<String, dynamic> toJson() => _$AnswerToJson(this);
}

@JsonSerializable()
class Infobox {
  @JsonKey(name: "content")
  final List<Content>? content;
  @JsonKey(name: "meta")
  final List<MetaElement>? meta;

  Infobox({
    this.content,
    this.meta,
  });

  factory Infobox.fromJson(Map<String, dynamic> json) =>
      _$InfoboxFromJson(json);

  Map<String, dynamic> toJson() => _$InfoboxToJson(this);
}

@JsonSerializable()
class Content {
  @JsonKey(name: "data_type")
  final String? dataType;
  @JsonKey(name: "label")
  final String? label;
  @JsonKey(name: "value")
  final dynamic value;
  @JsonKey(name: "wiki_order")
  final dynamic wikiOrder;

  Content({
    this.dataType,
    this.label,
    this.value,
    this.wikiOrder,
  });

  factory Content.fromJson(Map<String, dynamic> json) =>
      _$ContentFromJson(json);

  Map<String, dynamic> toJson() => _$ContentToJson(this);
}

@JsonSerializable()
class ValueClass {
  @JsonKey(name: "entity-type")
  final String? entityType;
  @JsonKey(name: "id")
  final String? id;
  @JsonKey(name: "numeric-id")
  final int? numericId;

  ValueClass({
    this.entityType,
    this.id,
    this.numericId,
  });

  factory ValueClass.fromJson(Map<String, dynamic> json) =>
      _$ValueClassFromJson(json);

  Map<String, dynamic> toJson() => _$ValueClassToJson(this);
}

@JsonSerializable()
class MetaElement {
  @JsonKey(name: "data_type")
  final String? dataType;
  @JsonKey(name: "label")
  final String? label;
  @JsonKey(name: "value")
  final String? value;

  MetaElement({
    this.dataType,
    this.label,
    this.value,
  });

  factory MetaElement.fromJson(Map<String, dynamic> json) =>
      _$MetaElementFromJson(json);

  Map<String, dynamic> toJson() => _$MetaElementToJson(this);
}

@JsonSerializable()
class AnswerMeta {
  @JsonKey(name: "attribution")
  final dynamic attribution;
  @JsonKey(name: "blockgroup")
  final dynamic blockgroup;
  @JsonKey(name: "created_date")
  final dynamic createdDate;
  @JsonKey(name: "description")
  final String? description;
  @JsonKey(name: "designer")
  final dynamic designer;
  @JsonKey(name: "dev_date")
  final dynamic devDate;
  @JsonKey(name: "dev_milestone")
  final String? devMilestone;
  @JsonKey(name: "developer")
  final List<Developer>? developer;
  @JsonKey(name: "example_query")
  final String? exampleQuery;
  @JsonKey(name: "id")
  final String? id;
  @JsonKey(name: "is_stackexchange")
  final dynamic isStackexchange;
  @JsonKey(name: "js_callback_name")
  final String? jsCallbackName;
  @JsonKey(name: "live_date")
  final dynamic liveDate;
  @JsonKey(name: "maintainer")
  final Maintainer? maintainer;
  @JsonKey(name: "name")
  final String? name;
  @JsonKey(name: "perl_module")
  final String? perlModule;
  @JsonKey(name: "producer")
  final dynamic producer;
  @JsonKey(name: "production_state")
  final String? productionState;
  @JsonKey(name: "repo")
  final String? repo;
  @JsonKey(name: "signal_from")
  final String? signalFrom;
  @JsonKey(name: "src_domain")
  final String? srcDomain;
  @JsonKey(name: "src_id")
  final int? srcId;
  @JsonKey(name: "src_name")
  final String? srcName;
  @JsonKey(name: "src_options")
  final SrcOptions? srcOptions;
  @JsonKey(name: "src_url")
  final dynamic srcUrl;
  @JsonKey(name: "status")
  final String? status;
  @JsonKey(name: "tab")
  final String? tab;
  @JsonKey(name: "topic")
  final List<String>? topic;
  @JsonKey(name: "unsafe")
  final int? unsafe;

  AnswerMeta({
    this.attribution,
    this.blockgroup,
    this.createdDate,
    this.description,
    this.designer,
    this.devDate,
    this.devMilestone,
    this.developer,
    this.exampleQuery,
    this.id,
    this.isStackexchange,
    this.jsCallbackName,
    this.liveDate,
    this.maintainer,
    this.name,
    this.perlModule,
    this.producer,
    this.productionState,
    this.repo,
    this.signalFrom,
    this.srcDomain,
    this.srcId,
    this.srcName,
    this.srcOptions,
    this.srcUrl,
    this.status,
    this.tab,
    this.topic,
    this.unsafe,
  });

  factory AnswerMeta.fromJson(Map<String, dynamic> json) =>
      _$AnswerMetaFromJson(json);

  Map<String, dynamic> toJson() => _$AnswerMetaToJson(this);
}

@JsonSerializable()
class Developer {
  @JsonKey(name: "name")
  final String? name;
  @JsonKey(name: "type")
  final String? type;
  @JsonKey(name: "url")
  final String? url;

  Developer({
    this.name,
    this.type,
    this.url,
  });

  factory Developer.fromJson(Map<String, dynamic> json) =>
      _$DeveloperFromJson(json);

  Map<String, dynamic> toJson() => _$DeveloperToJson(this);
}

@JsonSerializable()
class Maintainer {
  @JsonKey(name: "github")
  final String? github;

  Maintainer({
    this.github,
  });

  factory Maintainer.fromJson(Map<String, dynamic> json) =>
      _$MaintainerFromJson(json);

  Map<String, dynamic> toJson() => _$MaintainerToJson(this);
}

@JsonSerializable()
class SrcOptions {
  @JsonKey(name: "directory")
  final String? directory;
  @JsonKey(name: "is_fanon")
  final int? isFanon;
  @JsonKey(name: "is_mediawiki")
  final int? isMediawiki;
  @JsonKey(name: "is_wikipedia")
  final int? isWikipedia;
  @JsonKey(name: "language")
  final String? language;
  @JsonKey(name: "min_abstract_length")
  final String? minAbstractLength;
  @JsonKey(name: "skip_abstract")
  final int? skipAbstract;
  @JsonKey(name: "skip_abstract_paren")
  final int? skipAbstractParen;
  @JsonKey(name: "skip_end")
  final String? skipEnd;
  @JsonKey(name: "skip_icon")
  final int? skipIcon;
  @JsonKey(name: "skip_image_name")
  final int? skipImageName;
  @JsonKey(name: "skip_qr")
  final String? skipQr;
  @JsonKey(name: "source_skip")
  final String? sourceSkip;
  @JsonKey(name: "src_info")
  final String? srcInfo;

  SrcOptions({
    this.directory,
    this.isFanon,
    this.isMediawiki,
    this.isWikipedia,
    this.language,
    this.minAbstractLength,
    this.skipAbstract,
    this.skipAbstractParen,
    this.skipEnd,
    this.skipIcon,
    this.skipImageName,
    this.skipQr,
    this.sourceSkip,
    this.srcInfo,
  });

  factory SrcOptions.fromJson(Map<String, dynamic> json) =>
      _$SrcOptionsFromJson(json);

  Map<String, dynamic> toJson() => _$SrcOptionsToJson(this);
}

@JsonSerializable()
class RelatedTopic {
  @JsonKey(name: "FirstURL")
  final String? firstUrl;
  @JsonKey(name: "Icon")
  final Icon? icon;
  @JsonKey(name: "Result")
  final String? result;
  @JsonKey(name: "Text")
  final String? text;

  RelatedTopic({
    this.firstUrl,
    this.icon,
    this.result,
    this.text,
  });

  factory RelatedTopic.fromJson(Map<String, dynamic> json) =>
      _$RelatedTopicFromJson(json);

  Map<String, dynamic> toJson() => _$RelatedTopicToJson(this);
}

@JsonSerializable()
class Icon {
  @JsonKey(name: "Height")
  final String? height;
  @JsonKey(name: "URL")
  final String? url;
  @JsonKey(name: "Width")
  final String? width;

  Icon({
    this.height,
    this.url,
    this.width,
  });

  factory Icon.fromJson(Map<String, dynamic> json) => _$IconFromJson(json);

  Map<String, dynamic> toJson() => _$IconToJson(this);
}
