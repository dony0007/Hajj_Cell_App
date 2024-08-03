import 'package:flutter/material.dart';
import 'package:hidayath/pages/DashboardScreen.dart';
import 'package:hive/hive.dart';


class TermsConditionsPage extends StatefulWidget {
  const TermsConditionsPage({super.key});

  @override
  _TermsConditionsPageState createState() => _TermsConditionsPageState();
}

class _TermsConditionsPageState extends State<TermsConditionsPage> {
  bool _isChecked = false;

  Future<void> _acceptTerms(BuildContext context) async {
    var box = Hive.box('settings');
    await box.put('acceptedTerms', true);

    // Navigate to the home page and replace the current page
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const DashboardScreen()));
  }

  // Function to handle rejection of terms (customize as needed)
  void _rejectTerms(BuildContext context) {
    // You can close the app, show a message, or perform another action
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF29A7B7),
        title: const Text('Terms and Conditions', style: TextStyle(color: Colors.white),),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            const Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('KMCC Hajj Cell - Terms and Conditions', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),),
                    SizedBox(height: 10,),
                    Text(
                              'Welcome to KMCC Hajj Cell, a mobile application designed to assist Hajj volunteers and pilgrims during the Hajj pilgrimage. By downloading and using this application, you agree to abide by the following terms and conditions:\n\n'
                                  '1. Acceptance of Terms\n'
                                  'By downloading, installing, or using the KMCC Hajj Cell app, you acknowledge that you have read, understood, and agree to be bound by these terms and conditions.\n\n'

                                  '2. App Purpose\n'
                                  'KMCC Hajj Cell is designed to provide information and assistance to Hajj volunteers and pilgrims. The app includes details about Hajj Mina Camps, poll numbers, camp numbers, street numbers, train stations, mosques, hospitals, and healthcare facilities. Additionally, it offers various utilities to aid pilgrims during their journey.\n\n'

                                  '3. User Responsibilities\n'
                                  'Users are responsible for the accuracy and security of the information they provide while using the KMCC Hajj Cell app.\n'
                                  'Users agree not to misuse, modify, or interfere with the functionality of the app in any way that may compromise its integrity or the experience of other users.\n'
                                  'Users must comply with all applicable laws and regulations while using the app.\n\n'

                                  '4. Privacy Policy\n'
                                  'KMCC Hajj Cell respects the privacy of its users. Our Privacy Policy outlines how we collect, use, and protect your personal information. By using the app, you consent to the collection and use of your information as described in the Privacy Policy.\n\n'

                                  '5. Intellectual Property\n'
                                  'All content and materials available through the KMCC Hajj Cell app, including but not limited to text, graphics, logos, images, and software, are the property of KMCC Hajj Cell or its licensors and are protected by copyright and other intellectual property laws.\n\n'

                                  '6. Disclaimer of Warranty\n'
                                  'The KMCC Hajj Cell app is provided "as is" without any warranties, express or implied. While we strive to provide accurate and up-to-date information, we make no representations or warranties of any kind, whether express or implied, regarding the accuracy, reliability, or completeness of the information provided through the app.\n\n'

                                  '7. Limitation of Liability\n'
                                  'In no event shall KMCC Hajj Cell or its affiliates be liable for any direct, indirect, incidental, special, or consequential damages arising out of or in any way connected with the use or inability to use the KMCC Hajj Cell app, even if advised of the possibility of such damages.\n\n'

                                  '8. Modifications to Terms\n'
                                  'KMCC Hajj Cell reserves the right to modify or update these terms and conditions at any time without prior notice. Continued use of the app after any such changes shall constitute your acceptance of the modified terms.\n\n'

                                  '9. Governing Law\n'
                                  'These terms and conditions shall be governed by and construed in accordance with the laws of [Jurisdiction], without regard to its conflict of law provisions.\n\n'

                                  '10. Contact Us\n'
                                  'If you have any questions or concerns about these terms and conditions, please contact us at [Contact Information].\n\n'
                                  'By using the KMCC Hajj Cell app, you agree to these terms and conditions. If you do not agree with any part of these terms, you may not use the app.'
                      // Add more terms and conditions as needed
                    ),
                  ],
                ),
              ),
            ),
            Row(
              children: <Widget>[
                Checkbox(
                  checkColor: Colors.white,
                  activeColor: const Color(0xFF29A7B7),
                  value: _isChecked,
                  onChanged: (bool? value) {
                    setState(() {
                      _isChecked = value!;
                    });
                  },
                  // Background color of the checkbox, // Check color of the checkbox
                ),
                const Expanded(
                  child: Text('I agree to the terms and conditions'),
                ),
              ],
            ),
            const SizedBox(height: 5),
            ElevatedButton(
              onPressed: _isChecked
                  ? () {
                _acceptTerms(context);
              }
                  : null,
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: const Color(0xFF29A7B7), // Text color
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                textStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              child: const Text('Accept and Continue'),
            ),
            const SizedBox(height: 5),
          ],
        ),
      ),
    );
  }
}