/// id : ""
/// creationDate : ""
/// title : ""
/// content : ""
/// author : ""
/// tags : [""]

class Note {
  Note({
    String title = '',
    String content = '',
    String? author,
    List<String>? tags,
  }) {
    _id = DateTime.now().toString();
    _creationDate = DateTime.now().toString();
    _title = title;
    _content = content;
    _author = author;
    _tags = tags;
  }

  Note.fromJson(dynamic json) {
    _id = json['id'];
    _creationDate = json['creationDate'];
    _title = json['title'];
    _content = json['content'];
    _author = json['author'];
    _tags = json['tags'] != null ? json['tags'].cast<String>() : [];
  }
  late String _id;
  late String _creationDate;
  String _title = '';
  String _content = '';
  String? _author;
  List<String>? _tags;
  Note copyWith({
    String? id,
    String? creationDate,
    String? title,
    String? content,
    String? author,
    List<String>? tags,
  }) =>
      Note(
        title: title ?? _title,
        content: content ?? _content,
        author: author ?? _author,
        tags: tags ?? _tags,
      );
  String get id => _id;
  String get creationDate => _creationDate;
  String get title => _title;
  String get content => _content;
  String? get author => _author;
  List<String>? get tags => _tags;

  set title(String value) {
    _title = value;
  }

  set content(String value) {
    _content = value;
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['creationDate'] = _creationDate;
    map['title'] = _title;
    map['content'] = _content;
    map['author'] = _author;
    map['tags'] = _tags;
    return map;
  }
}
