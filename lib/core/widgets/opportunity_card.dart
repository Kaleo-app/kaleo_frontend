import 'package:flutter/material.dart';
import 'package:kaleo_frontend/core/widgets/category_tag.dart';

class OpportunityCard extends StatelessWidget {
  final String title;
  final String? organization;
  final String? category;
  final DateTime? deadline;
  final String? location;
  final String? modality;
  final VoidCallback? onTap; // se usará SOLO en el título

  const OpportunityCard({
    super.key,
    required this.title,
    this.organization,
    this.category,
    this.deadline,
    this.location,
    this.modality,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[300]!),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ---------- CABECERA ----------
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ---------- TITULAR + ORGANIZACIÓN ----------
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      InkWell(
                        onTap: onTap,
                        borderRadius: BorderRadius.circular(4),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 2),
                          child: Text(
                            title,
                            maxLines: 2, // límite de líneas para evitar overflow
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                              height: 1.3,
                            ),
                          ),
                        ),
                      ),
                      if (organization != null && organization!.trim().isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Text(
                          organization!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),

                // ---------- CATEGORÍA ----------
                if (category != null && category!.trim().isNotEmpty)
                  Align(
                    alignment: Alignment.topRight,
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 120),
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: CategoryTag(text: category!),
                      ),
                    ),
                  ),
              ],
            ),

            const SizedBox(height: 12),

            // ---------- LÍNEA INFERIOR (UNA SOLA LÍNEA, TRUNCANDO) ----------
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Fecha (compacta)
                if (deadline != null) ...[
                  const Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                  const SizedBox(width: 4),
                  Text(
                    _formatDate(deadline!),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 13, color: Colors.grey),
                  ),
                ],

                // Separador si hay fecha y otro dato
                if (deadline != null && (location != null && location!.trim().isNotEmpty ||
                    modality != null && modality!.trim().isNotEmpty))
                  const SizedBox(width: 16),

                // Modalidad (compacta, sin Expanded)
                if (modality != null && modality!.trim().isNotEmpty) ...[
                  const Icon(Icons.computer, size: 16, color: Colors.grey),
                  const SizedBox(width: 4),
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 140),
                    child: Text(
                      modality!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 13, color: Colors.grey),
                    ),
                  ),
                ],

                // Separador si hay modalidad y ubicación
                if (modality != null && modality!.trim().isNotEmpty &&
                    location != null && location!.trim().isNotEmpty)
                  const SizedBox(width: 16),

                // Ubicación (ES LA ÚNICA que usa Expanded para comerse resto) 👇
                if (location != null && location!.trim().isNotEmpty) ...[
                  const Icon(Icons.location_on, size: 16, color: Colors.grey),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      location!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      softWrap: false,
                      style: const TextStyle(fontSize: 13, color: Colors.grey),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    const months = [
      'ene', 'feb', 'mar', 'abr', 'may', 'jun',
      'jul', 'ago', 'sep', 'oct', 'nov', 'dic'
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }
}





// import 'package:flutter/material.dart';
// import 'package:kaleo_frontend/core/widgets/category_tag.dart';

// class OpportunityCard extends StatelessWidget {
//   final String title;
//   final String? organization;
//   final String? category;
//   final DateTime? deadline;
//   final String? location;
//   final String? modality;
//   final VoidCallback? onTap; // se usará SOLO en el título

