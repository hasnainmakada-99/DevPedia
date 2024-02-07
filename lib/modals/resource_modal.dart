class ResourceModal {
  String? sId;
  String? title;
  String? url;
  String? description;
  String? thumbnail;
  String? publishedDate;
  String? channelName;
  String? tool;
  int? iV;

  ResourceModal(
      {this.sId,
      this.title,
      this.url,
      this.description,
      this.thumbnail,
      this.publishedDate,
      this.channelName,
      this.tool,
      this.iV});

  ResourceModal.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    title = json['title'];
    url = json['url'];
    description = json['description'];
    thumbnail = json['thumbnail'];
    publishedDate = json['publishedDate'];
    channelName = json['channelName'];
    tool = json['toolRelatedTo'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['_id'] = sId;
    data['title'] = title;
    data['url'] = url;
    data['description'] = description;
    data['thumbnail'] = thumbnail;
    data['publishedDate'] = publishedDate;
    data['channelName'] = channelName;
    data['tool'] = tool;
    data['__v'] = iV;
    return data;
  }
}
