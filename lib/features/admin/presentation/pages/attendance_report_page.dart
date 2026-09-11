
import 'package:flutter/material.dart';

import '../../../../core/widgets/app_alert.dart';

class AttendanceReportPage extends StatefulWidget {
  const AttendanceReportPage({super.key});

  @override
  State<AttendanceReportPage> createState() => _AttendanceReportPageState();
}

class _AttendanceReportPageState extends State<AttendanceReportPage> {
  static const Color primaryColor = Color(0xFF2563EB);
  static const Color backgroundColor = Color(0xFFF7F9FC);
  static const Color textColor = Color(0xFF111827);
  static const Color secondaryTextColor = Color(0xFF6B7280);
  static const Color borderColor = Color(0xFFE5E7EB);

  String _search = '';
  String _selectedStatus = 'Todos';

  final TextEditingController _searchController = TextEditingController();

  // Datos temporales.
  // Posteriormente estos registros vendrán de SQLite.
  final List<AttendanceRecord> _records = [
    AttendanceRecord(
      participant: 'María Fernanda López',
      session: 'Inauguración del Congreso',
      date: '10/09/2026',
      time: '09:05',
      status: 'Asistió',
    ),
    AttendanceRecord(
      participant: 'Carlos Hernández García',
      session: 'Seguridad Informática',
      date: '10/09/2026',
      time: '10:32',
      status: 'Asistió',
    ),
    AttendanceRecord(
      participant: 'Ana Sofía Martínez',
      session: 'Desarrollo de Aplicaciones Móviles',
      date: '10/09/2026',
      time: '12:15',
      status: 'Asistió',
    ),
    AttendanceRecord(
      participant: 'Luis Alberto Ramírez',
      session: 'Seguridad Informática',
      date: '10/09/2026',
      time: '10:40',
      status: 'Asistió',
    ),
    AttendanceRecord(
      participant: 'Jorge Mendoza',
      session: 'Inauguración del Congreso',
      date: '10/09/2026',
      time: '--:--',
      status: 'No asistió',
    ),
  ];

