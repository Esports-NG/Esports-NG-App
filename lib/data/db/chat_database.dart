import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

part 'chat_database.g.dart';

@DataClassName('Chat')
class Chats extends Table {
  TextColumn get slug => text()();
  TextColumn get name => text()();
  TextColumn get image => text().nullable()();
  TextColumn get type => text().nullable()();
  DateTimeColumn get updatedAt => dateTime().nullable()();
  TextColumn get username => text().nullable()();
  TextColumn get lastMessageSlug => text().nullable()();

  @override
  Set<Column> get primaryKey => {slug};
}

@DataClassName('Message')
class Messages extends Table {
  TextColumn get slug => text()();
  TextColumn get chatSlug => text()();
  TextColumn get content => text()();
  TextColumn get senderSlug => text().nullable()();
  TextColumn get senderName => text()();
  TextColumn get senderImage => text().nullable()();
  TextColumn get imageUrls => text().nullable()();

  DateTimeColumn get createdAt => dateTime()();
  BoolColumn get isRead => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {slug};
}

@DriftDatabase(tables: [Chats, Messages])
class ChatDatabase extends _$ChatDatabase {
  ChatDatabase._() : super(_openConnection());

  static ChatDatabase? _instance;
  static ChatDatabase get instance {
    _instance ??= ChatDatabase._();
    return _instance!;
  }

  @override
  int get schemaVersion => 3;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        await m.createAll();
      },
      onUpgrade: (Migrator m, int from, int to) async {
        if (from < 2) {
          // Add username column if upgrading from version 1
          await m.addColumn(chats, chats.username);
        }

        if (from < 3) {
          // Add senderSlug column if upgrading from version 2 or earlier
          await m.addColumn(messages, messages.senderSlug);
        }
      },
    );
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File(p.join(dir.path, 'chat.db'));
    return NativeDatabase(file);
  });
}

extension ChatDao on ChatDatabase {
  // Helper method to reset database (useful during development)
  static Future<void> resetDatabase() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File(p.join(dir.path, 'chat.db'));
    if (await file.exists()) {
      await file.delete();
    }
  }

  // Insert or update a chat
  Future<void> insertChat(Chat chat) async {
    try {
      await into(chats).insertOnConflictUpdate(chat);
    } catch (e) {
      print('Error inserting chat: $e');
      rethrow;
    }
  }

  // Insert multiple chats (bulk insert from API)
  Future<void> insertChats(List<Chat> chatList) async {
    try {
      await batch((batch) {
        batch.insertAllOnConflictUpdate(chats, chatList);
      });
    } catch (e) {
      print('Error inserting chats: $e');
      rethrow;
    }
  }

  Future<void> insertMessages(List<Message> messageList) async {
    try {
      await batch((batch) {
        batch.insertAllOnConflictUpdate(messages, messageList);
      });
    } catch (e) {
      print('Error inserting messages: $e');
      rethrow;
    }
  }

  Future<void> insertMessage(Message message) async {
    try {
      await into(messages).insertOnConflictUpdate(message);
    } catch (e) {
      print('Error inserting message: $e');
      rethrow;
    }
  }

  Future<Chat> getChat(String slug) async {
    return (select(chats)..where((c) => c.slug.equals(slug))).getSingle();
  }

  Future<Message> getMessage(String slug) async {
    return (select(messages)..where((m) => m.slug.equals(slug))).getSingle();
  }

  // Watch chats reactively (auto-updates UI)
  Stream<List<Chat>> watchChats() {
    return (select(chats)..orderBy([(m) => OrderingTerm.asc(m.updatedAt)]))
        .watch();
  }

  Stream<List<Message>> watchMessages(String slug) {
    return (select(messages)
          ..where((m) => m.chatSlug.equals(slug))
          ..orderBy([(m) => OrderingTerm.asc(m.createdAt)]))
        .watch();
  }
}
