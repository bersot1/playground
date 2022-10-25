import 'package:flutter/material.dart';

class SemanticsPlayground extends StatefulWidget {
  const SemanticsPlayground({Key? key}) : super(key: key);

  @override
  State<SemanticsPlayground> createState() => _SemanticsPlaygroundState();
}

class _SemanticsPlaygroundState extends State<SemanticsPlayground> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text('Lorem Ipsum is simply dummy text of the printing and typesetting industry. m'),
          const SizedBox(
            height: 40,
          ),
          Semantics(
            label:
                'Terms and Conditions. BMW Financial Services offers My BMW financial services in accordance with there TErms and Conditions. read all terms & conditions (pdf)',
            excludeSemantics: true,
            child: ListTile(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Terms and Conditions'),
                  Semantics(label: 'read all privacy policy (PDF).', child: Icon(Icons.chevron_right_outlined)),
                ],
              ),
              subtitle: const Text(
                  'BMW Financial Services offers My BMW financial services in accordance with there TErms and Conditions.'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: 14.0,
              top: 14,
              bottom: 14,
            ),
            child: Row(
              children: [
                Icon(Icons.square),
                Text('I agree there terms and conditions'),
              ],
            ),
          ),
          ListTile(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('PRIVACY POLICY'),
                Semantics(label: 'read all privacy policy (PDF)', child: Icon(Icons.chevron_right_outlined)),
              ],
            ),
            subtitle: const Text(
                'BMW Fincnail services collects and processes yout personal data to provide the My BMW Financial Services features. The privacy policy describes the data and how it is used.'),
          ),
        ],
      ),
    );
  }
}