  @override
  void initState() {
    super.initState();

    _searchController.addListener(() {
      setState(() {
        _search = _searchController.text.trim().toLowerCase();
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<AttendanceRecord> get _filteredRecords {
    return _records.where((record) {
      final matchesSearch =
          record.participant.toLowerCase().contains(_search) ||
          record.session.toLowerCase().contains(_search) ||
          record.date.toLowerCase().contains(_search);

      final matchesStatus =
          _selectedStatus == 'Todos' ||
          record.status == _selectedStatus;

      return matchesSearch && matchesStatus;
    }).toList();
  }

  int get _totalRecords => _records.length;

  int get _attendedRecords =>
      _records.where((record) => record.status == 'Asistió').length;

  int get _absentRecords =>
      _records.where((record) => record.status == 'No asistió').length;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: _buildAppBar(),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(),
                    const SizedBox(height: 20),
                    _buildSummary(),
                    const SizedBox(height: 20),
                    _buildSearchAndFilters(),
                    const SizedBox(height: 20),
                    _buildReportCard(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      leading: IconButton(
        onPressed: () => Navigator.pop(context),
        icon: const Icon(
          Icons.arrow_back_rounded,
          color: textColor,
        ),
      ),
      title: const Text(
        'Reporte de asistencia',
        style: TextStyle(
          color: textColor,
          fontSize: 19,
          fontWeight: FontWeight.w700,
        ),
      ),
      centerTitle: false,
      bottom: const PreferredSize(
        preferredSize: Size.fromHeight(1),
        child: Divider(
          height: 1,
          color: borderColor,
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: primaryColor.withOpacity(0.10),
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Icon(
                Icons.description_outlined,
                color: primaryColor,
                size: 26,
              ),
            ),
            const SizedBox(width: 14),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Reporte de asistencia',
                    style: TextStyle(
                      color: textColor,
                      fontSize: 23,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Consulta los registros de asistencia del congreso.',
                    style: TextStyle(
                      color: secondaryTextColor,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSummary() {
    return Row(
      children: [
        Expanded(
          child: _buildSummaryCard(
            title: 'Registros',
            value: '$_totalRecords',
            icon: Icons.receipt_long_outlined,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _buildSummaryCard(
            title: 'Asistencias',
            value: '$_attendedRecords',
            icon: Icons.check_circle_outline_rounded,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _buildSummaryCard(
            title: 'Ausencias',
            value: '$_absentRecords',
            icon: Icons.cancel_outlined,
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryCard({
    required String title,
    required String value,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: primaryColor,
            size: 21,
          ),
          const SizedBox(height: 10),
          Text(
            value,
            style: const TextStyle(
              color: textColor,
              fontSize: 22,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            title,
            style: const TextStyle(
              color: secondaryTextColor,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchAndFilters() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        children: [
          TextField(
            controller: _searchController,
            style: const TextStyle(
              color: textColor,
              fontSize: 14,
            ),
            decoration: InputDecoration(
              hintText: 'Buscar participante, sesión o fecha...',
              hintStyle: const TextStyle(
                color: secondaryTextColor,
                fontSize: 14,
              ),
              prefixIcon: const Icon(
                Icons.search_rounded,
                color: secondaryTextColor,
              ),
              suffixIcon: _search.isNotEmpty
                  ? IconButton(
                      onPressed: () {
                        _searchController.clear();
                      },
                      icon: const Icon(
                        Icons.close_rounded,
                        color: secondaryTextColor,
                      ),
                    )
                  : null,
              filled: true,
              fillColor: backgroundColor,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(13),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(13),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(13),
                borderSide: const BorderSide(
                  color: primaryColor,
                  width: 1.2,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Text(
                'Estado:',
                style: TextStyle(
                  color: textColor,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Wrap(
                  spacing: 8,
                  children: [
                    _buildStatusFilter('Todos'),
                    _buildStatusFilter('Asistió'),
                    _buildStatusFilter('No asistió'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusFilter(String status) {
    final selected = _selectedStatus == status;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedStatus = status;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 8,
        ),
        decoration: BoxDecoration(
          color: selected
              ? primaryColor
              : backgroundColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected
                ? primaryColor
                : borderColor,
          ),
        ),
        child: Text(
          status,
          style: TextStyle(
            color: selected
                ? Colors.white
                : secondaryTextColor,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildReportCard() {
    final records = _filteredRecords;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 18, 18, 14),
            child: Row(
              children: [
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Registros de asistencia',
                        style: TextStyle(
                          color: textColor,
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Participante, sesión, fecha, hora y estado',
                        style: TextStyle(
                          color: secondaryTextColor,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  tooltip: 'Exportar reporte',
                  onPressed: _exportReport,
                  icon: const Icon(
                    Icons.download_outlined,
                    color: primaryColor,
                  ),
                ),
              ],
            ),
          ),
          const Divider(
            height: 1,
            color: borderColor,
          ),
          if (records.isEmpty)
            _buildEmptyState()
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: records.length,
              separatorBuilder: (_, __) => const Divider(
                height: 1,
                color: borderColor,
              ),
              itemBuilder: (context, index) {
                return _buildAttendanceItem(records[index]);
              },
            ),
        ],
      ),
    );
  }

  Widget _buildAttendanceItem(AttendanceRecord record) {
    final attended = record.status == 'Asistió';

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: primaryColor.withOpacity(0.10),
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Text(
              _getInitials(record.participant),
              style: const TextStyle(
                color: primaryColor,
                fontSize: 13,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  record.participant,
                  style: const TextStyle(
                    color: textColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  record.session,
                  style: const TextStyle(
                    color: secondaryTextColor,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 9),
                Wrap(
                  spacing: 12,
                  runSpacing: 6,
                  children: [
                    _buildInfoItem(
                      Icons.calendar_today_outlined,
                      record.date,
                    ),
                    _buildInfoItem(
                      Icons.access_time_rounded,
                      record.time,
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          _buildStatusBadge(
            record.status,
            attended,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem(
    IconData icon,
    String value,
  ) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 14,
          color: secondaryTextColor,
        ),
        const SizedBox(width: 4),
        Text(
          value,
          style: const TextStyle(
            color: secondaryTextColor,
            fontSize: 11,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildStatusBadge(
    String status,
    bool attended,
  ) {
    final color = attended
        ? Colors.green
        : Colors.red;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 9,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.10),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            attended
                ? Icons.check_circle_rounded
                : Icons.cancel_rounded,
            size: 14,
            color: color,
          ),
          const SizedBox(width: 4),
          Text(
            status,
            style: TextStyle(
              color: color,
              fontSize: 10,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Padding(
      padding: const EdgeInsets.all(35),
      child: Column(
        children: [
          Icon(
            Icons.search_off_rounded,
            size: 45,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 12),
          const Text(
            'No se encontraron registros',
            style: TextStyle(
              color: textColor,
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 5),
          const Text(
            'Intenta modificar los filtros de búsqueda.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: secondaryTextColor,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  String _getInitials(String name) {
    final parts = name.trim().split(' ');

    if (parts.length == 1) {
      return parts.first.substring(0, 1).toUpperCase();
    }

    return '${parts.first[0]}${parts[1][0]}'.toUpperCase();
  }

  void _exportReport() {
    AppAlert.show(
      context,
      title: 'Exportación',
      message:
          'La consulta está lista. La exportación a PDF/CSV se integrará con el almacenamiento de asistencia.',
      type: AppAlertType.info,
    );
  }
}

class AttendanceRecord {
  final String participant;
  final String session;
  final String date;
  final String time;
  final String status;

  const AttendanceRecord({
    required this.participant,
    required this.session,
    required this.date,
    required this.time,
    required this.status,
  });
}

