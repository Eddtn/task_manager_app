// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_database.dart';

// ignore_for_file: type=lint
class $TasksTableTable extends TasksTable
    with TableInfo<$TasksTableTable, TasksTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TasksTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _dueDateMeta =
      const VerificationMeta('dueDate');
  @override
  late final GeneratedColumn<DateTime> dueDate = GeneratedColumn<DateTime>(
      'due_date', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  late final GeneratedColumnWithTypeConverter<Priority, int> priority =
      GeneratedColumn<int>('priority', aliasedName, false,
              type: DriftSqlType.int, requiredDuringInsert: true)
          .withConverter<Priority>($TasksTableTable.$converterpriority);
  static const VerificationMeta _isCompletedMeta =
      const VerificationMeta('isCompleted');
  @override
  late final GeneratedColumn<bool> isCompleted = GeneratedColumn<bool>(
      'is_completed', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("is_completed" IN (0, 1))'));
  @override
  late final GeneratedColumnWithTypeConverter<List<String>, String> tags =
      GeneratedColumn<String>('tags', aliasedName, false,
              type: DriftSqlType.string, requiredDuringInsert: true)
          .withConverter<List<String>>($TasksTableTable.$convertertags);
  @override
  List<GeneratedColumn> get $columns =>
      [id, title, description, createdAt, dueDate, priority, isCompleted, tags];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'tasks_table';
  @override
  VerificationContext validateIntegrity(Insertable<TasksTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('due_date')) {
      context.handle(_dueDateMeta,
          dueDate.isAcceptableOrUnknown(data['due_date']!, _dueDateMeta));
    }
    if (data.containsKey('is_completed')) {
      context.handle(
          _isCompletedMeta,
          isCompleted.isAcceptableOrUnknown(
              data['is_completed']!, _isCompletedMeta));
    } else if (isInserting) {
      context.missing(_isCompletedMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TasksTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TasksTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      dueDate: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}due_date']),
      priority: $TasksTableTable.$converterpriority.fromSql(attachedDatabase
          .typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}priority'])!),
      isCompleted: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_completed'])!,
      tags: $TasksTableTable.$convertertags.fromSql(attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}tags'])!),
    );
  }

  @override
  $TasksTableTable createAlias(String alias) {
    return $TasksTableTable(attachedDatabase, alias);
  }

  static TypeConverter<Priority, int> $converterpriority =
      const PriorityConverter();
  static TypeConverter<List<String>, String> $convertertags =
      const TagsConverter();
}

