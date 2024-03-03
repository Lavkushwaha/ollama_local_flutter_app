// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:io' as _i8;

import 'package:dio/dio.dart' as _i6;
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;

import '../constants/endpoints/endpoints.dart' as _i3;
import '../features/chat_feature/data/datasource/remote_chat_datasource.dart'
    as _i4;
import '../features/chat_feature/domain/repository/chat_repository.dart' as _i5;
import '../features/chat_feature/domain/usecase/get_chat_response_usecase.dart'
    as _i7;
import '../features/chat_feature/presentation/cubit/chat_cubit.dart' as _i9;
import 'di_register_modules.dart' as _i10;

const String _dev = 'dev';
const String _production = 'production';

extension GetItInjectableX on _i1.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  _i1.GetIt init({
    String? environment,
    _i2.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i2.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    final registerModule = _$RegisterModule();
    gh.singleton<_i3.AppEndpoints>(
      registerModule.devEndpoints,
      registerFor: {_dev},
    );
    gh.singleton<_i3.AppEndpoints>(
      registerModule.prodEndpoints,
      registerFor: {_production},
    );
    gh.lazySingleton<_i4.ChatDatasource>(() => registerModule.chatDatasource);
    gh.lazySingleton<_i5.ChatRepository>(() => registerModule.chatRepository);
    gh.lazySingleton<_i6.Dio>(() => registerModule.dio);
    gh.lazySingleton<_i7.GetChatResponseUsecase>(
        () => _i7.GetChatResponseUsecase(gh<_i5.ChatRepository>()));
    gh.lazySingleton<_i8.HttpClient>(() => registerModule.httpClient);
    gh.factory<_i9.ChatCubit>(
        () => _i9.ChatCubit(gh<_i7.GetChatResponseUsecase>()));
    return this;
  }
}

class _$RegisterModule extends _i10.RegisterModule {}
