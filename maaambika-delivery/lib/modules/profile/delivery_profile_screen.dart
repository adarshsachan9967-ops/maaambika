import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class DeliveryProfileScreen extends StatefulWidget {
  const DeliveryProfileScreen({super.key});

  @override
  State<DeliveryProfileScreen> createState() => _DeliveryProfileScreenState();
}

class _DeliveryProfileScreenState extends State<DeliveryProfileScreen> {
  String _name = 'Raghu Sharma';
  String _phone = '9876543210';
  String _email = 'raghu.sharma@demo.com';
  String _address = 'Koramangala, Bengaluru – 560034';
  String _vehicleType = 'Bike';
  String _vehicleNumber = 'KA01AB5566';

  void _callSupport() async {
    final uri = Uri.parse('tel:+918260120467');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  void _showEditPersonalModal() {
    final nameCtrl = TextEditingController(text: _name);
    final phoneCtrl = TextEditingController(text: _phone);
    final emailCtrl = TextEditingController(text: _email);
    final addrCtrl = TextEditingController(text: _address);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Edit Personal Information', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(ctx)),
                ],
              ),
              const SizedBox(height: 12),
              TextField(controller: nameCtrl, decoration: InputDecoration(labelText: 'Full Name', border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)))),
              const SizedBox(height: 10),
              TextField(controller: phoneCtrl, decoration: InputDecoration(labelText: 'Phone Number', border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)))),
              const SizedBox(height: 10),
              TextField(controller: emailCtrl, decoration: InputDecoration(labelText: 'Email Address', border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)))),
              const SizedBox(height: 10),
              TextField(controller: addrCtrl, decoration: InputDecoration(labelText: 'Residential Address', border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)))),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _name = nameCtrl.text.trim();
                      _phone = phoneCtrl.text.trim();
                      _email = emailCtrl.text.trim();
                      _address = addrCtrl.text.trim();
                    });
                    Navigator.pop(ctx);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Personal profile updated successfully!'), backgroundColor: Color(0xFF059669)),
                    );
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF059669), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                  child: const Text('Save Changes', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showEditVehicleModal() {
    final vNumCtrl = TextEditingController(text: _vehicleNumber);
    String vType = _vehicleType;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setMState) => Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Edit Vehicle Information', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(ctx)),
                  ],
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  initialValue: vType,
                  decoration: InputDecoration(labelText: 'Vehicle Type', border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
                  items: ['Bike', 'Scooter', 'EV Bike', 'Van']
                      .map((t) => DropdownMenuItem(value: t, child: Text(t)))
                      .toList(),
                  onChanged: (v) {
                    if (v != null) setMState(() => vType = v);
                  },
                ),
                const SizedBox(height: 12),
                TextField(controller: vNumCtrl, decoration: InputDecoration(labelText: 'Registration Number', border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)))),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _vehicleType = vType;
                        _vehicleNumber = vNumCtrl.text.trim();
                      });
                      Navigator.pop(ctx);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Vehicle details updated successfully!'), backgroundColor: Color(0xFF059669)),
                      );
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF059669), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                    child: const Text('Save Vehicle Details', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── DRIVER PROFILE CARD (MATCHING REFERENCE UI) ──
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF047857), Color(0xFF065F46), Color(0xFF064E3B)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF065F46).withValues(alpha: 0.35),
                    blurRadius: 14,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Avatar with Camera Icon
                      Stack(
                        children: [
                          Container(
                            width: 68,
                            height: 68,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: const Color(0xFF34D399), width: 2.5),
                              color: const Color(0xFF064E3B),
                            ),
                            child: const ClipOval(
                              child: Icon(Icons.person, color: Colors.white, size: 38),
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              width: 22,
                              height: 22,
                              decoration: BoxDecoration(
                                color: const Color(0xFF10B981),
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.white, width: 2),
                              ),
                              child: const Icon(Icons.camera_alt, color: Colors.white, size: 11),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 14),
                      // Details
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _name,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 2),
                            const Text(
                              'Agent ID: DLV-001',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.white70,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 5),
                            const Row(
                              children: [
                                Icon(Icons.star_rounded, color: Color(0xFFFBBF24), size: 16),
                                SizedBox(width: 3),
                                Text(
                                  '4.9',
                                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                                ),
                                SizedBox(width: 4),
                                Text(
                                  '(840 trips)',
                                  style: TextStyle(color: Colors.white70, fontSize: 11),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const Icon(Icons.chevron_right, color: Colors.white54, size: 20),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.circle, color: Color(0xFF10B981), size: 9),
                          SizedBox(width: 5),
                          Text(
                            'Active Partner',
                            style: TextStyle(color: Color(0xFFD1FAE5), fontSize: 12, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      ElevatedButton.icon(
                        onPressed: _showEditPersonalModal,
                        icon: const Icon(Icons.edit_outlined, size: 14, color: Color(0xFF065F46)),
                        label: const Text(
                          'Edit Profile',
                          style: TextStyle(color: Color(0xFF065F46), fontWeight: FontWeight.bold, fontSize: 12),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 14),

            // ── KYC VERIFICATION CARD ──
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFFFFBEB),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFFDE68A)),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF59E0B),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.verified_user_rounded, color: Colors.white, size: 22),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Text(
                              'KYC Verification',
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF0F172A)),
                            ),
                            const SizedBox(width: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: const Color(0xFFDCFCE7),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: const Row(
                                children: [
                                  Icon(Icons.check, color: Color(0xFF15803D), size: 11),
                                  SizedBox(width: 2),
                                  Text(
                                    'Verified',
                                    style: TextStyle(color: Color(0xFF15803D), fontSize: 10, fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 3),
                        const Text(
                          'Aadhaar, Driving License, Vehicle RC verified',
                          style: TextStyle(fontSize: 11, color: Color(0xFF78350F)),
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.chevron_right, color: Color(0xFFB45309), size: 20),
                ],
              ),
            ),

            const SizedBox(height: 18),

            // ── PERSONAL INFORMATION ──
            _buildSectionHeader('Personal Information', onEdit: _showEditPersonalModal),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Column(
                children: [
                  _buildInfoRow(Icons.person_outline, 'Full Name', _name),
                  const Divider(height: 20, color: Color(0xFFF1F5F9)),
                  _buildInfoRow(Icons.phone_outlined, 'Phone Number', _phone),
                  const Divider(height: 20, color: Color(0xFFF1F5F9)),
                  _buildInfoRow(Icons.email_outlined, 'Email', _email),
                  const Divider(height: 20, color: Color(0xFFF1F5F9)),
                  _buildInfoRow(Icons.location_on_outlined, 'Address', _address),
                ],
              ),
            ),

            const SizedBox(height: 18),

            // ── VEHICLE INFORMATION ──
            _buildSectionHeader('Vehicle Information', onEdit: _showEditVehicleModal),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Column(
                children: [
                  _buildInfoRow(Icons.two_wheeler_outlined, 'Vehicle Type', _vehicleType),
                  const Divider(height: 20, color: Color(0xFFF1F5F9)),
                  _buildInfoRow(Icons.badge_outlined, 'Vehicle Number', _vehicleNumber),
                  const Divider(height: 20, color: Color(0xFFF1F5F9)),
                  _buildStatusRow(Icons.shield_outlined, 'Insurance Status', 'Valid', const Color(0xFFDCFCE7), const Color(0xFF15803D)),
                  const Divider(height: 20, color: Color(0xFFF1F5F9)),
                  _buildInfoRow(Icons.calendar_today_outlined, 'PUC Valid Till', '15 Mar 2027'),
                  const Divider(height: 20, color: Color(0xFFF1F5F9)),
                  _buildStatusRow(Icons.description_outlined, 'RC Details', 'Verified', const Color(0xFFDCFCE7), const Color(0xFF15803D)),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // ── QUICK TILES: DOCUMENTS & SAFETY ──
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.folder_shared_outlined, color: Color(0xFF2563EB), size: 20),
                        SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Documents', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF0F172A))),
                              Text('View & Manage', style: TextStyle(fontSize: 10, color: Color(0xFF64748B))),
                            ],
                          ),
                        ),
                        Icon(Icons.chevron_right, color: Color(0xFF94A3B8), size: 16),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.shield_outlined, color: Color(0xFF059669), size: 20),
                        SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Safety & Support', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF0F172A))),
                              Text('Emergency, Rules', style: TextStyle(fontSize: 10, color: Color(0xFF64748B))),
                            ],
                          ),
                        ),
                        Icon(Icons.chevron_right, color: Color(0xFF94A3B8), size: 16),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // ── NEED HELP BANNER ──
            InkWell(
              onTap: _callSupport,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFF0FDF4),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFBBF7D0)),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.headset_mic_rounded, color: Color(0xFF059669), size: 24),
                    SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Need Help?', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF065F46))),
                          Text('Contact Support', style: TextStyle(fontSize: 11, color: Color(0xFF166534))),
                        ],
                      ),
                    ),
                    Text(
                      '+91 8260120467',
                      style: TextStyle(color: Color(0xFF059669), fontWeight: FontWeight.bold, fontSize: 12),
                    ),
                    SizedBox(width: 4),
                    Icon(Icons.chevron_right, color: Color(0xFF059669), size: 18),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, {required VoidCallback onEdit}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
        ),
        InkWell(
          onTap: onEdit,
          child: const Row(
            children: [
              Icon(Icons.edit_outlined, size: 14, color: Color(0xFF059669)),
              SizedBox(width: 4),
              Text(
                'Edit',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF059669)),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 18, color: const Color(0xFF64748B)),
        const SizedBox(width: 12),
        Text(label, style: const TextStyle(fontSize: 13, color: Color(0xFF64748B))),
        const Spacer(),
        Expanded(
          flex: 2,
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF0F172A)),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildStatusRow(IconData icon, String label, String status, Color bg, Color text) {
    return Row(
      children: [
        Icon(icon, size: 18, color: const Color(0xFF64748B)),
        const SizedBox(width: 12),
        Text(label, style: const TextStyle(fontSize: 13, color: Color(0xFF64748B))),
        const Spacer(),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(6)),
          child: Text(status, style: TextStyle(color: text, fontSize: 11, fontWeight: FontWeight.bold)),
        ),
        const SizedBox(width: 4),
        const Icon(Icons.chevron_right, size: 16, color: Color(0xFF94A3B8)),
      ],
    );
  }
}
