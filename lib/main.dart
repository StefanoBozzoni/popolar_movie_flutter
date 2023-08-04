import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:logging/logging.dart';
import 'package:popular_movies/data/model/favorites.dart';
import 'package:popular_movies/data/model/movies_catalog.dart';
import 'package:popular_movies/data/service/movie_service.dart';
import 'package:popular_movies/go_route.dart';
import 'package:provider/provider.dart';

import 'data/model/movie.dart';
import 'di/injection.dart';
import 'di/injection.dart' as di;
import 'ui/first_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();

  //var path = Directory.current.path;
  Hive
    ..initFlutter()
    ..registerAdapter(FavoritesAdapter());

  _setupLogging();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(
          create: (_) => getIt<MovieService>(),
          dispose: (_, MovieService service) => service.client.dispose(),
        )
      ],
      child: const MyMaterialApp(),
    );
  }
}

void _setupLogging() {
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((rec) {
    debugPrint('${rec.level.name}: ${rec.time}: ${rec.message}');
  });
}

class MyMaterialApp extends StatelessWidget {
  const MyMaterialApp({super.key});

  @override
  Widget build(BuildContext context) {
    GoRouter.optionURLReflectsImperativeAPIs = true;
    return MaterialApp.router(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      //home: const MyStatelessScaffold(),
      //onGenerateRoute: RouteGenerator.generateRoute,
      routerConfig: goRouterManager,
    );
  }
}

class MyStatelessScaffold extends StatelessWidget {
  const MyStatelessScaffold({super.key});

  @override
  Widget build(BuildContext context) {
    return const FirtsPage();
  }
}

Widget blocProviderPageExample(BuildContext context) {
  return const Placeholder();
}

class MyMovieList extends StatelessWidget {
  const MyMovieList({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Provider.of<MovieService>(context).getPopularMovies(1), //<-- here invokes the provider
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          // Exceptions thrown by the Future are stored inside the "error" field of the AsyncSnapshot
          if (snapshot.hasError || (snapshot.data?.statusCode ?? '') == 404) {
            return Center(
              child: Text(
                '${(snapshot.data?.statusCode ?? "")} - ${(snapshot.error.toString())}',
                textAlign: TextAlign.center,
                textScaleFactor: 1.3,
              ),
            );
          } else {
            List<Movie> movies = MoviesCatalog.fromJson(json.decode(snapshot.data?.bodyString ?? "")).results ??
                []; //here decode the results
            const String baseImagePath = "https://image.tmdb.org/t/p/w185/";
            return ListView.builder(
                itemCount: movies.length,
                itemBuilder: (context, index) => Column(children: [
                      Text(
                        movies[index].title ?? "",
                        style: const TextStyle(backgroundColor: Colors.white),
                      ),
                      Image.network(baseImagePath + (movies[index].posterPath ?? ""))
                    ]));
          }
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}


/*
class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() {
    return _MyHomePageState();
  }
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: CachedNetworkImageProvider(
                  'https://images.unsplash.com/photo-1688293696592-f67a77ddc11f?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=735&q=80'),
              fit: BoxFit.fill),
        ),
        child: Center(
          // Center is a layout widget. It takes a single child and positions it
          // in the middle of the parent.
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text(
                'You have pushed the button this many times:',
              ),
              Text(
                '$_counter',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const Text(
                'il mio testo',
                style: TextStyle(
                    color: Color.fromARGB(255, 24, 38, 229),
                    fontWeight: FontWeight.bold,
                    fontSize: 40,
                    fontFamily: 'Jost'),
              ),
              const Text('il mio testo', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 40)),
              TextButton(onPressed: () {}, child: const Text("una prova")),
              ElevatedButton(onPressed: () {}, child: const Text("una II prova")),
              OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(backgroundColor: Colors.white),
                child: const Text("una III prova"),
              ),
              ElevatedButton.icon(
                  onPressed: () {}, label: const Text('ciao sdfio sdfisod3'), icon: const Icon(Icons.photo_camera)),
              OutlinedButton.icon(
                onPressed: () {},
                label: const Icon(Icons.photo_camera),
                icon: const Text('ciao sdfio sdfisod3'),
                style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 12)),
              ),
              ElevatedButton(
                onPressed: () {},
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.resolveWith<Color>(
                    (Set<MaterialState> states) {
                      if (states.contains(MaterialState.pressed)) return Colors.green;
                      return Colors.greenAccent;
                    },
                  ),
                ),
                child: const Text('Elevated Button'),
              )
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
*/
