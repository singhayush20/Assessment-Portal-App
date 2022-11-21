class CategoryModel {
  int? _categoryId;
  String _categoryTitle;
  String _categoryDescp;

  CategoryModel(this._categoryId, this._categoryTitle, this._categoryDescp);
  CategoryModel.createCategory(this._categoryTitle, this._categoryDescp);

  String get categoryDescp => _categoryDescp;

  String get categoryTitle => _categoryTitle;

  int get categoryId => _categoryId ?? -1;

  set categoryDescp(String value) {
    _categoryDescp = value;
  }

  set categoryTitle(String value) {
    _categoryTitle = value;
  }

  set categoryId(int value) {
    _categoryId = value;
  }

  @override
  String toString() {
    return 'CategoryModel{_categoryId: $_categoryId, _categoryTitle: $_categoryTitle, _categoryDescp: $_categoryDescp}';
  }
}
