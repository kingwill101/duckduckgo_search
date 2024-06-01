// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'answer.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Answer _$AnswerFromJson(Map<String, dynamic> json) => Answer(
      answerAbstract: json['Abstract'] as String?,
      abstractSource: json['AbstractSource'] as String?,
      abstractText: json['AbstractText'] as String?,
      abstractUrl: json['AbstractURL'] as String?,
      answer: json['Answer'] as String?,
      answerType: json['AnswerType'] as String?,
      definition: json['Definition'] as String?,
      definitionSource: json['DefinitionSource'] as String?,
      definitionUrl: json['DefinitionURL'] as String?,
      entity: json['Entity'] as String?,
      heading: json['Heading'] as String?,
      image: json['Image'] as String?,
      imageHeight: (json['ImageHeight'] as num?)?.toInt(),
      imageIsLogo: (json['ImageIsLogo'] as num?)?.toInt(),
      imageWidth: (json['ImageWidth'] as num?)?.toInt(),
      infobox: json['Infobox'] == null
          ? null
          : Infobox.fromJson(json['Infobox'] as Map<String, dynamic>),
      redirect: json['Redirect'] as String?,
      relatedTopics: (json['RelatedTopics'] as List<dynamic>?)
          ?.map((e) => RelatedTopic.fromJson(e as Map<String, dynamic>))
          .toList(),
      results: json['Results'] as List<dynamic>?,
      type: json['Type'] as String?,
      meta: json['meta'] == null
          ? null
          : AnswerMeta.fromJson(json['meta'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$AnswerToJson(Answer instance) => <String, dynamic>{
      'Abstract': instance.answerAbstract,
      'AbstractSource': instance.abstractSource,
      'AbstractText': instance.abstractText,
      'AbstractURL': instance.abstractUrl,
      'Answer': instance.answer,
      'AnswerType': instance.answerType,
      'Definition': instance.definition,
      'DefinitionSource': instance.definitionSource,
      'DefinitionURL': instance.definitionUrl,
      'Entity': instance.entity,
      'Heading': instance.heading,
      'Image': instance.image,
      'ImageHeight': instance.imageHeight,
      'ImageIsLogo': instance.imageIsLogo,
      'ImageWidth': instance.imageWidth,
      'Infobox': instance.infobox,
      'Redirect': instance.redirect,
      'RelatedTopics': instance.relatedTopics,
      'Results': instance.results,
      'Type': instance.type,
      'meta': instance.meta,
    };

Infobox _$InfoboxFromJson(Map<String, dynamic> json) => Infobox(
      content: (json['content'] as List<dynamic>?)
          ?.map((e) => Content.fromJson(e as Map<String, dynamic>))
          .toList(),
      meta: (json['meta'] as List<dynamic>?)
          ?.map((e) => MetaElement.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$InfoboxToJson(Infobox instance) => <String, dynamic>{
      'content': instance.content,
      'meta': instance.meta,
    };

Content _$ContentFromJson(Map<String, dynamic> json) => Content(
      dataType: json['data_type'] as String?,
      label: json['label'] as String?,
      value: json['value'],
      wikiOrder: json['wiki_order'],
    );

Map<String, dynamic> _$ContentToJson(Content instance) => <String, dynamic>{
      'data_type': instance.dataType,
      'label': instance.label,
      'value': instance.value,
      'wiki_order': instance.wikiOrder,
    };

ValueClass _$ValueClassFromJson(Map<String, dynamic> json) => ValueClass(
      entityType: json['entity-type'] as String?,
      id: json['id'] as String?,
      numericId: (json['numeric-id'] as num?)?.toInt(),
    );

Map<String, dynamic> _$ValueClassToJson(ValueClass instance) =>
    <String, dynamic>{
      'entity-type': instance.entityType,
      'id': instance.id,
      'numeric-id': instance.numericId,
    };

MetaElement _$MetaElementFromJson(Map<String, dynamic> json) => MetaElement(
      dataType: json['data_type'] as String?,
      label: json['label'] as String?,
      value: json['value'] as String?,
    );

Map<String, dynamic> _$MetaElementToJson(MetaElement instance) =>
    <String, dynamic>{
      'data_type': instance.dataType,
      'label': instance.label,
      'value': instance.value,
    };

AnswerMeta _$AnswerMetaFromJson(Map<String, dynamic> json) => AnswerMeta(
      attribution: json['attribution'],
      blockgroup: json['blockgroup'],
      createdDate: json['created_date'],
      description: json['description'] as String?,
      designer: json['designer'],
      devDate: json['dev_date'],
      devMilestone: json['dev_milestone'] as String?,
      developer: (json['developer'] as List<dynamic>?)
          ?.map((e) => Developer.fromJson(e as Map<String, dynamic>))
          .toList(),
      exampleQuery: json['example_query'] as String?,
      id: json['id'] as String?,
      isStackexchange: json['is_stackexchange'],
      jsCallbackName: json['js_callback_name'] as String?,
      liveDate: json['live_date'],
      maintainer: json['maintainer'] == null
          ? null
          : Maintainer.fromJson(json['maintainer'] as Map<String, dynamic>),
      name: json['name'] as String?,
      perlModule: json['perl_module'] as String?,
      producer: json['producer'],
      productionState: json['production_state'] as String?,
      repo: json['repo'] as String?,
      signalFrom: json['signal_from'] as String?,
      srcDomain: json['src_domain'] as String?,
      srcId: (json['src_id'] as num?)?.toInt(),
      srcName: json['src_name'] as String?,
      srcOptions: json['src_options'] == null
          ? null
          : SrcOptions.fromJson(json['src_options'] as Map<String, dynamic>),
      srcUrl: json['src_url'],
      status: json['status'] as String?,
      tab: json['tab'] as String?,
      topic:
          (json['topic'] as List<dynamic>?)?.map((e) => e as String).toList(),
      unsafe: (json['unsafe'] as num?)?.toInt(),
    );

Map<String, dynamic> _$AnswerMetaToJson(AnswerMeta instance) =>
    <String, dynamic>{
      'attribution': instance.attribution,
      'blockgroup': instance.blockgroup,
      'created_date': instance.createdDate,
      'description': instance.description,
      'designer': instance.designer,
      'dev_date': instance.devDate,
      'dev_milestone': instance.devMilestone,
      'developer': instance.developer,
      'example_query': instance.exampleQuery,
      'id': instance.id,
      'is_stackexchange': instance.isStackexchange,
      'js_callback_name': instance.jsCallbackName,
      'live_date': instance.liveDate,
      'maintainer': instance.maintainer,
      'name': instance.name,
      'perl_module': instance.perlModule,
      'producer': instance.producer,
      'production_state': instance.productionState,
      'repo': instance.repo,
      'signal_from': instance.signalFrom,
      'src_domain': instance.srcDomain,
      'src_id': instance.srcId,
      'src_name': instance.srcName,
      'src_options': instance.srcOptions,
      'src_url': instance.srcUrl,
      'status': instance.status,
      'tab': instance.tab,
      'topic': instance.topic,
      'unsafe': instance.unsafe,
    };

Developer _$DeveloperFromJson(Map<String, dynamic> json) => Developer(
      name: json['name'] as String?,
      type: json['type'] as String?,
      url: json['url'] as String?,
    );

Map<String, dynamic> _$DeveloperToJson(Developer instance) => <String, dynamic>{
      'name': instance.name,
      'type': instance.type,
      'url': instance.url,
    };

Maintainer _$MaintainerFromJson(Map<String, dynamic> json) => Maintainer(
      github: json['github'] as String?,
    );

Map<String, dynamic> _$MaintainerToJson(Maintainer instance) =>
    <String, dynamic>{
      'github': instance.github,
    };

SrcOptions _$SrcOptionsFromJson(Map<String, dynamic> json) => SrcOptions(
      directory: json['directory'] as String?,
      isFanon: (json['is_fanon'] as num?)?.toInt(),
      isMediawiki: (json['is_mediawiki'] as num?)?.toInt(),
      isWikipedia: (json['is_wikipedia'] as num?)?.toInt(),
      language: json['language'] as String?,
      minAbstractLength: json['min_abstract_length'] as String?,
      skipAbstract: (json['skip_abstract'] as num?)?.toInt(),
      skipAbstractParen: (json['skip_abstract_paren'] as num?)?.toInt(),
      skipEnd: json['skip_end'] as String?,
      skipIcon: (json['skip_icon'] as num?)?.toInt(),
      skipImageName: (json['skip_image_name'] as num?)?.toInt(),
      skipQr: json['skip_qr'] as String?,
      sourceSkip: json['source_skip'] as String?,
      srcInfo: json['src_info'] as String?,
    );

Map<String, dynamic> _$SrcOptionsToJson(SrcOptions instance) =>
    <String, dynamic>{
      'directory': instance.directory,
      'is_fanon': instance.isFanon,
      'is_mediawiki': instance.isMediawiki,
      'is_wikipedia': instance.isWikipedia,
      'language': instance.language,
      'min_abstract_length': instance.minAbstractLength,
      'skip_abstract': instance.skipAbstract,
      'skip_abstract_paren': instance.skipAbstractParen,
      'skip_end': instance.skipEnd,
      'skip_icon': instance.skipIcon,
      'skip_image_name': instance.skipImageName,
      'skip_qr': instance.skipQr,
      'source_skip': instance.sourceSkip,
      'src_info': instance.srcInfo,
    };

RelatedTopic _$RelatedTopicFromJson(Map<String, dynamic> json) => RelatedTopic(
      firstUrl: json['FirstURL'] as String?,
      icon: json['Icon'] == null
          ? null
          : Icon.fromJson(json['Icon'] as Map<String, dynamic>),
      result: json['Result'] as String?,
      text: json['Text'] as String?,
    );

Map<String, dynamic> _$RelatedTopicToJson(RelatedTopic instance) =>
    <String, dynamic>{
      'FirstURL': instance.firstUrl,
      'Icon': instance.icon,
      'Result': instance.result,
      'Text': instance.text,
    };

Icon _$IconFromJson(Map<String, dynamic> json) => Icon(
      height: json['Height'] as String?,
      url: json['URL'] as String?,
      width: json['Width'] as String?,
    );

Map<String, dynamic> _$IconToJson(Icon instance) => <String, dynamic>{
      'Height': instance.height,
      'URL': instance.url,
      'Width': instance.width,
    };
