import 'package:client/features/lots/models/lot.dart';
import 'package:client/features/lots/providers/lot_provider.dart';
import 'package:client/features/lots/widgets/lot_expansion_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LotsScreen extends ConsumerWidget {
  const LotsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lotsAsyncValue = ref.watch(lotsProvider);
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Lots Overview'),
        centerTitle: true,
        elevation: 2,
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh Lots',
            onPressed: () => ref.read(lotsProvider.notifier).refreshLots(),
          ),
          IconButton(
            icon: const Icon(Icons.filter_list),
            tooltip: 'Filter Lots',
            onPressed: () {
              // For future implementation of filters
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Filtering coming soon!')));
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // For future implementation of adding new lots
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Add new lot feature coming soon!')));
        },
        tooltip: 'Add New Lot',
        child: const Icon(Icons.add),
      ),
      body: lotsAsyncValue.when(
        data: (lots) => _buildLotsList(context, lots),
        error: (error, stackTrace) => _buildErrorState(context, error),
        loading: () => _buildLoadingState(),
      ),
    );
  }

  Widget _buildLotsList(BuildContext context, List<Lot> lots) {
    if (lots.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.inventory_2_outlined,
              size: 64,
              color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            Text('No lots found', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Text(
              'Try refreshing or adding a new lot',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6)),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: lots.length,
      itemBuilder: (context, index) {
        return LotExpansionCard(lot: lots[index], isFirst: index == 0, isLast: index == lots.length - 1);
      },
    );
  }

  Widget _buildErrorState(BuildContext context, Object error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: Theme.of(context).colorScheme.error),
            const SizedBox(height: 16),
            Text('Something went wrong', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Text(error.toString(), style: Theme.of(context).textTheme.bodyMedium, textAlign: TextAlign.center),
            const SizedBox(height: 24),
            FilledButton.icon(onPressed: () => {}, icon: const Icon(Icons.refresh), label: const Text('Try Again')),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [CircularProgressIndicator(), SizedBox(height: 16), Text('Loading lots...')],
      ),
    );
  }
}
