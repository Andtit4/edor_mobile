import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

class JobsScreen extends ConsumerStatefulWidget {
  const JobsScreen({super.key});

  @override
  ConsumerState<JobsScreen> createState() => _JobsScreenState();
}

class _JobsScreenState extends ConsumerState<JobsScreen> {
  int _selectedTabIndex = 0;
  final List<String> _tabs = ['List', 'Calendar', 'Map'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightGray,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 16),
              child: Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: AppColors.activityCardShadow,
                    ),
                    child: IconButton(
                      icon: const Icon(
                        Icons.arrow_back_ios_new,
                        color: AppColors.activityText,
                        size: 18,
                      ),
                      onPressed: () => context.go('/'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      'Jobs',
                      style: AppTextStyles.h2.copyWith(
                        color: AppColors.activityText,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.activityButton,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: AppColors.activityCardShadow,
                    ),
                    child: IconButton(
                      icon: const Icon(
                        Icons.add,
                        color: Colors.white,
                        size: 20,
                      ),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Add Job - Coming soon')),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),

            // Segmented Control
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 24),
              decoration: BoxDecoration(
                color: AppColors.socialButtonBg,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: _tabs.asMap().entries.map((entry) {
                  final index = entry.key;
                  final tab = entry.value;
                  final isSelected = _selectedTabIndex == index;
                  
                  return Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedTabIndex = index;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: isSelected ? Colors.white : Colors.transparent,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: isSelected ? AppColors.activityCardShadow : null,
                        ),
                        child: Text(
                          tab,
                          textAlign: TextAlign.center,
                          style: AppTextStyles.buttonMedium.copyWith(
                            color: isSelected 
                                ? AppColors.activityText 
                                : AppColors.activityTextSecondary,
                            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),

            const SizedBox(height: 24),

            // Content
            Expanded(
              child: _buildContent(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent() {
    switch (_selectedTabIndex) {
      case 0:
        return _buildListView();
      case 1:
        return _buildCalendarView();
      case 2:
        return _buildMapView();
      default:
        return _buildListView();
    }
  }

  Widget _buildListView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Charlie's Jobs Header
          Text(
            'Charlie\'s Jobs',
            style: AppTextStyles.h4.copyWith(
              color: AppColors.activityText,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),

          // Jobs List
          _buildJobCard(
            day: 'TODAY',
            jobs: [
              _buildJobItem(
                time: '9:30 AM',
                clientName: 'Albert Flores',
                clientInitial: 'W',
                address: '4517 Washington Ave. Manchester',
                task: 'Repair broken downpipes',
                jobId: '#102',
                color: AppColors.purple,
              ),
              _buildJobItem(
                time: '10:30 AM',
                clientName: 'Theresa Webb',
                clientInitial: 'Q',
                address: '3891 Ranchview Dr. Richardson',
                task: 'Install bartab',
                jobId: '#103',
                color: Colors.orange,
              ),
            ],
          ),

          const SizedBox(height: 24),

          _buildJobCard(
            day: 'SATURDAY',
            jobs: [
              _buildJobItem(
                time: '9:30 AM',
                clientName: 'Albert Flores',
                clientInitial: 'W',
                address: '4517 Washington Ave. Manchester',
                task: 'Repair broken bartab',
                jobId: '#102',
                color: AppColors.purple,
              ),
              _buildJobItem(
                time: '10:30 AM',
                clientName: 'Theresa Webb',
                clientInitial: 'Q',
                address: '3891 Ranchview Dr. Richardson',
                task: 'Install bartab',
                jobId: '#103',
                color: Colors.orange,
              ),
            ],
          ),

          const SizedBox(height: 100), // Space for bottom navigation
        ],
      ),
    );
  }

  Widget _buildJobCard({
    required String day,
    required List<Widget> jobs,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppColors.activityCardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Day Header
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
            child: Text(
              day,
              style: AppTextStyles.labelMedium.copyWith(
                color: AppColors.activityTextSecondary,
                fontWeight: FontWeight.w500,
                letterSpacing: 0.5,
              ),
            ),
          ),
          
          // Jobs List
          ...jobs,
          
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildJobItem({
    required String time,
    required String clientName,
    required String clientInitial,
    required String address,
    required String task,
    required String jobId,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Time and connecting line
          Column(
            children: [
              Text(
                time,
                style: AppTextStyles.buttonMedium.copyWith(
                  color: AppColors.activityText,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                width: 2,
                height: 40,
                color: AppColors.borderColor,
              ),
            ],
          ),
          
          const SizedBox(width: 16),
          
          // Avatar
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                clientInitial,
                style: AppTextStyles.buttonMedium.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          
          const SizedBox(width: 16),
          
          // Job details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  clientName,
                  style: AppTextStyles.cardTitle.copyWith(
                    color: AppColors.activityText,
                  ),
                ),
                const SizedBox(height: 4),
                
                // Address
                Row(
                  children: [
                    const Icon(
                      Icons.location_on_outlined,
                      size: 14,
                      color: AppColors.activityTextSecondary,
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        address,
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.activityTextSecondary,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                
                // Task tag
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.socialButtonBg,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    task,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.activityTextSecondary,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Job ID
          Text(
            jobId,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.activityTextSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCalendarView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.calendar_today_outlined,
            size: 64,
            color: AppColors.activityTextSecondary,
          ),
          const SizedBox(height: 16),
          Text(
            'Calendar View',
            style: AppTextStyles.h5.copyWith(
              color: AppColors.activityText,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Coming soon',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.activityTextSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMapView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.map_outlined,
            size: 64,
            color: AppColors.activityTextSecondary,
          ),
          const SizedBox(height: 16),
          Text(
            'Map View',
            style: AppTextStyles.h5.copyWith(
              color: AppColors.activityText,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Coming soon',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.activityTextSecondary,
            ),
          ),
        ],
      ),
    );
  }
}