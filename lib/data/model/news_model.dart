import 'dart:convert';

List<NewsModel> newsModelFromJson(String str) =>
    List<NewsModel>.from(json.decode(str).map((x) => NewsModel.fromJson(x)));

String newsModelToJson(List<NewsModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class NewsModel {
  final int? id;
  final String? date;
  final String? link;
  final Title? title;
  final Content? content;
  final int? author;
  final int? featuredMedia;

  NewsModel({
    this.id,
    this.date,
    this.link,
    this.title,
    this.content,
    this.author,
    this.featuredMedia,
  });

  factory NewsModel.fromJson(Map<String, dynamic> json) => NewsModel(
        id: json["id"],
        date: json["date"],
        link: json["link"],
        title: json["title"] == null ? null : Title.fromJson(json["title"]),
        content:
            json["content"] == null ? null : Content.fromJson(json["content"]),
        author: json["author"],
        featuredMedia: json["featured_media"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "date": date,
        "link": link,
        "title": title?.toJson(),
        "content": content?.toJson(),
        "author": author,
        "featured_media": featuredMedia,
      };
}

class Content {
  final String? rendered;
  final bool? protected;

  Content({
    this.rendered,
    this.protected,
  });

  factory Content.fromJson(Map<String, dynamic> json) => Content(
        rendered: json["rendered"],
        protected: json["protected"],
      );

  Map<String, dynamic> toJson() => {
        "rendered": rendered,
        "protected": protected,
      };
}

class Title {
  final String? rendered;

  Title({
    this.rendered,
  });

  factory Title.fromJson(Map<String, dynamic> json) => Title(
        rendered: json["rendered"],
      );

  Map<String, dynamic> toJson() => {
        "rendered": rendered,
      };
}

class Author {
  final int? id;
  final String? name;
  final String? url;
  final String? description;
  final String? link;
  final String? slug;
  final Map<String, String>? avatarUrls;
  final bool? isSuperAdmin;
  final Links? links;

  Author({
    this.id,
    this.name,
    this.url,
    this.description,
    this.link,
    this.slug,
    this.avatarUrls,
    this.isSuperAdmin,
    this.links,
  });
  factory Author.fromJson(Map<String, dynamic> json) => Author(
        id: json["id"],
        name: json["name"],
        url: json["url"],
        description: json["description"],
        link: json["link"],
        slug: json["slug"],
        avatarUrls: Map.from(json["avatar_urls"]!)
            .map((k, v) => MapEntry<String, String>(k, v)),
        isSuperAdmin: json["is_super_admin"],
        links: json["_links"] == null ? null : Links.fromJson(json["_links"]),
      );
}

class Links {
  final List<Collection>? self;
  final List<Collection>? collection;

  Links({
    this.self,
    this.collection,
  });
  factory Links.fromJson(Map<String, dynamic> json) => Links(
        self: json["self"] == null
            ? []
            : List<Collection>.from(
                json["self"]!.map((x) => Collection.fromJson(x))),
        collection: json["collection"] == null
            ? []
            : List<Collection>.from(
                json["collection"]!.map((x) => Collection.fromJson(x))),
      );
}

class Collection {
  final String? href;

  Collection({
    this.href,
  });
  factory Collection.fromJson(Map<String, dynamic> json) => Collection(
        href: json["href"],
      );
}