//   const OpportunityCard({
//     super.key,
//     required this.title,
//     this.organization,
//     this.category,
//     this.deadline,
//     this.location,
//     this.modality,
//     this.onTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Material( // Material para que el InkWell del título tenga ripple
//       borderRadius: BorderRadius.circular(12),
//       child: Container(
//         padding: const EdgeInsets.all(16),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(12),
//           border: Border.all(color: Colors.grey[300]!),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(0.05),
//               blurRadius: 8,
//               offset: const Offset(0, 2),
//             ),
//           ],
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // -------- CABECERA: título (clic) + categoría --------
//             Row(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 // Título ocupa todo el espacio
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       InkWell(
//                         onTap: onTap, // << SOLO clic en el nombre
//                         borderRadius: BorderRadius.circular(4),
//                         child: Padding(
//                           padding: const EdgeInsets.symmetric(vertical: 2),
//                           child: Text(
//                             title, // sin corte, como pediste
//                             style: const TextStyle(
//                               fontSize: 16,
//                               fontWeight: FontWeight.w600,
//                               color: Colors.black87,
//                               height: 1.3,
//                               decoration: TextDecoration.underline, // opcional para indicar que es clic
//                             ),
//                           ),
//                         ),
//                       ),
//                       if (organization != null && organization!.trim().isNotEmpty) ...[
//                         const SizedBox(height: 4),
//                         Text(
//                           organization!,
//                           maxLines: 1,
//                           overflow: TextOverflow.ellipsis,
//                           softWrap: false,
//                           style: const TextStyle(
//                             fontSize: 14,
//                             color: Colors.grey,
//                             fontWeight: FontWeight.w400,
//                           ),
//                         ),
//                       ],
//                     ],
//                   ),
//                 ),
//                 if (category != null && category!.trim().isNotEmpty)
//                   Align(
//                     alignment: Alignment.topRight,
//                     child: ConstrainedBox(
//                       constraints: const BoxConstraints(maxWidth: 120),
//                       child: FittedBox(
//                         fit: BoxFit.scaleDown,
//                         child: CategoryTag(text: category!),
//                       ),
//                     ),
//                   ),
//               ],
//             ),

//             const SizedBox(height: 12),

//             // -------- FILA INFERIOR: fecha, ubicación, modalidad --------
//             Row(
//               children: [
//                 if (deadline != null) ...[
//                   const Icon(Icons.calendar_today, size: 16, color: Colors.grey),
//                   const SizedBox(width: 4),
//                   Text(
//                     _formatDate(deadline!),
//                     style: const TextStyle(fontSize: 13, color: Colors.grey),
//                   ),
//                   const SizedBox(width: 16),
//                 ],
//                 if (location != null && location!.trim().isNotEmpty) ...[
//                   const Icon(Icons.location_on, size: 16, color: Colors.grey),
//                   const SizedBox(width: 4),
//                   Flexible(
//                     child: Text(
//                       location!,
//                       maxLines: 1,
//                       overflow: TextOverflow.ellipsis,
//                       softWrap: false,
//                       style: const TextStyle(fontSize: 13, color: Colors.grey),
//                     ),
//                   ),
//                   const SizedBox(width: 16),
//                 ],
//                 if (modality != null && modality!.trim().isNotEmpty) ...[
//                   const Icon(Icons.computer, size: 16, color: Colors.grey),
//                   const SizedBox(width: 4),
//                   Flexible(
//                     child: Text(
//                       modality!,
//                       maxLines: 1,
//                       overflow: TextOverflow.ellipsis,
//                       softWrap: false,
//                       style: const TextStyle(fontSize: 13, color: Colors.grey),
//                     ),
//                   ),
//                 ],
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   String _formatDate(DateTime date) {
//     const months = ['ene','feb','mar','abr','may','jun','jul','ago','sep','oct','nov','dic'];
//     return '${date.day} ${months[date.month - 1]} ${date.year}';
//   }
// }

/*
import 'package:flutter/material.dart';
import 'package:kaleo_frontend/core/theme/app_colors.dart';
import 'package:kaleo_frontend/core/widgets/category_tag.dart';
import 'package:kaleo_frontend/core/widgets/deadline_chip.dart';

class OpportunityCard extends StatelessWidget {
  final String title;
  final String? organization;
  final String? category;
  final DateTime? deadline;
  final String? location;
  final String? modality;
  final VoidCallback? onTap;

  const OpportunityCard({
    super.key,
    required this.title,
    this.organization,
    this.category,
    this.deadline,
    this.location,
    this.modality,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[300]!),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // -------- CABECERA: título + categoría --------
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 🟩 El título ahora ocupa todo el espacio disponible
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                          height: 1.3,
                        ),
                      ),
                      if (organization != null && organization!.trim().isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Text(
                          organization!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          softWrap: false,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),

                // 🟨 La categoría ahora solo ocupa lo necesario y se alinea a la derecha
                if (category != null && category!.trim().isNotEmpty)
                  Align(
                    alignment: Alignment.topRight,
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 120),
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: CategoryTag(text: category!),
                      ),
                    ),
                  ),
              ],
            ),

            const SizedBox(height: 12),

            // -------- FILA INFERIOR: fecha, ubicación, modalidad --------
            Row(
              children: [
                if (deadline != null) ...[
                  const Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                  const SizedBox(width: 4),
                  Text(
                    _formatDate(deadline!),
                    style: const TextStyle(fontSize: 13, color: Colors.grey),
                  ),
                  const SizedBox(width: 16),
                ],

                if (location != null && location!.trim().isNotEmpty) ...[
                  const Icon(Icons.location_on, size: 16, color: Colors.grey),
                  const SizedBox(width: 4),
                  Flexible(
                    child: Text(
                      location!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      softWrap: false,
                      style: const TextStyle(fontSize: 13, color: Colors.grey),
                    ),
                  ),
                  const SizedBox(width: 16),
                ],

                if (modality != null && modality!.trim().isNotEmpty) ...[
                  const Icon(Icons.computer, size: 16, color: Colors.grey),
                  const SizedBox(width: 4),
                  Flexible(
                    child: Text(
                      modality!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      softWrap: false,
                      style: const TextStyle(fontSize: 13, color: Colors.grey),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    const months = [
      'ene', 'feb', 'mar', 'abr', 'may', 'jun',
      'jul', 'ago', 'sep', 'oct', 'nov', 'dic'
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }
}

*/


/*





import 'package:flutter/material.dart';
import 'package:kaleo_frontend/core/theme/app_colors.dart';
import 'package:kaleo_frontend/core/widgets/category_tag.dart';
import 'package:kaleo_frontend/core/widgets/deadline_chip.dart';

class OpportunityCard extends StatelessWidget {
  final String title;
  final String? organization;
  final String? category;
  final DateTime? deadline;
  final String? location;
  final String? modality;
  final VoidCallback? onTap;

  const OpportunityCard({
    super.key,
    required this.title,
    this.organization,
    this.category,
    this.deadline,
    this.location,
    this.modality,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[300]!),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                          height: 1.3,
                        ),
                      ),
                      if (organization != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          organization!,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                if (category != null) CategoryTag(text: category!),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                if (deadline != null) ...[
                  const Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                  const SizedBox(width: 4),
                  Text(
                    _formatDate(deadline!),
                    style: const TextStyle(fontSize: 13, color: Colors.grey),
                  ),
                  const SizedBox(width: 16),
                ],
                if (location != null) ...[
                  const Icon(Icons.location_on, size: 16, color: Colors.grey),
                  const SizedBox(width: 4),
                  Text(
                    location!,
                    style: const TextStyle(fontSize: 13, color: Colors.grey),
                  ),
                  const SizedBox(width: 16),
                ],
                if (modality != null) ...[
                  const Icon(Icons.computer, size: 16, color: Colors.grey),
                  const SizedBox(width: 4),
                  Text(
                    modality!,
                    style: const TextStyle(fontSize: 13, color: Colors.grey),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    const months = [
      'ene', 'feb', 'mar', 'abr', 'may', 'jun',
      'jul', 'ago', 'sep', 'oct', 'nov', 'dic'
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }
}

*/