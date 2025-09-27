import '../../../component/base/base_dio_datasource.dart';
import '../../../component/ext/dio_ext.dart';

class ProductsDatasource extends BaseDioDataSource {
  ProductsDatasource(super.client);

  Future<String> getProducts() {
    String path = '/products';

    return get<String>(path).load();
  }
}
