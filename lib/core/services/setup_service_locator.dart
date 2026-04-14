import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import '../../Features/Home/data/data_sources/home_local_datasource.dart';
import '../../Features/Home/data/data_sources/home_remoute_data_source.dart';
import '../../Features/Home/data/repos/home_repo_impl.dart';
import 'api_service.dart';
final getIt = GetIt.instance;

void setupServiceLocator() {
  getIt.registerSingleton<ApiService>(ApiService(Dio()));
  getIt.registerSingleton<HomeRepoImpl>(
    HomeRepoImpl(
      homeLocalDataSource: HomeLocalDataSourceImpl(),
      homeRemouteDataSource: HomeReouteDataSourceImpl(getIt.get<ApiService>()),
    ),
  );
}


