import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:home_library/home_library.dart';

void main() {
  runApp(const ExampleApp());
}

class ExampleApp extends StatelessWidget {
  const ExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Modular Home Screen Example',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MainAppTabs(),
    );
  }
}

class MainAppTabs extends StatefulWidget {
  const MainAppTabs({super.key});

  @override
  State<MainAppTabs> createState() => _MainAppTabsState();
}

class _MainAppTabsState extends State<MainAppTabs> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const EcommerceSection(),
    const DashboardSection(),
    const SocialFeedSection(),
    const ServerDrivenSection(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.store), label: 'Store'),
          BottomNavigationBarItem(
            icon: Icon(Icons.analytics),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.feed), label: 'Feed'),
          BottomNavigationBarItem(icon: Icon(Icons.cloud_download), label: 'Remote UI'),
        ],
      ),
    );
  }
}

// -----------------------------------------------------
// 1. E-Commerce Template Showcase
// -----------------------------------------------------
class EcommerceSection extends StatelessWidget {
  const EcommerceSection({super.key});

  @override
  Widget build(BuildContext context) {
    return EcommerceTemplate(
      title: 'Fashion Store',
      greetingTitle: 'Good Morning, Jane!',
      greetingSubtitle: 'Discover the latest trends.',
      appBarActions: [
        IconButton(icon: const Icon(Icons.shopping_cart), onPressed: () {}),
      ],
      promoBanners: [
        _buildPromoCard('Summer Sale', 'Up to 50% Off!', Colors.orange),
        _buildPromoCard('New Arrivals', 'Shop Now', Colors.deepPurple),
      ],
      categories: [
        _buildActionItem(Icons.checkroom, 'Clothing'),
        _buildActionItem(Icons.sports_basketball, 'Sports'),
        _buildActionItem(Icons.watch, 'Accessories'),
        _buildActionItem(Icons.more_horiz, 'More'),
      ],
      productLists: [
        ContentListSectionConfig(
          title: 'Trending Now',
          layoutType: ListLayoutType.horizontal,
          horizontalHeight: 200,
          items: List.generate(
            4,
            (index) => WidgetItemConfig(
              widget: _buildProductCard(
                'Product ${index + 1}',
                '\$${(index + 1) * 15}',
              ),
            ),
          ),
        ),
        ContentListSectionConfig(
          title: 'Just For You',
          layoutType: ListLayoutType.horizontal,
          horizontalHeight: 200,
          items: List.generate(
            4,
            (index) => WidgetItemConfig(
              widget: _buildProductCard(
                'Exclusive ${index + 1}',
                '\$${(index + 1) * 25}',
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPromoCard(String title, String subtitle, Color color) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: const TextStyle(fontSize: 16, color: Colors.white70),
          ),
        ],
      ),
    );
  }

  Widget _buildProductCard(String name, String price) {
    return Container(
      width: 140,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              color: Colors.grey.shade200,
              child: const Center(child: Icon(Icons.image, color: Colors.grey)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  maxLines: 1,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  price,
                  style: const TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// -----------------------------------------------------
// 2. Dashboard Template Showcase
// -----------------------------------------------------
class DashboardSection extends StatelessWidget {
  const DashboardSection({super.key});

  @override
  Widget build(BuildContext context) {
    return DashboardTemplate(
      title: 'Analytics',
      greetingTitle: 'Hello, Admin!',
      greetingSubtitle: 'System performance is optimal.',
      statWidgets: [
        _buildStatCard('Total Users', '14,293', Icons.people, Colors.blue),
        _buildStatCard('Revenue', '\$42,100', Icons.attach_money, Colors.green),
        _buildStatCard('Sessions', '8,302', Icons.trending_up, Colors.orange),
        _buildStatCard('Issues', '3', Icons.warning, Colors.red),
      ],
      recentActivity: List.generate(
        5,
        (index) => ListTile(
          leading: const CircleAvatar(child: Icon(Icons.receipt)),
          title: Text('Transaction #${1000 + index}'),
          subtitle: const Text('2 mins ago'),
          trailing: const Icon(Icons.chevron_right),
        ),
      ),
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color),
          const Spacer(),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            title,
            style: TextStyle(fontSize: 14, color: color.withValues(alpha: 0.8)),
          ),
        ],
      ),
    );
  }
}

// -----------------------------------------------------
// 3. Social Feed Template Showcase
// -----------------------------------------------------
class SocialFeedSection extends StatelessWidget {
  const SocialFeedSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SocialFeedTemplate(
      title: 'Social Feed',
      appBarActions: [
        IconButton(icon: const Icon(Icons.send), onPressed: () {}),
      ],
      stories: [
        _buildStory('Your Story', true),
        _buildStory('Alex', false),
        _buildStory('Sam', false),
        _buildStory('Jordan', false),
        _buildStory('Taylor', false),
        _buildStory('Casey', false),
      ],
      feedPosts: [
        _buildPost('Alex', 'Loving the new flutter package!', '2 mins ago'),
        _buildPost(
          'Sam',
          'Building a dashboard took me 5 minutes.',
          '1 hour ago',
        ),
        _buildPost(
          'Jordan',
          'Modular architectures are the future.',
          '3 hours ago',
        ),
      ],
    );
  }

  Widget _buildStory(String name, bool isUser) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CircleAvatar(
          radius: 32,
          backgroundColor: isUser ? Colors.grey : Colors.blue,
          child: CircleAvatar(
            radius: 29,
            backgroundColor: Colors.white,
            child: Icon(isUser ? Icons.add : Icons.person, color: Colors.grey),
          ),
        ),
        const SizedBox(height: 8),
        Text(name, style: const TextStyle(fontSize: 12)),
      ],
    );
  }

  Widget _buildPost(String user, String content, String time) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const CircleAvatar(child: Icon(Icons.person)),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      time,
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
                const Spacer(),
                const Icon(Icons.more_vert),
              ],
            ),
            const SizedBox(height: 16),
            Text(content, style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 16),
            Container(
              height: 150,
              color: Colors.grey.shade100,
              child: const Center(
                child: Icon(Icons.image, size: 40, color: Colors.grey),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: const [
                Icon(Icons.favorite_border),
                Icon(Icons.comment_outlined),
                Icon(Icons.share_outlined),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Shared helper
Widget _buildActionItem(IconData icon, String label) {
  return Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      CircleAvatar(
        radius: 28,
        backgroundColor: Colors.grey.shade200,
        child: Icon(icon, color: Colors.black87),
      ),
      const SizedBox(height: 8),
      Text(
        label,
        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
      ),
    ],
  );
}

// -----------------------------------------------------
// 4. Server-Driven UI Showcase
// -----------------------------------------------------
class ServerDrivenSection extends StatefulWidget {
  const ServerDrivenSection({super.key});

  @override
  State<ServerDrivenSection> createState() => _ServerDrivenSectionState();
}

class _ServerDrivenSectionState extends State<ServerDrivenSection> {
  HomeConfig? _config;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _loadRemoteConfig();
  }

  Future<void> _loadRemoteConfig() async {
    try {
      final jsonString = await DefaultAssetBundle.of(context)
          .loadString('assets/remote_layout.json');
      final payload = jsonDecode(jsonString) as Map<String, dynamic>;

      final registry = ComponentRegistry(
        fallbackBuilder: (type, json) => WidgetItemConfig(
          widget: Text('Unknown component: $type', style: const TextStyle(color: Colors.red)),
        ),
      );

      // Register components defined in our mock JSON!
      registry.register('remote_promo', (json) {
        final title = json['title'] as String? ?? '';
        final subtitle = json['subtitle'] as String? ?? '';
        final colorValue = json['colorValue'] as int? ?? 0xFF000000;
        
        return WidgetItemConfig(
          widget: Container(
            decoration: BoxDecoration(
              color: Color(colorValue),
              borderRadius: BorderRadius.circular(16),
            ),
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(title, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
                if (subtitle.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text(subtitle, style: const TextStyle(fontSize: 16, color: Colors.white70)),
                ],
              ],
            ),
          ),
        );
      });

      registry.register('remote_product', (json) {
        final name = json['name'] as String? ?? '';
        final price = json['price'] as String? ?? '';
        return WidgetItemConfig(
          widget: Container(
            width: 140,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey.shade300),
            ),
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Expanded(child: Center(child: Icon(Icons.inventory_2, size: 40))),
                Text(name, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.bold)),
                Text(price, style: const TextStyle(color: Colors.green)),
              ],
            ),
          ),
        );
      });

      // Pass debugMode: true to observe the internal logger print the JSON mapping!
      setState(() {
        _config = HomeConfig.fromJson(payload, componentRegistry: registry, debugMode: true);
      });
    } catch (e, st) {
      debugPrint('Error loading SDUI: $e\n$st');
      setState(() => _hasError = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_hasError) {
      return const Center(child: Text('Failed to load remote configuration. Check logs.', style: TextStyle(color: Colors.red)));
    }
    if (_config == null) {
      return const Center(child: CircularProgressIndicator());
    }
    return ModularHomeScreen(config: _config!);
  }
}