class TasksTableData extends DataClass implements Insertable<TasksTableData> {
  final String id;
  final String title;
  final String? description;
  final DateTime createdAt;
  final DateTime? dueDate;
  final Priority priority;
  final bool isCompleted;
  final List<String> tags;
  const TasksTableData(
      {required this.id,
      required this.title,
      this.description,
      required this.createdAt,
      this.dueDate,
      required this.priority,
      required this.isCompleted,
      required this.tags});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['title'] = Variable<String>(title);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || dueDate != null) {
      map['due_date'] = Variable<DateTime>(dueDate);
    }
    {
      map['priority'] =
          Variable<int>($TasksTableTable.$converterpriority.toSql(priority));
    }
    map['is_completed'] = Variable<bool>(isCompleted);
    {
      map['tags'] =
          Variable<String>($TasksTableTable.$convertertags.toSql(tags));
    }
    return map;
  }

  TasksTableCompanion toCompanion(bool nullToAbsent) {
    return TasksTableCompanion(
      id: Value(id),
      title: Value(title),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      createdAt: Value(createdAt),
      dueDate: dueDate == null && nullToAbsent
          ? const Value.absent()
          : Value(dueDate),
      priority: Value(priority),
      isCompleted: Value(isCompleted),
      tags: Value(tags),
    );
  }

  factory TasksTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TasksTableData(
      id: serializer.fromJson<String>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      description: serializer.fromJson<String?>(json['description']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      dueDate: serializer.fromJson<DateTime?>(json['dueDate']),
      priority: serializer.fromJson<Priority>(json['priority']),
      isCompleted: serializer.fromJson<bool>(json['isCompleted']),
      tags: serializer.fromJson<List<String>>(json['tags']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'title': serializer.toJson<String>(title),
      'description': serializer.toJson<String?>(description),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'dueDate': serializer.toJson<DateTime?>(dueDate),
      'priority': serializer.toJson<Priority>(priority),
      'isCompleted': serializer.toJson<bool>(isCompleted),
      'tags': serializer.toJson<List<String>>(tags),
    };
  }

  TasksTableData copyWith(
          {String? id,
          String? title,
          Value<String?> description = const Value.absent(),
          DateTime? createdAt,
          Value<DateTime?> dueDate = const Value.absent(),
          Priority? priority,
          bool? isCompleted,
          List<String>? tags}) =>
      TasksTableData(
        id: id ?? this.id,
        title: title ?? this.title,
        description: description.present ? description.value : this.description,
        createdAt: createdAt ?? this.createdAt,
        dueDate: dueDate.present ? dueDate.value : this.dueDate,
        priority: priority ?? this.priority,
        isCompleted: isCompleted ?? this.isCompleted,
        tags: tags ?? this.tags,
      );
  TasksTableData copyWithCompanion(TasksTableCompanion data) {
    return TasksTableData(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      description:
          data.description.present ? data.description.value : this.description,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      dueDate: data.dueDate.present ? data.dueDate.value : this.dueDate,
      priority: data.priority.present ? data.priority.value : this.priority,
      isCompleted:
          data.isCompleted.present ? data.isCompleted.value : this.isCompleted,
      tags: data.tags.present ? data.tags.value : this.tags,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TasksTableData(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('createdAt: $createdAt, ')
          ..write('dueDate: $dueDate, ')
          ..write('priority: $priority, ')
          ..write('isCompleted: $isCompleted, ')
          ..write('tags: $tags')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, title, description, createdAt, dueDate, priority, isCompleted, tags);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TasksTableData &&
          other.id == this.id &&
          other.title == this.title &&
          other.description == this.description &&
          other.createdAt == this.createdAt &&
          other.dueDate == this.dueDate &&
          other.priority == this.priority &&
          other.isCompleted == this.isCompleted &&
          other.tags == this.tags);
}

class TasksTableCompanion extends UpdateCompanion<TasksTableData> {
  final Value<String> id;
  final Value<String> title;
  final Value<String?> description;
  final Value<DateTime> createdAt;
  final Value<DateTime?> dueDate;
  final Value<Priority> priority;
  final Value<bool> isCompleted;
  final Value<List<String>> tags;
  final Value<int> rowid;
  const TasksTableCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.description = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.dueDate = const Value.absent(),
    this.priority = const Value.absent(),
    this.isCompleted = const Value.absent(),
    this.tags = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TasksTableCompanion.insert({
    required String id,
    required String title,
    this.description = const Value.absent(),
    required DateTime createdAt,
    this.dueDate = const Value.absent(),
    required Priority priority,
    required bool isCompleted,
    required List<String> tags,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        title = Value(title),
        createdAt = Value(createdAt),
        priority = Value(priority),
        isCompleted = Value(isCompleted),
        tags = Value(tags);
  static Insertable<TasksTableData> custom({
    Expression<String>? id,
    Expression<String>? title,
    Expression<String>? description,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? dueDate,
    Expression<int>? priority,
    Expression<bool>? isCompleted,
    Expression<String>? tags,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (description != null) 'description': description,
      if (createdAt != null) 'created_at': createdAt,
      if (dueDate != null) 'due_date': dueDate,
      if (priority != null) 'priority': priority,
      if (isCompleted != null) 'is_completed': isCompleted,
      if (tags != null) 'tags': tags,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TasksTableCompanion copyWith(
      {Value<String>? id,
      Value<String>? title,
      Value<String?>? description,
      Value<DateTime>? createdAt,
      Value<DateTime?>? dueDate,
      Value<Priority>? priority,
      Value<bool>? isCompleted,
      Value<List<String>>? tags,
      Value<int>? rowid}) {
    return TasksTableCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      dueDate: dueDate ?? this.dueDate,
      priority: priority ?? this.priority,
      isCompleted: isCompleted ?? this.isCompleted,
      tags: tags ?? this.tags,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (dueDate.present) {
      map['due_date'] = Variable<DateTime>(dueDate.value);
    }
    if (priority.present) {
      map['priority'] = Variable<int>(
          $TasksTableTable.$converterpriority.toSql(priority.value));
    }
    if (isCompleted.present) {
      map['is_completed'] = Variable<bool>(isCompleted.value);
    }
    if (tags.present) {
      map['tags'] =
          Variable<String>($TasksTableTable.$convertertags.toSql(tags.value));
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TasksTableCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('createdAt: $createdAt, ')
          ..write('dueDate: $dueDate, ')
          ..write('priority: $priority, ')
          ..write('isCompleted: $isCompleted, ')
          ..write('tags: $tags, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$TaskDatabase extends GeneratedDatabase {
  _$TaskDatabase(QueryExecutor e) : super(e);
  $TaskDatabaseManager get managers => $TaskDatabaseManager(this);
  late final $TasksTableTable tasksTable = $TasksTableTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [tasksTable];
}

typedef $$TasksTableTableCreateCompanionBuilder = TasksTableCompanion Function({
  required String id,
  required String title,
  Value<String?> description,
  required DateTime createdAt,
  Value<DateTime?> dueDate,
  required Priority priority,
  required bool isCompleted,
  required List<String> tags,
  Value<int> rowid,
});
typedef $$TasksTableTableUpdateCompanionBuilder = TasksTableCompanion Function({
  Value<String> id,
  Value<String> title,
  Value<String?> description,
  Value<DateTime> createdAt,
  Value<DateTime?> dueDate,
  Value<Priority> priority,
  Value<bool> isCompleted,
  Value<List<String>> tags,
  Value<int> rowid,
});

class $$TasksTableTableFilterComposer
    extends Composer<_$TaskDatabase, $TasksTableTable> {
  $$TasksTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get dueDate => $composableBuilder(
      column: $table.dueDate, builder: (column) => ColumnFilters(column));

  ColumnWithTypeConverterFilters<Priority, Priority, int> get priority =>
      $composableBuilder(
          column: $table.priority,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnFilters<bool> get isCompleted => $composableBuilder(
      column: $table.isCompleted, builder: (column) => ColumnFilters(column));

  ColumnWithTypeConverterFilters<List<String>, List<String>, String> get tags =>
      $composableBuilder(
          column: $table.tags,
          builder: (column) => ColumnWithTypeConverterFilters(column));
}

class $$TasksTableTableOrderingComposer
    extends Composer<_$TaskDatabase, $TasksTableTable> {
  $$TasksTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get dueDate => $composableBuilder(
      column: $table.dueDate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get priority => $composableBuilder(
      column: $table.priority, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isCompleted => $composableBuilder(
      column: $table.isCompleted, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get tags => $composableBuilder(
      column: $table.tags, builder: (column) => ColumnOrderings(column));
}

class $$TasksTableTableAnnotationComposer
    extends Composer<_$TaskDatabase, $TasksTableTable> {
  $$TasksTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get dueDate =>
      $composableBuilder(column: $table.dueDate, builder: (column) => column);

  GeneratedColumnWithTypeConverter<Priority, int> get priority =>
      $composableBuilder(column: $table.priority, builder: (column) => column);

  GeneratedColumn<bool> get isCompleted => $composableBuilder(
      column: $table.isCompleted, builder: (column) => column);

  GeneratedColumnWithTypeConverter<List<String>, String> get tags =>
      $composableBuilder(column: $table.tags, builder: (column) => column);
}

class $$TasksTableTableTableManager extends RootTableManager<
    _$TaskDatabase,
    $TasksTableTable,
    TasksTableData,
    $$TasksTableTableFilterComposer,
    $$TasksTableTableOrderingComposer,
    $$TasksTableTableAnnotationComposer,
    $$TasksTableTableCreateCompanionBuilder,
    $$TasksTableTableUpdateCompanionBuilder,
    (
      TasksTableData,
      BaseReferences<_$TaskDatabase, $TasksTableTable, TasksTableData>
    ),
    TasksTableData,
    PrefetchHooks Function()> {
  $$TasksTableTableTableManager(_$TaskDatabase db, $TasksTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TasksTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TasksTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TasksTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> title = const Value.absent(),
            Value<String?> description = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime?> dueDate = const Value.absent(),
            Value<Priority> priority = const Value.absent(),
            Value<bool> isCompleted = const Value.absent(),
            Value<List<String>> tags = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              TasksTableCompanion(
            id: id,
            title: title,
            description: description,
            createdAt: createdAt,
            dueDate: dueDate,
            priority: priority,
            isCompleted: isCompleted,
            tags: tags,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String title,
            Value<String?> description = const Value.absent(),
            required DateTime createdAt,
            Value<DateTime?> dueDate = const Value.absent(),
            required Priority priority,
            required bool isCompleted,
            required List<String> tags,
            Value<int> rowid = const Value.absent(),
          }) =>
              TasksTableCompanion.insert(
            id: id,
            title: title,
            description: description,
            createdAt: createdAt,
            dueDate: dueDate,
            priority: priority,
            isCompleted: isCompleted,
            tags: tags,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$TasksTableTableProcessedTableManager = ProcessedTableManager<
    _$TaskDatabase,
    $TasksTableTable,
    TasksTableData,
    $$TasksTableTableFilterComposer,
    $$TasksTableTableOrderingComposer,
    $$TasksTableTableAnnotationComposer,
    $$TasksTableTableCreateCompanionBuilder,
    $$TasksTableTableUpdateCompanionBuilder,
    (
      TasksTableData,
      BaseReferences<_$TaskDatabase, $TasksTableTable, TasksTableData>
    ),
    TasksTableData,
    PrefetchHooks Function()>;

class $TaskDatabaseManager {
  final _$TaskDatabase _db;
  $TaskDatabaseManager(this._db);
  $$TasksTableTableTableManager get tasksTable =>
      $$TasksTableTableTableManager(_db, _db.tasksTable);
}
