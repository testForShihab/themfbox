class BlogDetailsResponse {
  int? articleId;
  String? title;
  String? content;
  String? photoName;
  int? viewedCount;
  String? authorName;
  String? createDate;

  BlogDetailsResponse(
      {this.articleId,
        this.title,
        this.content,
        this.photoName,
        this.viewedCount,
        this.authorName,
        this.createDate});

  BlogDetailsResponse.fromJson(Map<String, dynamic> json) {
    articleId = json['article_id'];
    title = json['title'];
    content = json['content'];
    photoName = json['photo_name'];
    viewedCount = json['viewed_count'];
    authorName = json['author_name'];
    createDate = json['create_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['article_id'] = this.articleId;
    data['title'] = this.title;
    data['content'] = this.content;
    data['photo_name'] = this.photoName;
    data['viewed_count'] = this.viewedCount;
    data['author_name'] = this.authorName;
    data['create_date'] = this.createDate;
    return data;
  }
}