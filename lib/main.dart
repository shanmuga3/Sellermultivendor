import 'dart:io';
import 'package:country_code_picker/country_localizations.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:sellermultivendor/Provider/faqProvider.dart';
import 'package:sellermultivendor/Screen/Campaign/provider/productlistProvider.dart';
import 'package:sellermultivendor/Screen/Subscription/provider/paymentProvider.dart';
import 'package:sellermultivendor/Screen/completeinfo/provider/allcat_provider.dart';
import 'package:sellermultivendor/firebase_options.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Helper/Color.dart';
import 'Helper/Constant.dart';
import 'Helper/PushNotificationService.dart';
import 'Localization/Demo_Localization.dart';
import 'Localization/Language_Constant.dart';
import 'Provider/ProductListProvider.dart';
import 'Provider/ProfileProvider.dart';
import 'Provider/addProductProvider.dart';
import 'Provider/attributeSetProvider.dart';
import 'Provider/categoryProvider.dart';
import 'Provider/countryProvider.dart';
import 'Provider/editProductProvider.dart';
import 'Provider/homeProvider.dart';
import 'Provider/loginProvider.dart';
import 'Provider/mediaProvider.dart';
import 'Provider/orderListProvider.dart';
import 'Provider/privacyProvider.dart';
import 'Provider/reviewListProvider.dart';
import 'Provider/salesReportProvider.dart';
import 'Provider/searchProvider.dart';
import 'Provider/settingProvider.dart';
import 'Provider/stockmanagementProvider.dart';
import 'Provider/systemProvider.dart';
import 'Provider/taxProvider.dart';
import 'Provider/walletProvider.dart';
import 'Provider/zipcodeProvider.dart';
import 'Screen/Campaign/provider/fetch_campaign.dart';
import 'Screen/Campaign/provider/providers.dart';
import 'Screen/SplashScreen/splashScreen.dart';
import 'Screen/Subscription/provider/subscriptionProvider.dart';
import 'Screen/Subscription/provider/tabProvider.dart';
import 'Screen/completeinfo/newform/city__provider.dart';

late AndroidNotificationChannel channel;
late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (Platform.isIOS) {
    if (Firebase.apps.isNotEmpty) {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
    }
  } else {
    await Firebase.initializeApp();
  }

  HttpOverrides.global = MyHttpOverrides();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  FirebaseMessaging.onBackgroundMessage(myForgroundMessageHandler);
  if (!kIsWeb) {
    channel =  AndroidNotificationChannel(
      'high_importance_channel', // id
      'High Importance Notifications', // title
      importance: Importance.high,
    );
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  late SharedPreferences sharedPreferences;
  static void setLocale(BuildContext context, Locale newLocale) {
    _MyAppState state = context.findAncestorStateOfType<_MyAppState>()!;
    state.setLocale(newLocale);
  }

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale? _locale;

  setLocale(Locale locale) {
    if (mounted) {
      setState(
        () {
          _locale = locale;
        },
      );
    }
  }

  @override
  void didChangeDependencies() {
    getLocale().then(
      (locale) {
        if (mounted) {
          setState(
            () {
              _locale = locale;
            },
          );
        }
      },
    );
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [

        ChangeNotifierProvider<HomeProvider>(
            create: (context) => HomeProvider()),
        ChangeNotifierProvider<AddProductProvider>(
            create: (context) => AddProductProvider()),
        ChangeNotifierProvider<CountryProvider>(
            create: (context) => CountryProvider()),
        ChangeNotifierProvider<TaxProvider>(create: (context) => TaxProvider()),
        ChangeNotifierProvider<SettingProvider>(
            create: (context) => SettingProvider()),
        ChangeNotifierProvider<LoginProvider>(
            create: (context) => LoginProvider()),
        ChangeNotifierProvider<ZipcodeProvider>(
            create: (context) => ZipcodeProvider()),
        ChangeNotifierProvider<CategoryProvider>(
            create: (context) => CategoryProvider()),
        ChangeNotifierProvider<AllCategoryProvider>(
            create: (context) => AllCategoryProvider()),
        ChangeNotifierProvider<AttributeProvider>(
            create: (context) => AttributeProvider()),
        ChangeNotifierProvider<MediaProvider>(
            create: (context) => MediaProvider()),
        ChangeNotifierProvider<SystemProvider>(
            create: (context) => SystemProvider()),
        ChangeNotifierProvider<ProductListProvider>(
            create: (context) => ProductListProvider()),
        ChangeNotifierProvider<ProfileProvider>(
            create: (context) => ProfileProvider()),
        ChangeNotifierProvider<ReviewListProvider>(
            create: (context) => ReviewListProvider()),
        ChangeNotifierProvider<SalesReportProvider>(
            create: (context) => SalesReportProvider()),
        ChangeNotifierProvider<SearchProvider>(
            create: (context) => SearchProvider()),
        ChangeNotifierProvider<OrderListProvider>(
            create: (context) => OrderListProvider()),
        ChangeNotifierProvider<FaQProvider>(create: (context) => FaQProvider()),
        ChangeNotifierProvider<EditProductProvider>(
            create: (context) => EditProductProvider()),
        ChangeNotifierProvider<WalletTransactionProvider>(
            create: (context) => WalletTransactionProvider()),
        ChangeNotifierProvider<StockProviderProvider>(
            create: (context) => StockProviderProvider()),
        ChangeNotifierProvider<TabColor>(
            create: (context) => TabColor()),
        ChangeNotifierProvider<SubscriptionProvider>(
            create: (context) => SubscriptionProvider()),
        ChangeNotifierProvider<ListTileColorProvider>(
            create: (context) => ListTileColorProvider()),
        ChangeNotifierProvider<fetchCampaignDataProvider>(
            create: (context) => fetchCampaignDataProvider()),
        ChangeNotifierProvider<ProductListProviderSearch>(
            create: (context) => ProductListProviderSearch()),
        ChangeNotifierProvider<SystemProviderNew>(
            create: (context) => SystemProviderNew()),
        ChangeNotifierProvider<PaymentProviderFatoora>(
            create: (context) => PaymentProviderFatoora()),
        ChangeNotifierProvider<CityProvider>(
            create: (context) => CityProvider()),

      ],
      child: MaterialApp(
        title: title,
        theme: ThemeData(
          primarySwatch: primary_app,
          fontFamily: 'opensans',
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        locale: _locale,
        localizationsDelegates: const [
          CountryLocalizations.delegate,
          DemoLocalization.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale("en", "US"),
          Locale("zh", "CN"),
          Locale("es", "ES"),
          Locale("hi", "IN"),
          Locale("ar", "DZ"),
          Locale("ru", "RU"),
          Locale("ja", "JP"),
          Locale("de", "DE")
        ],
        localeResolutionCallback: (locale, supportedLocales) {
          for (var supportedLocale in supportedLocales) {
            if (supportedLocale.languageCode == locale!.languageCode &&
                supportedLocale.countryCode == locale.countryCode) {
              return supportedLocale;
            }
          }
          return supportedLocales.first;
        },
        debugShowCheckedModeBanner: false,
        home: const SplashScreen(),
      ),
    );
  }
}
