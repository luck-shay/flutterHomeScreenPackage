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
      home: const HomeDashboard(),
    );
  }
}

class HomeDashboard extends StatelessWidget {
  const HomeDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    // 1. Define the Home Theme Customizations (Optional)
    final themeDelegate = HomeThemeDelegate(
      screenPadding: const EdgeInsets.symmetric(
        horizontal: 20.0,
        vertical: 16.0,
      ),
      sectionSpacing: 32.0,
      cardBorderRadius: BorderRadius.circular(24.0),
      sectionHeaderTextStyle: Theme.of(context).textTheme.headlineSmall
          ?.copyWith(
            fontWeight: FontWeight.w900,
            color: Colors.deepPurple.shade900,
          ),
    );

    // 2. Build the Layout Configuration
    final config = HomeConfig(
      appBar: AppBar(
        title: const Text('My Dashboard'),
        backgroundColor: Colors.deepPurple.shade50,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none),
            onPressed: () {},
          ),
        ],
      ),
      backgroundColor: Colors.white,
      sections: [
        // A. Header Section
        HeaderSectionConfig(
          title: 'Good Morning, Jane!',
          subtitle: 'Here is your daily overview.',
          trailingWidget: const CircleAvatar(
            backgroundColor: Colors.deepPurple,
            child: Text('J', style: TextStyle(color: Colors.white)),
          ),
        ),

        // B. Active Promo / Carousel Banner
        BannerSectionConfig(
          layoutType: BannerLayoutType.carousel,
          banners: [
            _buildPromoCard(
              'Summer Sale!',
              'Up to 50% off everything.',
              Colors.orange.shade300,
            ),
            _buildPromoCard(
              'New Arrivals',
              'Check out the new collection.',
              Colors.blue.shade300,
            ),
            _buildPromoCard(
              'Free Shipping',
              'On all orders over \$50.',
              Colors.green.shade300,
            ),
          ],
        ),

        // C. Quick Actions Grid
        ActionGridSectionConfig(
          crossAxisCount: 4,
          spacing: 12.0,
          actions: [
            _buildActionItem(
              Icons.account_balance_wallet,
              'Wallet',
              Colors.blue,
            ),
            _buildActionItem(Icons.shopping_bag, 'Orders', Colors.orange),
            _buildActionItem(Icons.favorite, 'Wishlist', Colors.pink),
            _buildActionItem(Icons.local_offer, 'Promos', Colors.purple),
            _buildActionItem(Icons.support_agent, 'Support', Colors.teal),
            _buildActionItem(Icons.settings, 'Settings', Colors.grey),
            _buildActionItem(Icons.share, 'Refer', Colors.indigo),
            _buildActionItem(Icons.more_horiz, 'More', Colors.brown),
          ],
        ),

        // D. Visual Divider
        const DividerSectionConfig(
          height: 48,
          thickness: 1,
          color: Colors.black12,
        ),

        // E. Custom Injected Section
        CustomSectionConfig(
          builder: (context) {
            return Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.deepPurple.shade50,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.deepPurple.shade100),
              ),
              child: const Row(
                children: [
                  Icon(Icons.stars, color: Colors.deepPurple),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text('Custom Section: You have 350 reward points!'),
                  ),
                  Icon(Icons.arrow_forward_ios, size: 16),
                ],
              ),
            );
          },
        ),

        // F. Horizontal List (e.g. Recommended Products)
        ContentListSectionConfig(
          title: 'Recommended for You',
          layoutType: ListLayoutType.horizontal,
          horizontalHeight: 160,
          itemSpacing: 16,
          items: List.generate(
            5,
            (index) => _buildProductCard(
              'Product ${index + 1}',
              '\$${(index + 1) * 20}',
            ),
          ),
        ),

        // G. Vertical List (e.g. Recent Activity/News)
        ContentListSectionConfig(
          title: 'Recent Activity',
          layoutType: ListLayoutType.vertical,
          itemSpacing: 12,
          items: List.generate(
            4,
            (index) => ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.receipt_long, color: Colors.grey),
              ),
              title: Text('Order #100${index + 5} delivered'),
              subtitle: Text('2 hours ago'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {},
            ),
          ),
        ),
      ],
    );

    // 3. Render the screen
    return ModularHomeScreen(config: config, themeDelegate: themeDelegate);
  }

  // --- Helpers for example UI building ---

  Widget _buildPromoCard(String title, String subtitle, Color color) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(
          16,
        ), // usually handled by theme, but explicit here for the example
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
            style: const TextStyle(fontSize: 16, color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildActionItem(IconData icon, String label, Color color) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 28),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget _buildProductCard(String name, String price) {
    return Container(
      width: 140,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(16),
                ),
              ),
              child: const Icon(Icons.image, color: Colors.grey, size: 40),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontWeight: FontWeight.w600)),
                const SizedBox(height: 4),
                Text(
                  price,
                  style: const TextStyle(
                    color: Colors.deepPurple,
                    fontWeight: FontWeight.bold,
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
