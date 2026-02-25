import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:invoice_billing_app/core/cubit/app_user/app_user_cubit.dart';
import 'package:invoice_billing_app/core/data/app_user_remote_datasource.dart';
import 'package:invoice_billing_app/core/data/auth_remote_datasources.dart';
import 'package:invoice_billing_app/core/data/invoice_remote_datasource.dart';
import 'package:invoice_billing_app/core/data/quotation_remote_datasource.dart';
import 'package:invoice_billing_app/core/domain/datasources/app_user_datasource.dart';
import 'package:invoice_billing_app/core/domain/datasources/auth_datasource.dart';
import 'package:invoice_billing_app/core/domain/datasources/invoice_datasource.dart';
import 'package:invoice_billing_app/core/domain/datasources/quotation_datasource.dart';
import 'package:invoice_billing_app/core/utils/firebase_options.dart';
import 'package:invoice_billing_app/features/auth/domain/auth_repository.dart';
import 'package:invoice_billing_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:invoice_billing_app/features/dashboard/domain/repository/dashboard_repository.dart';
import 'package:invoice_billing_app/features/dashboard/presentation/bloc/dashboard_bloc/dashboard_bloc.dart';
import 'package:invoice_billing_app/features/invoice/domain/repository/invoice_repository.dart';
import 'package:invoice_billing_app/features/invoice/presentation/bloc/create_invoice_bloc.dart';
import 'package:invoice_billing_app/features/invoice_edit/domain/repository/edit_invoice_repository.dart';
import 'package:invoice_billing_app/features/invoice_edit/presentation/bloc/edit_invoice_bloc.dart';
import 'package:invoice_billing_app/features/quotation/domain/repository/quotation_repository.dart';
import 'package:invoice_billing_app/features/quotation/presentation/bloc/quotation_bloc.dart';
import 'package:invoice_billing_app/features/quotation_edit/presentation/bloc/edit_quotation_bloc.dart';
import 'package:invoice_billing_app/features/settings/domain/repository/settings_repository.dart';
import 'package:invoice_billing_app/features/settings/presentation/bloc/settings_bloc.dart';

final serviceLocator = GetIt.instance;

Future<bool> initDependencies() async {
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    // Core Firebase services
    serviceLocator.registerLazySingleton(
      () => FirebaseAuth.instance,
    );
    serviceLocator.registerLazySingleton(
      () => FirebaseFirestore.instance,
    );
    serviceLocator.registerLazySingleton(
      () => FirebaseStorage.instance,
    );

    // Data sources — registered as abstract types for DIP compliance
    serviceLocator.registerLazySingleton<AppUserDatasource>(
      () => AppUserRemoteDatasource(firebaseFirestore: serviceLocator()),
    );
    serviceLocator.registerLazySingleton<InvoiceDatasource>(
      () => InvoiceRemoteDatasource(
        firebaseFirestore: serviceLocator(),
      ),
    );
    serviceLocator.registerLazySingleton<QuotationDatasource>(
      () => QuotationRemoteDatasource(
        firebaseFirestore: serviceLocator(),
      ),
    );
    serviceLocator.registerLazySingleton<AuthDatasource>(
      () => AuthRemoteDatasources(
        firebaseAuth: serviceLocator(),
        firebaseFirestore: serviceLocator(),
        firebaseStorage: serviceLocator(),
      ),
    );
    serviceLocator.registerLazySingleton(
      () => AppUserCubit(
          appUserRemoteDatasource: serviceLocator(),
          firebaseAuth: serviceLocator()),
    );
    _initAuth();
    _initCreateInvoice();
    _initDashboard();
    _initEditInvoice();
    _initSettings();
    _initQuotation();
  } catch (e) {
    return false;
  }

  return true;
}

void _initAuth() {
  serviceLocator.registerFactory<AuthRepository>(
    () => AuthRepository(authRemoteDatasources: serviceLocator()),
  );

  serviceLocator.registerLazySingleton(
    () => AuthBloc(authRepository: serviceLocator()),
  );
}

void _initCreateInvoice() {
  serviceLocator.registerFactory<CreateInvoiceRepository>(
    () => CreateInvoiceRepository(invoiceRemoteDatasource: serviceLocator()),
  );

  serviceLocator.registerLazySingleton(
    () => CreateInvoiceBloc(
      appUserCubit: serviceLocator(),
      createInvoiceRepository: serviceLocator(),
    ),
  );
}

void _initDashboard() {
  serviceLocator.registerFactory<DashboardRepository>(
    () => DashboardRepository(
      invoiceRemoteDatasource: serviceLocator(),
      quotationRemoteDatasource: serviceLocator(),
    ),
  );

  serviceLocator.registerLazySingleton(
    () => DashboardBloc(dashboardRepository: serviceLocator()),
  );
}

void _initEditInvoice() {
  serviceLocator.registerFactory<EditInvoiceRepository>(
    () => EditInvoiceRepository(invoiceRemoteDatasource: serviceLocator()),
  );

  serviceLocator.registerLazySingleton(
    () => EditInvoiceBloc(editInvoiceRepository: serviceLocator()),
  );
}

void _initSettings() {
  serviceLocator.registerFactory<SettingsRepository>(
    () => SettingsRepository(authRemoteDatasources: serviceLocator()),
  );

  serviceLocator.registerLazySingleton(
    () => SettingsBloc(settingsRepository: serviceLocator()),
  );
}

void _initQuotation() {
  serviceLocator.registerFactory<QuotationRepository>(
    () => QuotationRepository(quotationRemoteDatasource: serviceLocator()),
  );

  serviceLocator.registerLazySingleton(
    () => QuotationBloc(
      quotationRepository: serviceLocator(),
      appUserCubit: serviceLocator(),
    ),
  );

  serviceLocator.registerLazySingleton(
    () => EditQuotationBloc(quotationRepository: serviceLocator()),
  );
}
