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
        fontFamily: 'Inter', // Assuming a clean sans serif
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFFC8019)),
        scaffoldBackgroundColor: const Color(0xFFF0F2F5), // Light grey background like real app
        useMaterial3: true,
      ),
      home: const SwiggyHomeScreen(),
    );
  }
}

class ConsoleActionHandler implements SduiActionHandler {
  @override
  void onAction(BuildContext context, SduiAction action) {
    if (action.type == SduiActionType.composite && action.actions != null) {
      for (final subAct in action.actions!) {
        onAction(context, subAct);
      }
      return;
    }

    final msg =
        'Action Triggered: ${action.type.name} -> ${action.route ?? ""}';
    debugPrint(msg);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
      duration: const Duration(seconds: 1),
    ));
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
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _actionHandler = ConsoleActionHandler();
    _configFuture = _loadConfig();
  }

  Future<SduiConfig> _loadConfig() async {
    await Future.delayed(const Duration(milliseconds: 600));

    final jsonString = await rootBundle.loadString('assets/swiggy_home.json');
    final Map<String, dynamic> jsonData = jsonDecode(jsonString);

    final registry = ComponentRegistry();

    // 1. Search Bar Component
    registry.register('search_bar', (json) {
      return WidgetItemConfig(
        action: null,
        widget: Builder(
          builder: (context) {
            return Padding(
              padding: const EdgeInsets.only(top: 8, bottom: 8),
              child: GestureDetector(
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Opening Search...')),
                  );
                },
                child: Container(
                  height: 52,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.04),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      const Expanded(
                        child: Text(
                          "Search for 'Biryani'",
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Icon(Icons.search, color: Colors.grey.shade600),
                      const SizedBox(width: 12),
                      Container(height: 24, width: 1, color: Colors.grey.shade300),
                      const SizedBox(width: 12),
                      Icon(Icons.mic_none, color: Theme.of(context).primaryColor),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      );
    });

    // 2. Promo Card Component (Refined)
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
                  ? () => SduiActionHandlerProvider.of(context)?.onAction(context, action)
                  : null,
              child: Container(
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: Image.network(
                        'https://picsum.photos/seed/${json['id'] ?? 'promo'}/400/200',
                        fit: BoxFit.cover,
                        color: Colors.black.withValues(alpha: 0.4),
                        colorBlendMode: BlendMode.darken,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            json['title'] ?? '',
                            style: const TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                              letterSpacing: -0.5,
                              height: 1.1,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            json['subtitle'] ?? '',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: Colors.white.withValues(alpha: 0.9),
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

    // 3. Category Icon Component (Refined)
    registry.register('category_icon', (json) {
      final action = SduiAction.fromJson(json['action']);

      return WidgetItemConfig(
        action: action,
        widget: Builder(
          builder: (context) {
            return GestureDetector(
              onTap: action != null
                  ? () => SduiActionHandlerProvider.of(context)?.onAction(context, action)
                  : null,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.04),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Image.network(
                        'https://api.dicebear.com/7.x/icons/png?seed=${json['icon']}&backgroundColor=transparent',
                        width: 36,
                        height: 36,
                        errorBuilder: (ctx, err, stack) =>
                            Icon(Icons.fastfood, color: Theme.of(context).primaryColor, size: 28),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    json['label'] ?? '',
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade800,
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

    // 4. Restaurant Card Component (Redesigned completely to match realistic Swiggy layouts)
    registry.register('restaurant_card', (json) {
      final action = SduiAction.fromJson(json['action']);

      return WidgetItemConfig(
        action: action,
        widget: Builder(
          builder: (context) {
            return InkWell(
              onTap: action != null
                  ? () => SduiActionHandlerProvider.of(context)?.onAction(context, action)
                  : null,
              borderRadius: BorderRadius.circular(16),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      children: [
                        Container(
                          width: 140,
                          height: 150,
                          clipBehavior: Clip.antiAlias,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.1),
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
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.only(
                                bottomLeft: Radius.circular(16),
                                bottomRight: Radius.circular(16),
                              ),
                              gradient: LinearGradient(
                                colors: [
                                  Colors.black.withValues(alpha: 0.0),
                                  Colors.black.withValues(alpha: 0.8),
                                ],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                              ),
                            ),
                            padding: const EdgeInsets.only(top: 20, bottom: 8, left: 12, right: 12),
                            child: const Text(
                              "ITEMS AT ₹99",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w900,
                                fontSize: 16,
                                letterSpacing: -0.5,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          top: 8,
                          right: 8,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.favorite_border, size: 18, color: Colors.grey),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 4.0),
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
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(3),
                                  decoration: const BoxDecoration(
                                    color: Colors.green,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.star,
                                    color: Colors.white,
                                    size: 10,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  json['rating']?.toString() ?? '',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w800,
                                    fontSize: 15,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                const Text("•", style: TextStyle(color: Colors.grey, fontSize: 16)),
                                const SizedBox(width: 8),
                                Text(
                                  json['time'] ?? '',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 15,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              json['cuisines'] ?? '',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Colors.grey.shade600,
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              "2.5 km | Area Name", // Mock location context
                              style: TextStyle(
                                color: Colors.grey.shade600,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.blue.withValues(alpha: 0.08),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.local_offer, size: 14, color: Colors.blue),
                                  SizedBox(width: 4),
                                  Text(
                                    "FREE DELIVERY",
                                    style: TextStyle(
                                      color: Colors.blue,
                                      fontWeight: FontWeight.w800,
                                      fontSize: 10,
                                    ),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
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

    final validation = ValidationResult();
    final config = await SduiConfig.fromJsonAsync(
      jsonData,
      componentRegistry: registry,
      customSectionBuilders: {
        'swiggy_header': (json, reg, {strictMode = false, validationResult}) {
          return CustomSectionConfig(
            id: json['id'],
            spacingBelow: json['spacingBelow']?.toDouble(),
            builder: (context) {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.near_me,
                    color: Theme.of(context).primaryColor,
                    size: 28,
                  ),
                  const SizedBox(width: 8.0),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              json['title'] ?? '',
                              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.w900,
                                    fontSize: 18,
                                    letterSpacing: -0.5,
                                  ),
                            ),
                            const SizedBox(width: 4),
                            const Icon(Icons.keyboard_arrow_down, size: 24),
                          ],
                        ),
                        if (json['subtitle'] != null) ...[
                          const SizedBox(height: 2.0),
                          Text(
                            json['subtitle'],
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: Colors.grey.shade600,
                                  fontWeight: FontWeight.w500,
                                ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(width: 16.0),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.person, color: Colors.grey.shade600, size: 20),
                  )
                ],
              );
            },
          );
        }
      },
      debugMode: true,
      strictMode: false,
      validationResult: validation,
    );

    return config;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (idx) {
          setState(() {
            _currentIndex = idx;
            if (idx == 0) _configFuture = _loadConfig(); // Refresh on tab
          });
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.black87,
        unselectedItemColor: Colors.grey.shade500,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w800, fontSize: 12),
        unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: 'Swiggy'),
          BottomNavigationBarItem(icon: Icon(Icons.fastfood_outlined), label: 'Food'),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_basket_outlined), label: 'Instamart'),
          BottomNavigationBarItem(icon: Icon(Icons.restaurant_outlined), label: 'Dineout'),
          BottomNavigationBarItem(icon: Icon(Icons.delivery_dining_outlined), label: 'Genie'),
        ],
      ),
      body: SafeArea(
        child: FutureBuilder<SduiConfig>(
          future: _configFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Failed to load UI: ${snapshot.error}'));
            } else if (snapshot.hasData) {
              // Standard SDUI drop in
              return Container(
                color: Colors.white,
                child: SduiScreen(
                  config: snapshot.data!,
                  actionHandler: _actionHandler,
                  themeDelegate: SduiThemeDelegate(
                    screenPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                    cardBorderRadius: BorderRadius.circular(16),
                  ),
                ),
              );
            }
            return const Center(child: Text('No Configuration found.'));
          },
        ),
      ),
    );
  }
}
