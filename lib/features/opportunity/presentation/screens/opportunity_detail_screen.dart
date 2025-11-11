import 'package:flutter/material.dart';
import 'package:kaleo_frontend/core/theme/app_colors.dart';
import 'package:kaleo_frontend/core/widgets/app_footer.dart';
import 'package:url_launcher/url_launcher.dart';

class OpportunityDetailScreen extends StatefulWidget {
  final OpportunityDetail opportunity;
  
  const OpportunityDetailScreen({
    super.key,
    required this.opportunity,
  });

  @override
  State<OpportunityDetailScreen> createState() => _OpportunityDetailScreenState();
  
}



class _OpportunityDetailScreenState extends State<OpportunityDetailScreen> {
  bool _benefitsOpen = true;
  bool _requirementsOpen = true;
  bool _applyOpen = true;
  

  Future<void> _openOfficialUrl() async {
  final urlString = widget.opportunity.sourceUrl;
  if (urlString.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('No hay URL de fuente oficial')),
    );
    return;
  }

  // OJO: tu backend a veces devuelve URLs con espacios.
  // Los codificamos para que sean válidos.
  final encoded = urlString.replaceAll(' ', '%20');

  Uri? uri;
  try {
    uri = Uri.parse(encoded);
  } catch (_) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('URL inválida: $urlString')),
    );
    return;
  }

  // Intenta abrir en navegador externo
  final ok = await launchUrl(
    uri,
    mode: LaunchMode.externalApplication,
  );

  if (!ok) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('No pude abrir el enlace')),
    );
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 900),
            child: CustomScrollView(
              slivers: [
                // Header con botón de regreso
                SliverAppBar(
                  pinned: true,
                  leading: IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  title: const Text('Detalles de la convocatoria'),
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  elevation: 0,
                ),
                
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Organization Header
                        _buildOrganizationCard(),
                        const SizedBox(height: 16),
                        
                        // Basic Info
                        _buildBasicInfoCard(),
                        const SizedBox(height: 16),
                        
                        // Description
                        _buildDescriptionCard(),
                        const SizedBox(height: 16),
                        
                        // Benefits
                        // _buildBenefitsCard(),
                        // const SizedBox(height: 16),
                        
                        // // Requirements
                        // _buildRequirementsCard(),
                        // const SizedBox(height: 16),
                        
                        // // How to Apply
                        // _buildApplyCard(),
                        // const SizedBox(height: 24),
                        
                        // CTA Button
                        _buildCTAButton(),
                        const SizedBox(height: 16),
                        const AppFooter(),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOrganizationCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
        gradient: LinearGradient(
          colors: [AppColors.primary.withOpacity(0.05), AppColors.accent.withOpacity(0.05)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: const Icon(Icons.business, color: AppColors.primary, size: 32),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.opportunity.organization,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  widget.opportunity.title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getCategoryColor(widget.opportunity.category).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(
                      color: _getCategoryColor(widget.opportunity.category).withOpacity(0.3),
                    ),
                  ),
                  child: Text(
                    widget.opportunity.category,
                    style: TextStyle(
                      color: _getCategoryColor(widget.opportunity.category),
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBasicInfoCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Información básica',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildInfoItem(
                  icon: Icons.calendar_today,
                  label: 'Fecha límite',
                  value: _formatDate(widget.opportunity.deadline),
                ),
              ),
              /*
              Expanded(
                child: _buildInfoItem(
                  icon: Icons.location_on,
                  label: 'País',
                  value: widget.opportunity.country,
                ),
              ),
              */
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildInfoItem(
                  icon: Icons.computer,
                  label: 'Modalidad',
                  value: widget.opportunity.modality,
                ),
              ),
              Expanded(
                child: _buildInfoItem(
                  icon: Icons.category,
                  label: 'Categoría',
                  value: widget.opportunity.category,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Icon(icon, color: AppColors.primary, size: 20),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDescriptionCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Descripción',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            widget.opportunity.description,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.grey,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
  
  // Widget _buildBenefitsCard() {
  //   return _buildCollapsibleCard(
  //     title: 'Beneficios',
  //     icon: Icons.card_giftcard,
  //     iconColor: Colors.green,
  //     isOpen: _benefitsOpen,
  //     onToggle: () => setState(() => _benefitsOpen = !_benefitsOpen),
  //     child: Column(
  //       children: widget.opportunity.benefits.map((benefit) => 
  //         Padding(
  //           padding: const EdgeInsets.symmetric(vertical: 4),
  //           child: Row(
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: [
  //               Container(
  //                 width: 6,
  //                 height: 6,
  //                 margin: const EdgeInsets.only(top: 6, right: 8),
  //                 decoration: const BoxDecoration(
  //                   color: AppColors.accent,
  //                   shape: BoxShape.circle,
  //                 ),
  //               ),
  //               Expanded(
  //                 child: Text(
  //                   benefit,
  //                   style: const TextStyle(
  //                     fontSize: 14,
  //                     color: Colors.grey,
  //                   ),
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ),
  //       ).toList(),
  //     ),
  //   );
  // }

  // Widget _buildRequirementsCard() {
  //   return _buildCollapsibleCard(
  //     title: 'Requisitos',
  //     icon: Icons.checklist,
  //     iconColor: Colors.blue,
  //     isOpen: _requirementsOpen,
  //     onToggle: () => setState(() => _requirementsOpen = !_requirementsOpen),
  //     child: Column(
  //       children: widget.opportunity.requirements.map((requirement) => 
  //         Padding(
  //           padding: const EdgeInsets.symmetric(vertical: 4),
  //           child: Row(
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: [
  //               Container(
  //                 width: 6,
  //                 height: 6,
  //                 margin: const EdgeInsets.only(top: 6, right: 8),
  //                 decoration: const BoxDecoration(
  //                   color: AppColors.primary,
  //                   shape: BoxShape.circle,
  //                 ),
  //               ),
  //               Expanded(
  //                 child: Text(
  //                   requirement,
  //                   style: const TextStyle(
  //                     fontSize: 14,
  //                     color: Colors.grey,
  //                   ),
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ),
  //       ).toList(),
  //     ),
  //   );
  // }

  // Widget _buildApplyCard() {
  //   return _buildCollapsibleCard(
  //     title: 'Cómo aplicar',
  //     icon: Icons.description,
  //     iconColor: Colors.purple,
  //     isOpen: _applyOpen,
  //     onToggle: () => setState(() => _applyOpen = !_applyOpen),
  //     child: Column(
  //       children: widget.opportunity.howToApply.asMap().entries.map((entry) {
  //         int index = entry.key;
  //         String step = entry.value;
  //         return Padding(
  //           padding: const EdgeInsets.symmetric(vertical: 8),
  //           child: Row(
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: [
  //               Container(
  //                 width: 24,
  //                 height: 24,
  //                 decoration: BoxDecoration(
  //                   color: AppColors.primary,
  //                   borderRadius: BorderRadius.circular(12),
  //                 ),
  //                 child: Center(
  //                   child: Text(
  //                     '${index + 1}',
  //                     style: const TextStyle(
  //                       color: Colors.white,
  //                       fontSize: 12,
  //                       fontWeight: FontWeight.w600,
  //                     ),
  //                   ),
  //                 ),
  //               ),
  //               const SizedBox(width: 12),
  //               Expanded(
  //                 child: Text(
  //                   step,
  //                   style: const TextStyle(
  //                     fontSize: 14,
  //                     color: Colors.grey,
  //                   ),
  //                 ),
  //               ),
  //             ],
  //           ),
  //         );
  //       }).toList(),
  //     ),
  //   );
  // }

  Widget _buildCollapsibleCard({
    required String title,
    required IconData icon,
    required Color iconColor,
    required bool isOpen,
    required VoidCallback onToggle,
    required Widget child,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        children: [
          InkWell(
            onTap: onToggle,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: Container(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: iconColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(icon, color: iconColor, size: 20),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  Icon(
                    isOpen ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                    color: Colors.grey,
                  ),
                ],
              ),
            ),
          ),
          if (isOpen)
            Container(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: child,
            ),
        ],
      ),
    );
  }

    Widget _buildCTAButton() {
      return SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: _openOfficialUrl,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.accent,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.open_in_new, size: 20),
              SizedBox(width: 8),
              Text(
                'Ir a fuente oficial',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      );
    }


  String _formatDate(DateTime date) {
    final months = [
      'enero', 'febrero', 'marzo', 'abril', 'mayo', 'junio',
      'julio', 'agosto', 'septiembre', 'octubre', 'noviembre', 'diciembre'
    ];
    return '${date.day} de ${months[date.month - 1]} de ${date.year}';
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'Becas':
        return Colors.blue;
      case 'Empleo':
        return Colors.green;
      case 'Investigación':
        return Colors.purple;
      case 'Voluntariado':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}

class OpportunityDetail {
  final String id;
  final String title;
  final String organization;
  final String category;
  final DateTime deadline;
  final String modality;
  final String country;
  final String description;
  final List<String> benefits;
  final List<String> requirements;
  final List<String> howToApply;
  final String sourceUrl;

  const OpportunityDetail({
    required this.id,
    required this.title,
    required this.organization,
    required this.category,
    required this.deadline,
    required this.modality,
    required this.country,
    required this.description,
    required this.benefits,
    required this.requirements,
    required this.howToApply,
    required this.sourceUrl,
  });
}
