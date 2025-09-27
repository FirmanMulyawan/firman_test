import 'package:dio/dio.dart';

import '../../../component/base/base_repository.dart';
import '../../../component/model/response_model.dart';
import '../../../component/util/state.dart';
import '../model/products_response.dart';
import 'products_datasource.dart';

class ProductsRepository extends BaseRepository {
  final ProductsDatasource _dataSource;

  ProductsRepository(this._dataSource);

  Future<void> getListProducts(
      {required ResponseHandler<ListResponseModel<ProductsResponse>>
          response}) async {
    try {
      final data =
          await _dataSource.getProducts().then(mapToData).then((value) {
        return ListResponseModel<ProductsResponse>.fromList(value,
            (data) => data.map((e) => ProductsResponse.fromJson(e)).toList());
      });
      response.onSuccess.call(data);
      response.onDone.call();
    } on DioException catch (e) {
      handleDioException(e, response);
    } catch (e) {
      response.onFailed(0, e.toString());
      response.onDone.call();
    }
  }
}
