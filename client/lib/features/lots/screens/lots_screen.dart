import 'package:client/features/home/providers/projects_provider.dart';
import 'package:client/features/lots/models/lot.dart';
import 'package:client/features/lots/providers/lot_provider.dart';
import 'package:client/features/lots/widgets/lot/lot_form.dart';
import 'package:client/features/lots/widgets/lot/lot_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// TODO: show deliverables
class LotsScreen extends ConsumerWidget {
  const LotsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Fetch the current project ID from the provider
    final currentProjectId = ref.watch(currentProjectNotifierProvider);
    final lotsAsyncValue = ref.watch(lotsProvider(currentProjectId));
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Lots Overview'),
        elevation: 2,
        backgroundColor: Colors.transparent,
        foregroundColor: colorScheme.onSurface,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh Lots',
            onPressed: () => ref.read(lotsProvider(currentProjectId).notifier).refreshLots(),
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
        onPressed:
            () => showModalBottomSheet(
              context: context,
              // Make it scrollable and resize when keyboard appears
              isScrollControlled: true,
              // Optional: give it rounded corners
              shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16.0))),
              builder: (BuildContext context) {
                return LotForm(
                  initialLot: null, // Pass the lot if editing, null if creating
                );
              },
            ),
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

  Widget _buildLotsList(BuildContext context, List<Lot> lots, {int? currentProjectId}) {
    if (lots.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.inventory_2_outlined,
              size: 64,
              color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 16),
            if (lots.isEmpty) Text('No lots available', style: Theme.of(context).textTheme.titleLarge),
            if (currentProjectId == null)
              Text('Please select a valid project', style: Theme.of(context).textTheme.titleLarge),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: lots.length,
      itemBuilder: (context, index) {
        return LotCard(lot: lots[index]);
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
