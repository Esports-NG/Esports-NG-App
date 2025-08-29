// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_database.dart';

// ignore_for_file: type=lint
class $ChatsTable extends Chats with TableInfo<$ChatsTable, Chat> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ChatsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _slugMeta = const VerificationMeta('slug');
  @override
  late final GeneratedColumn<String> slug = GeneratedColumn<String>(
      'slug', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _imageMeta = const VerificationMeta('image');
  @override
  late final GeneratedColumn<String> image = GeneratedColumn<String>(
      'image', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
      'type', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _usernameMeta =
      const VerificationMeta('username');
  @override
  late final GeneratedColumn<String> username = GeneratedColumn<String>(
      'username', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _lastMessageSlugMeta =
      const VerificationMeta('lastMessageSlug');
  @override
  late final GeneratedColumn<String> lastMessageSlug = GeneratedColumn<String>(
      'last_message_slug', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [slug, name, image, type, updatedAt, username, lastMessageSlug];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'chats';
  @override
  VerificationContext validateIntegrity(Insertable<Chat> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('slug')) {
      context.handle(
          _slugMeta, slug.isAcceptableOrUnknown(data['slug']!, _slugMeta));
    } else if (isInserting) {
      context.missing(_slugMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('image')) {
      context.handle(
          _imageMeta, image.isAcceptableOrUnknown(data['image']!, _imageMeta));
    }
    if (data.containsKey('type')) {
      context.handle(
          _typeMeta, type.isAcceptableOrUnknown(data['type']!, _typeMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    if (data.containsKey('username')) {
      context.handle(_usernameMeta,
          username.isAcceptableOrUnknown(data['username']!, _usernameMeta));
    }
    if (data.containsKey('last_message_slug')) {
      context.handle(
          _lastMessageSlugMeta,
          lastMessageSlug.isAcceptableOrUnknown(
              data['last_message_slug']!, _lastMessageSlugMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {slug};
  @override
  Chat map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Chat(
      slug: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}slug'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      image: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}image']),
      type: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}type']),
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at']),
      username: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}username']),
      lastMessageSlug: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}last_message_slug']),
    );
  }

  @override
  $ChatsTable createAlias(String alias) {
    return $ChatsTable(attachedDatabase, alias);
  }
}

class Chat extends DataClass implements Insertable<Chat> {
  final String slug;
  final String name;
  final String? image;
  final String? type;
  final DateTime? updatedAt;
  final String? username;
  final String? lastMessageSlug;
  const Chat(
      {required this.slug,
      required this.name,
      this.image,
      this.type,
      this.updatedAt,
      this.username,
      this.lastMessageSlug});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['slug'] = Variable<String>(slug);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || image != null) {
      map['image'] = Variable<String>(image);
    }
    if (!nullToAbsent || type != null) {
      map['type'] = Variable<String>(type);
    }
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<DateTime>(updatedAt);
    }
    if (!nullToAbsent || username != null) {
      map['username'] = Variable<String>(username);
    }
    if (!nullToAbsent || lastMessageSlug != null) {
      map['last_message_slug'] = Variable<String>(lastMessageSlug);
    }
    return map;
  }

  ChatsCompanion toCompanion(bool nullToAbsent) {
    return ChatsCompanion(
      slug: Value(slug),
      name: Value(name),
      image:
          image == null && nullToAbsent ? const Value.absent() : Value(image),
      type: type == null && nullToAbsent ? const Value.absent() : Value(type),
      updatedAt: updatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAt),
      username: username == null && nullToAbsent
          ? const Value.absent()
          : Value(username),
      lastMessageSlug: lastMessageSlug == null && nullToAbsent
          ? const Value.absent()
          : Value(lastMessageSlug),
    );
  }

  factory Chat.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Chat(
      slug: serializer.fromJson<String>(json['slug']),
      name: serializer.fromJson<String>(json['name']),
      image: serializer.fromJson<String?>(json['image']),
      type: serializer.fromJson<String?>(json['type']),
      updatedAt: serializer.fromJson<DateTime?>(json['updatedAt']),
      username: serializer.fromJson<String?>(json['username']),
      lastMessageSlug: serializer.fromJson<String?>(json['lastMessageSlug']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'slug': serializer.toJson<String>(slug),
      'name': serializer.toJson<String>(name),
      'image': serializer.toJson<String?>(image),
      'type': serializer.toJson<String?>(type),
      'updatedAt': serializer.toJson<DateTime?>(updatedAt),
      'username': serializer.toJson<String?>(username),
      'lastMessageSlug': serializer.toJson<String?>(lastMessageSlug),
    };
  }

  Chat copyWith(
          {String? slug,
          String? name,
          Value<String?> image = const Value.absent(),
          Value<String?> type = const Value.absent(),
          Value<DateTime?> updatedAt = const Value.absent(),
          Value<String?> username = const Value.absent(),
          Value<String?> lastMessageSlug = const Value.absent()}) =>
      Chat(
        slug: slug ?? this.slug,
        name: name ?? this.name,
        image: image.present ? image.value : this.image,
        type: type.present ? type.value : this.type,
        updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
        username: username.present ? username.value : this.username,
        lastMessageSlug: lastMessageSlug.present
            ? lastMessageSlug.value
            : this.lastMessageSlug,
      );
  Chat copyWithCompanion(ChatsCompanion data) {
    return Chat(
      slug: data.slug.present ? data.slug.value : this.slug,
      name: data.name.present ? data.name.value : this.name,
      image: data.image.present ? data.image.value : this.image,
      type: data.type.present ? data.type.value : this.type,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      username: data.username.present ? data.username.value : this.username,
      lastMessageSlug: data.lastMessageSlug.present
          ? data.lastMessageSlug.value
          : this.lastMessageSlug,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Chat(')
          ..write('slug: $slug, ')
          ..write('name: $name, ')
          ..write('image: $image, ')
          ..write('type: $type, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('username: $username, ')
          ..write('lastMessageSlug: $lastMessageSlug')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      slug, name, image, type, updatedAt, username, lastMessageSlug);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Chat &&
          other.slug == this.slug &&
          other.name == this.name &&
          other.image == this.image &&
          other.type == this.type &&
          other.updatedAt == this.updatedAt &&
          other.username == this.username &&
          other.lastMessageSlug == this.lastMessageSlug);
}

class ChatsCompanion extends UpdateCompanion<Chat> {
  final Value<String> slug;
  final Value<String> name;
  final Value<String?> image;
  final Value<String?> type;
  final Value<DateTime?> updatedAt;
  final Value<String?> username;
  final Value<String?> lastMessageSlug;
  final Value<int> rowid;
  const ChatsCompanion({
    this.slug = const Value.absent(),
    this.name = const Value.absent(),
    this.image = const Value.absent(),
    this.type = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.username = const Value.absent(),
    this.lastMessageSlug = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ChatsCompanion.insert({
    required String slug,
    required String name,
    this.image = const Value.absent(),
    this.type = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.username = const Value.absent(),
    this.lastMessageSlug = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : slug = Value(slug),
        name = Value(name);
  static Insertable<Chat> custom({
    Expression<String>? slug,
    Expression<String>? name,
    Expression<String>? image,
    Expression<String>? type,
    Expression<DateTime>? updatedAt,
    Expression<String>? username,
    Expression<String>? lastMessageSlug,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (slug != null) 'slug': slug,
      if (name != null) 'name': name,
      if (image != null) 'image': image,
      if (type != null) 'type': type,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (username != null) 'username': username,
      if (lastMessageSlug != null) 'last_message_slug': lastMessageSlug,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ChatsCompanion copyWith(
      {Value<String>? slug,
      Value<String>? name,
      Value<String?>? image,
      Value<String?>? type,
      Value<DateTime?>? updatedAt,
      Value<String?>? username,
      Value<String?>? lastMessageSlug,
      Value<int>? rowid}) {
    return ChatsCompanion(
      slug: slug ?? this.slug,
      name: name ?? this.name,
      image: image ?? this.image,
      type: type ?? this.type,
      updatedAt: updatedAt ?? this.updatedAt,
      username: username ?? this.username,
      lastMessageSlug: lastMessageSlug ?? this.lastMessageSlug,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (slug.present) {
      map['slug'] = Variable<String>(slug.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (image.present) {
      map['image'] = Variable<String>(image.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (username.present) {
      map['username'] = Variable<String>(username.value);
    }
    if (lastMessageSlug.present) {
      map['last_message_slug'] = Variable<String>(lastMessageSlug.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ChatsCompanion(')
          ..write('slug: $slug, ')
          ..write('name: $name, ')
          ..write('image: $image, ')
          ..write('type: $type, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('username: $username, ')
          ..write('lastMessageSlug: $lastMessageSlug, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $MessagesTable extends Messages with TableInfo<$MessagesTable, Message> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MessagesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _slugMeta = const VerificationMeta('slug');
  @override
  late final GeneratedColumn<String> slug = GeneratedColumn<String>(
      'slug', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _chatSlugMeta =
      const VerificationMeta('chatSlug');
  @override
  late final GeneratedColumn<String> chatSlug = GeneratedColumn<String>(
      'chat_slug', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _contentMeta =
      const VerificationMeta('content');
  @override
  late final GeneratedColumn<String> content = GeneratedColumn<String>(
      'content', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _senderSlugMeta =
      const VerificationMeta('senderSlug');
  @override
  late final GeneratedColumn<String> senderSlug = GeneratedColumn<String>(
      'sender_slug', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _senderNameMeta =
      const VerificationMeta('senderName');
  @override
  late final GeneratedColumn<String> senderName = GeneratedColumn<String>(
      'sender_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _senderImageMeta =
      const VerificationMeta('senderImage');
  @override
  late final GeneratedColumn<String> senderImage = GeneratedColumn<String>(
      'sender_image', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _imageUrlsMeta =
      const VerificationMeta('imageUrls');
  @override
  late final GeneratedColumn<String> imageUrls = GeneratedColumn<String>(
      'image_urls', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('sent'));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _isReadMeta = const VerificationMeta('isRead');
  @override
  late final GeneratedColumn<bool> isRead = GeneratedColumn<bool>(
      'is_read', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_read" IN (0, 1))'),
      defaultValue: const Constant(false));
  @override
  List<GeneratedColumn> get $columns => [
        slug,
        chatSlug,
        content,
        senderSlug,
        senderName,
        senderImage,
        imageUrls,
        status,
        createdAt,
        isRead
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'messages';
  @override
  VerificationContext validateIntegrity(Insertable<Message> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('slug')) {
      context.handle(
          _slugMeta, slug.isAcceptableOrUnknown(data['slug']!, _slugMeta));
    } else if (isInserting) {
      context.missing(_slugMeta);
    }
    if (data.containsKey('chat_slug')) {
      context.handle(_chatSlugMeta,
          chatSlug.isAcceptableOrUnknown(data['chat_slug']!, _chatSlugMeta));
    } else if (isInserting) {
      context.missing(_chatSlugMeta);
    }
    if (data.containsKey('content')) {
      context.handle(_contentMeta,
          content.isAcceptableOrUnknown(data['content']!, _contentMeta));
    } else if (isInserting) {
      context.missing(_contentMeta);
    }
    if (data.containsKey('sender_slug')) {
      context.handle(
          _senderSlugMeta,
          senderSlug.isAcceptableOrUnknown(
              data['sender_slug']!, _senderSlugMeta));
    }
    if (data.containsKey('sender_name')) {
      context.handle(
          _senderNameMeta,
          senderName.isAcceptableOrUnknown(
              data['sender_name']!, _senderNameMeta));
    } else if (isInserting) {
      context.missing(_senderNameMeta);
    }
    if (data.containsKey('sender_image')) {
      context.handle(
          _senderImageMeta,
          senderImage.isAcceptableOrUnknown(
              data['sender_image']!, _senderImageMeta));
    }
    if (data.containsKey('image_urls')) {
      context.handle(_imageUrlsMeta,
          imageUrls.isAcceptableOrUnknown(data['image_urls']!, _imageUrlsMeta));
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('is_read')) {
      context.handle(_isReadMeta,
          isRead.isAcceptableOrUnknown(data['is_read']!, _isReadMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {slug};
  @override
  Message map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Message(
      slug: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}slug'])!,
      chatSlug: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}chat_slug'])!,
      content: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}content'])!,
      senderSlug: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}sender_slug']),
      senderName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}sender_name'])!,
      senderImage: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}sender_image']),
      imageUrls: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}image_urls']),
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      isRead: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_read'])!,
    );
  }

  @override
  $MessagesTable createAlias(String alias) {
    return $MessagesTable(attachedDatabase, alias);
  }
}

class Message extends DataClass implements Insertable<Message> {
  final String slug;
  final String chatSlug;
  final String content;
  final String? senderSlug;
  final String senderName;
  final String? senderImage;
  final String? imageUrls;
  final String status;
  final DateTime createdAt;
  final bool isRead;
  const Message(
      {required this.slug,
      required this.chatSlug,
      required this.content,
      this.senderSlug,
      required this.senderName,
      this.senderImage,
      this.imageUrls,
      required this.status,
      required this.createdAt,
      required this.isRead});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['slug'] = Variable<String>(slug);
    map['chat_slug'] = Variable<String>(chatSlug);
    map['content'] = Variable<String>(content);
    if (!nullToAbsent || senderSlug != null) {
      map['sender_slug'] = Variable<String>(senderSlug);
    }
    map['sender_name'] = Variable<String>(senderName);
    if (!nullToAbsent || senderImage != null) {
      map['sender_image'] = Variable<String>(senderImage);
    }
    if (!nullToAbsent || imageUrls != null) {
      map['image_urls'] = Variable<String>(imageUrls);
    }
    map['status'] = Variable<String>(status);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['is_read'] = Variable<bool>(isRead);
    return map;
  }

  MessagesCompanion toCompanion(bool nullToAbsent) {
    return MessagesCompanion(
      slug: Value(slug),
      chatSlug: Value(chatSlug),
      content: Value(content),
      senderSlug: senderSlug == null && nullToAbsent
          ? const Value.absent()
          : Value(senderSlug),
      senderName: Value(senderName),
      senderImage: senderImage == null && nullToAbsent
          ? const Value.absent()
          : Value(senderImage),
      imageUrls: imageUrls == null && nullToAbsent
          ? const Value.absent()
          : Value(imageUrls),
      status: Value(status),
      createdAt: Value(createdAt),
      isRead: Value(isRead),
    );
  }

  factory Message.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Message(
      slug: serializer.fromJson<String>(json['slug']),
      chatSlug: serializer.fromJson<String>(json['chatSlug']),
      content: serializer.fromJson<String>(json['content']),
      senderSlug: serializer.fromJson<String?>(json['senderSlug']),
      senderName: serializer.fromJson<String>(json['senderName']),
      senderImage: serializer.fromJson<String?>(json['senderImage']),
      imageUrls: serializer.fromJson<String?>(json['imageUrls']),
      status: serializer.fromJson<String>(json['status']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      isRead: serializer.fromJson<bool>(json['isRead']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'slug': serializer.toJson<String>(slug),
      'chatSlug': serializer.toJson<String>(chatSlug),
      'content': serializer.toJson<String>(content),
      'senderSlug': serializer.toJson<String?>(senderSlug),
      'senderName': serializer.toJson<String>(senderName),
      'senderImage': serializer.toJson<String?>(senderImage),
      'imageUrls': serializer.toJson<String?>(imageUrls),
      'status': serializer.toJson<String>(status),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'isRead': serializer.toJson<bool>(isRead),
    };
  }

  Message copyWith(
          {String? slug,
          String? chatSlug,
          String? content,
          Value<String?> senderSlug = const Value.absent(),
          String? senderName,
          Value<String?> senderImage = const Value.absent(),
          Value<String?> imageUrls = const Value.absent(),
          String? status,
          DateTime? createdAt,
          bool? isRead}) =>
      Message(
        slug: slug ?? this.slug,
        chatSlug: chatSlug ?? this.chatSlug,
        content: content ?? this.content,
        senderSlug: senderSlug.present ? senderSlug.value : this.senderSlug,
        senderName: senderName ?? this.senderName,
        senderImage: senderImage.present ? senderImage.value : this.senderImage,
        imageUrls: imageUrls.present ? imageUrls.value : this.imageUrls,
        status: status ?? this.status,
        createdAt: createdAt ?? this.createdAt,
        isRead: isRead ?? this.isRead,
      );
  Message copyWithCompanion(MessagesCompanion data) {
    return Message(
      slug: data.slug.present ? data.slug.value : this.slug,
      chatSlug: data.chatSlug.present ? data.chatSlug.value : this.chatSlug,
      content: data.content.present ? data.content.value : this.content,
      senderSlug:
          data.senderSlug.present ? data.senderSlug.value : this.senderSlug,
      senderName:
          data.senderName.present ? data.senderName.value : this.senderName,
      senderImage:
          data.senderImage.present ? data.senderImage.value : this.senderImage,
      imageUrls: data.imageUrls.present ? data.imageUrls.value : this.imageUrls,
      status: data.status.present ? data.status.value : this.status,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      isRead: data.isRead.present ? data.isRead.value : this.isRead,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Message(')
          ..write('slug: $slug, ')
          ..write('chatSlug: $chatSlug, ')
          ..write('content: $content, ')
          ..write('senderSlug: $senderSlug, ')
          ..write('senderName: $senderName, ')
          ..write('senderImage: $senderImage, ')
          ..write('imageUrls: $imageUrls, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt, ')
          ..write('isRead: $isRead')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(slug, chatSlug, content, senderSlug,
      senderName, senderImage, imageUrls, status, createdAt, isRead);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Message &&
          other.slug == this.slug &&
          other.chatSlug == this.chatSlug &&
          other.content == this.content &&
          other.senderSlug == this.senderSlug &&
          other.senderName == this.senderName &&
          other.senderImage == this.senderImage &&
          other.imageUrls == this.imageUrls &&
          other.status == this.status &&
          other.createdAt == this.createdAt &&
          other.isRead == this.isRead);
}

class MessagesCompanion extends UpdateCompanion<Message> {
  final Value<String> slug;
  final Value<String> chatSlug;
  final Value<String> content;
  final Value<String?> senderSlug;
  final Value<String> senderName;
  final Value<String?> senderImage;
  final Value<String?> imageUrls;
  final Value<String> status;
  final Value<DateTime> createdAt;
  final Value<bool> isRead;
  final Value<int> rowid;
  const MessagesCompanion({
    this.slug = const Value.absent(),
    this.chatSlug = const Value.absent(),
    this.content = const Value.absent(),
    this.senderSlug = const Value.absent(),
    this.senderName = const Value.absent(),
    this.senderImage = const Value.absent(),
    this.imageUrls = const Value.absent(),
    this.status = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.isRead = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MessagesCompanion.insert({
    required String slug,
    required String chatSlug,
    required String content,
    this.senderSlug = const Value.absent(),
    required String senderName,
    this.senderImage = const Value.absent(),
    this.imageUrls = const Value.absent(),
    this.status = const Value.absent(),
    required DateTime createdAt,
    this.isRead = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : slug = Value(slug),
        chatSlug = Value(chatSlug),
        content = Value(content),
        senderName = Value(senderName),
        createdAt = Value(createdAt);
  static Insertable<Message> custom({
    Expression<String>? slug,
    Expression<String>? chatSlug,
    Expression<String>? content,
    Expression<String>? senderSlug,
    Expression<String>? senderName,
    Expression<String>? senderImage,
    Expression<String>? imageUrls,
    Expression<String>? status,
    Expression<DateTime>? createdAt,
    Expression<bool>? isRead,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (slug != null) 'slug': slug,
      if (chatSlug != null) 'chat_slug': chatSlug,
      if (content != null) 'content': content,
      if (senderSlug != null) 'sender_slug': senderSlug,
      if (senderName != null) 'sender_name': senderName,
      if (senderImage != null) 'sender_image': senderImage,
      if (imageUrls != null) 'image_urls': imageUrls,
      if (status != null) 'status': status,
      if (createdAt != null) 'created_at': createdAt,
      if (isRead != null) 'is_read': isRead,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MessagesCompanion copyWith(
      {Value<String>? slug,
      Value<String>? chatSlug,
      Value<String>? content,
      Value<String?>? senderSlug,
      Value<String>? senderName,
      Value<String?>? senderImage,
      Value<String?>? imageUrls,
      Value<String>? status,
      Value<DateTime>? createdAt,
      Value<bool>? isRead,
      Value<int>? rowid}) {
    return MessagesCompanion(
      slug: slug ?? this.slug,
      chatSlug: chatSlug ?? this.chatSlug,
      content: content ?? this.content,
      senderSlug: senderSlug ?? this.senderSlug,
      senderName: senderName ?? this.senderName,
      senderImage: senderImage ?? this.senderImage,
      imageUrls: imageUrls ?? this.imageUrls,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      isRead: isRead ?? this.isRead,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (slug.present) {
      map['slug'] = Variable<String>(slug.value);
    }
    if (chatSlug.present) {
      map['chat_slug'] = Variable<String>(chatSlug.value);
    }
    if (content.present) {
      map['content'] = Variable<String>(content.value);
    }
    if (senderSlug.present) {
      map['sender_slug'] = Variable<String>(senderSlug.value);
    }
    if (senderName.present) {
      map['sender_name'] = Variable<String>(senderName.value);
    }
    if (senderImage.present) {
      map['sender_image'] = Variable<String>(senderImage.value);
    }
    if (imageUrls.present) {
      map['image_urls'] = Variable<String>(imageUrls.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (isRead.present) {
      map['is_read'] = Variable<bool>(isRead.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MessagesCompanion(')
          ..write('slug: $slug, ')
          ..write('chatSlug: $chatSlug, ')
          ..write('content: $content, ')
          ..write('senderSlug: $senderSlug, ')
          ..write('senderName: $senderName, ')
          ..write('senderImage: $senderImage, ')
          ..write('imageUrls: $imageUrls, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt, ')
          ..write('isRead: $isRead, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$ChatDatabase extends GeneratedDatabase {
  _$ChatDatabase(QueryExecutor e) : super(e);
  $ChatDatabaseManager get managers => $ChatDatabaseManager(this);
  late final $ChatsTable chats = $ChatsTable(this);
  late final $MessagesTable messages = $MessagesTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [chats, messages];
}

typedef $$ChatsTableCreateCompanionBuilder = ChatsCompanion Function({
  required String slug,
  required String name,
  Value<String?> image,
  Value<String?> type,
  Value<DateTime?> updatedAt,
  Value<String?> username,
  Value<String?> lastMessageSlug,
  Value<int> rowid,
});
typedef $$ChatsTableUpdateCompanionBuilder = ChatsCompanion Function({
  Value<String> slug,
  Value<String> name,
  Value<String?> image,
  Value<String?> type,
  Value<DateTime?> updatedAt,
  Value<String?> username,
  Value<String?> lastMessageSlug,
  Value<int> rowid,
});

class $$ChatsTableFilterComposer extends Composer<_$ChatDatabase, $ChatsTable> {
  $$ChatsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get slug => $composableBuilder(
      column: $table.slug, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get image => $composableBuilder(
      column: $table.image, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get username => $composableBuilder(
      column: $table.username, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get lastMessageSlug => $composableBuilder(
      column: $table.lastMessageSlug,
      builder: (column) => ColumnFilters(column));
}

class $$ChatsTableOrderingComposer
    extends Composer<_$ChatDatabase, $ChatsTable> {
  $$ChatsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get slug => $composableBuilder(
      column: $table.slug, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get image => $composableBuilder(
      column: $table.image, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get username => $composableBuilder(
      column: $table.username, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get lastMessageSlug => $composableBuilder(
      column: $table.lastMessageSlug,
      builder: (column) => ColumnOrderings(column));
}

class $$ChatsTableAnnotationComposer
    extends Composer<_$ChatDatabase, $ChatsTable> {
  $$ChatsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get slug =>
      $composableBuilder(column: $table.slug, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get image =>
      $composableBuilder(column: $table.image, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<String> get username =>
      $composableBuilder(column: $table.username, builder: (column) => column);

  GeneratedColumn<String> get lastMessageSlug => $composableBuilder(
      column: $table.lastMessageSlug, builder: (column) => column);
}

class $$ChatsTableTableManager extends RootTableManager<
    _$ChatDatabase,
    $ChatsTable,
    Chat,
    $$ChatsTableFilterComposer,
    $$ChatsTableOrderingComposer,
    $$ChatsTableAnnotationComposer,
    $$ChatsTableCreateCompanionBuilder,
    $$ChatsTableUpdateCompanionBuilder,
    (Chat, BaseReferences<_$ChatDatabase, $ChatsTable, Chat>),
    Chat,
    PrefetchHooks Function()> {
  $$ChatsTableTableManager(_$ChatDatabase db, $ChatsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ChatsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ChatsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ChatsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> slug = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String?> image = const Value.absent(),
            Value<String?> type = const Value.absent(),
            Value<DateTime?> updatedAt = const Value.absent(),
            Value<String?> username = const Value.absent(),
            Value<String?> lastMessageSlug = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ChatsCompanion(
            slug: slug,
            name: name,
            image: image,
            type: type,
            updatedAt: updatedAt,
            username: username,
            lastMessageSlug: lastMessageSlug,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String slug,
            required String name,
            Value<String?> image = const Value.absent(),
            Value<String?> type = const Value.absent(),
            Value<DateTime?> updatedAt = const Value.absent(),
            Value<String?> username = const Value.absent(),
            Value<String?> lastMessageSlug = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ChatsCompanion.insert(
            slug: slug,
            name: name,
            image: image,
            type: type,
            updatedAt: updatedAt,
            username: username,
            lastMessageSlug: lastMessageSlug,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$ChatsTableProcessedTableManager = ProcessedTableManager<
    _$ChatDatabase,
    $ChatsTable,
    Chat,
    $$ChatsTableFilterComposer,
    $$ChatsTableOrderingComposer,
    $$ChatsTableAnnotationComposer,
    $$ChatsTableCreateCompanionBuilder,
    $$ChatsTableUpdateCompanionBuilder,
    (Chat, BaseReferences<_$ChatDatabase, $ChatsTable, Chat>),
    Chat,
    PrefetchHooks Function()>;
typedef $$MessagesTableCreateCompanionBuilder = MessagesCompanion Function({
  required String slug,
  required String chatSlug,
  required String content,
  Value<String?> senderSlug,
  required String senderName,
  Value<String?> senderImage,
  Value<String?> imageUrls,
  Value<String> status,
  required DateTime createdAt,
  Value<bool> isRead,
  Value<int> rowid,
});
typedef $$MessagesTableUpdateCompanionBuilder = MessagesCompanion Function({
  Value<String> slug,
  Value<String> chatSlug,
  Value<String> content,
  Value<String?> senderSlug,
  Value<String> senderName,
  Value<String?> senderImage,
  Value<String?> imageUrls,
  Value<String> status,
  Value<DateTime> createdAt,
  Value<bool> isRead,
  Value<int> rowid,
});

class $$MessagesTableFilterComposer
    extends Composer<_$ChatDatabase, $MessagesTable> {
  $$MessagesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get slug => $composableBuilder(
      column: $table.slug, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get chatSlug => $composableBuilder(
      column: $table.chatSlug, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get content => $composableBuilder(
      column: $table.content, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get senderSlug => $composableBuilder(
      column: $table.senderSlug, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get senderName => $composableBuilder(
      column: $table.senderName, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get senderImage => $composableBuilder(
      column: $table.senderImage, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get imageUrls => $composableBuilder(
      column: $table.imageUrls, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isRead => $composableBuilder(
      column: $table.isRead, builder: (column) => ColumnFilters(column));
}

class $$MessagesTableOrderingComposer
    extends Composer<_$ChatDatabase, $MessagesTable> {
  $$MessagesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get slug => $composableBuilder(
      column: $table.slug, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get chatSlug => $composableBuilder(
      column: $table.chatSlug, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get content => $composableBuilder(
      column: $table.content, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get senderSlug => $composableBuilder(
      column: $table.senderSlug, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get senderName => $composableBuilder(
      column: $table.senderName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get senderImage => $composableBuilder(
      column: $table.senderImage, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get imageUrls => $composableBuilder(
      column: $table.imageUrls, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isRead => $composableBuilder(
      column: $table.isRead, builder: (column) => ColumnOrderings(column));
}

class $$MessagesTableAnnotationComposer
    extends Composer<_$ChatDatabase, $MessagesTable> {
  $$MessagesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get slug =>
      $composableBuilder(column: $table.slug, builder: (column) => column);

  GeneratedColumn<String> get chatSlug =>
      $composableBuilder(column: $table.chatSlug, builder: (column) => column);

  GeneratedColumn<String> get content =>
      $composableBuilder(column: $table.content, builder: (column) => column);

  GeneratedColumn<String> get senderSlug => $composableBuilder(
      column: $table.senderSlug, builder: (column) => column);

  GeneratedColumn<String> get senderName => $composableBuilder(
      column: $table.senderName, builder: (column) => column);

  GeneratedColumn<String> get senderImage => $composableBuilder(
      column: $table.senderImage, builder: (column) => column);

  GeneratedColumn<String> get imageUrls =>
      $composableBuilder(column: $table.imageUrls, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<bool> get isRead =>
      $composableBuilder(column: $table.isRead, builder: (column) => column);
}

class $$MessagesTableTableManager extends RootTableManager<
    _$ChatDatabase,
    $MessagesTable,
    Message,
    $$MessagesTableFilterComposer,
    $$MessagesTableOrderingComposer,
    $$MessagesTableAnnotationComposer,
    $$MessagesTableCreateCompanionBuilder,
    $$MessagesTableUpdateCompanionBuilder,
    (Message, BaseReferences<_$ChatDatabase, $MessagesTable, Message>),
    Message,
    PrefetchHooks Function()> {
  $$MessagesTableTableManager(_$ChatDatabase db, $MessagesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MessagesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MessagesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MessagesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> slug = const Value.absent(),
            Value<String> chatSlug = const Value.absent(),
            Value<String> content = const Value.absent(),
            Value<String?> senderSlug = const Value.absent(),
            Value<String> senderName = const Value.absent(),
            Value<String?> senderImage = const Value.absent(),
            Value<String?> imageUrls = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<bool> isRead = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              MessagesCompanion(
            slug: slug,
            chatSlug: chatSlug,
            content: content,
            senderSlug: senderSlug,
            senderName: senderName,
            senderImage: senderImage,
            imageUrls: imageUrls,
            status: status,
            createdAt: createdAt,
            isRead: isRead,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String slug,
            required String chatSlug,
            required String content,
            Value<String?> senderSlug = const Value.absent(),
            required String senderName,
            Value<String?> senderImage = const Value.absent(),
            Value<String?> imageUrls = const Value.absent(),
            Value<String> status = const Value.absent(),
            required DateTime createdAt,
            Value<bool> isRead = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              MessagesCompanion.insert(
            slug: slug,
            chatSlug: chatSlug,
            content: content,
            senderSlug: senderSlug,
            senderName: senderName,
            senderImage: senderImage,
            imageUrls: imageUrls,
            status: status,
            createdAt: createdAt,
            isRead: isRead,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$MessagesTableProcessedTableManager = ProcessedTableManager<
    _$ChatDatabase,
    $MessagesTable,
    Message,
    $$MessagesTableFilterComposer,
    $$MessagesTableOrderingComposer,
    $$MessagesTableAnnotationComposer,
    $$MessagesTableCreateCompanionBuilder,
    $$MessagesTableUpdateCompanionBuilder,
    (Message, BaseReferences<_$ChatDatabase, $MessagesTable, Message>),
    Message,
    PrefetchHooks Function()>;

class $ChatDatabaseManager {
  final _$ChatDatabase _db;
  $ChatDatabaseManager(this._db);
  $$ChatsTableTableManager get chats =>
      $$ChatsTableTableManager(_db, _db.chats);
  $$MessagesTableTableManager get messages =>
      $$MessagesTableTableManager(_db, _db.messages);
}
