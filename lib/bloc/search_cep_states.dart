abstract class ISearchCepStatus {}

class SearchCepSuccess implements ISearchCepStatus {
  final Map data;

  SearchCepSuccess(this.data);
}

class SearchCepLoading implements ISearchCepStatus {
  const SearchCepLoading();
}

class SearchCepError implements ISearchCepStatus {
  final String message;

  SearchCepError(this.message);
}
