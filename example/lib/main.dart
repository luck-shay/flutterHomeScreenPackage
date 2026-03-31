import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sdui_engine/sdui_engine.dart';

void main() {
  runApp(const SwiggySduiDemoApp());
}

class SwiggySduiDemoApp extends StatelessWidget {
  const SwiggySduiDemoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Swiggy SDUI Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
        useMaterial3: true,
      ),
      home: const SwiggyHomeScreen(),
    );
  }
}

class ConsoleActionHandler implements SduiActionHandler {
  @override
  void onAction(BuildContext context, SduiAction action) {
    // In a real app, you would integration GoRouter or Bloc here.
    if (action.type == SduiActionType.composite && action.actions != null) {
      for (final subAct in action.actions!) {
        onAction(context, subAct);
      }
      return;
    }

    final msg =
        'Dispatched Action: ${action.type.name} -> ${action.route ?? ""} ${action.params ?? ""}';
    debugPrint(msg);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }
}

class SwiggyHomeScreen extends StatefulWidget {
  const SwiggyHomeScreen({super.key});

  @override
  State<SwiggyHomeScreen> createState() => _SwiggyHomeScreenState();
}

class _SwiggyHomeScreenState extends State<SwiggyHomeScreen> {
  late Future<SduiConfig> _configFuture;
  late final ConsoleActionHandler _actionHandler;

  @override
  void initState() {
    super.initState();
    _actionHandler = ConsoleActionHandler();
    _configFuture = _loadConfig();
  }

  Future<SduiConfig> _loadConfig() async {
    // Simulate network delay for fetching payload
    await Future.delayed(const Duration(milliseconds: 600));

    // Load dummy Swiggy replica JSON from assets
    final jsonString = await rootBundle.loadString('assets/swiggy_home.json');
    final Map<String, dynamic> jsonData = jsonDecode(jsonString);

    // Provide the registry for custom inline components the server might send.
    // Notice how we don't provide a fallback builder here so the engine automatically
    // renders the SduiDebugOverlay for the "unknown_broken_component" in our JSON.
    final registry = ComponentRegistry();

    // Mapping: "promo_card"
    registry.register('promo_card', (json) {
      final action = SduiAction.fromJson(json['action']);
      final color = json['color'] != null
          ? Color(json['color'])
          : Colors.orangeAccent;

      return WidgetItemConfig(
        action: action,
        widget: Builder(
          builder: (context) {
            return GestureDetector(
              onTap: action != null
                  ? () => SduiActionHandlerProvider.of(
                      context,
                    )?.onAction(context, action)
                  : null,
              child: Container(
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: color.withOpacity(0.4),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    // Background Image Placeholder
                    Positioned.fill(
                      child: Image.network(
                        'https://picsum.photos/seed/${json['id'] ?? 'promo'}/400/200',
                        fit: BoxFit.cover,
                        color: Colors.black.withOpacity(
                          0.3,
                        ), // Darken for text readability
                        colorBlendMode: BlendMode.darken,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            json['title'] ?? '',
                            style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                              letterSpacing: -0.5,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              json['subtitle'] ?? '',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: color,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      );
    });

    // Mapping: "category_icon"
    registry.register('category_icon', (json) {
      final action = SduiAction.fromJson(json['action']);
      final color = json['color'] != null ? Color(json['color']) : Colors.grey;

      return WidgetItemConfig(
        action: action,
        widget: Builder(
          builder: (context) {
            return GestureDetector(
              onTap: action != null
                  ? () => SduiActionHandlerProvider.of(
                      context,
                    )?.onAction(context, action)
                  : null,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Image.network(
                        'https://api.dicebear.com/7.x/icons/png?seed=${json['icon']}&backgroundColor=transparent',
                        width: 36,
                        height: 36,
                        errorBuilder: (ctx, err, stack) =>
                            Icon(Icons.fastfood, color: color, size: 32),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    json['label'] ?? '',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.2,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      );
    });

    // Mapping: "restaurant_card"
    registry.register('restaurant_card', (json) {
      final action = SduiAction.fromJson(json['action']);

      return WidgetItemConfig(
        action: action,
        widget: Builder(
          builder: (context) {
            return InkWell(
              onTap: action != null
                  ? () => SduiActionHandlerProvider.of(
                      context,
                    )?.onAction(context, action)
                  : null,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 120,
                    height: 130,
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Image.network(
                      'https://picsum.photos/seed/${json['id'] ?? 'res'}/200/200',
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            json['name'] ?? '',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                              letterSpacing: -0.5,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: Colors.green,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.star,
                                  color: Colors.white,
                                  size: 12,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                json['rating']?.toString() ?? '',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(width: 12),
                              const Icon(
                                Icons.timer_outlined,
                                size: 16,
                                color: Colors.black54,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                json['time'] ?? '',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black54,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            json['cuisines'] ?? '',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.black45,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      );
    });

    // Important: parsing in Strict Mode natively handles schema compliance!
    // Using validationResult to grab the schema evaluation natively.
    final validation = ValidationResult();

    final config = await SduiConfig.fromJsonAsync(
      jsonData,
      componentRegistry: registry,
      debugMode: true,
      strictMode:
          false, // Turn on true in Dev to aggressively fail on schema mismatch!
      validationResult: validation,
    );

    debugPrint(
      'SDUI JSON Validated. Warnings: ${validation.warnings.length}, Errors: ${validation.errors.length}',
    );

    return config;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Swiggy SDUI Engine Demo',
          style: TextStyle(fontSize: 16),
        ),
        backgroundColor: Colors.deepOrange,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                _configFuture = _loadConfig();
              });
            },
          ),
        ],
      ),
      body: FutureBuilder<SduiConfig>(
        future: _configFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Failed to load UI: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            // Drop in the core SDUI orchestrator view!
            return SduiScreen(
              config: snapshot.data!,
              actionHandler: _actionHandler, // Inject the Interaction delegate
              themeDelegate: SduiThemeDelegate(
                screenPadding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 24.0,
                ),
                cardBorderRadius: BorderRadius.circular(16),
              ),
            );
          }
          return const Center(child: Text('No Configuration found.'));
        },
      ),
    );
  }
}
