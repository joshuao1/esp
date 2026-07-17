// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:language_app/data/vocab_dao.dart';
// import 'package:language_app/notifier/vocab_notifier.dart';
// import 'package:language_app/notifier/vocab_trainer_notifier.dart';
// import 'package:language_app/widget/vocab_train_page.dart';
// import 'package:provider/provider.dart';

// class VocabSelectPage extends StatefulWidget {
//   const VocabSelectPage({super.key});

//   @override
//   State<VocabSelectPage> createState() => _VocabSelectPageState();
// }

// class _VocabSelectPageState extends State<VocabSelectPage> {
//   final Map<String, bool> vocabGroups = {
//     'a': false,
//     'ka': false,
//     'sa': false,
//     'ta': false,
//     'na': false,
//     'ha': false,
//     'ma': false,
//     'ya': false,
//     'ra': false,
//     'wa': false,
//     'ga': false,
//     'za': false,
//     'da': false,
//     'ba': false,
//     'pa': false,
//     'kya': false,
//     'sha': false,
//     'cha': false,
//     'nya': false,
//     'hya': false,
//     'mya': false,
//     'rya': false,
//     'gya': false,
//     'ja': false,
//     'bya': false,
//     'pya': false,
//   };

//   List<String> get selectedGroups =>
//       vocabGroups.entries.where((e) => e.value).map((e) => e.key).toList();

//   bool get allSelected =>
//       vocabGroups.values.every((isSelected) => isSelected);

//   void toggleSelectAll() {
//     setState(() {
//       final newValue = !allSelected;
//       vocabGroups.updateAll((_, _) => newValue);
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final vocabNotifier = context.watch<VocabNotifier>();

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Select Vocabs'),
//         actions: [
//           TextButton(
//             onPressed: toggleSelectAll,
//             child: Text(allSelected ? 'Clear all' : 'Select all'),
//           ),
//         ],
//       ),
//       body: SafeArea(
//         child: ListView(
//           children: vocabGroups.entries.map((entry) {
//             return CheckboxListTile(
//               title: Text(entry.key),
//               value: entry.value,
//               onChanged: (checked) {
//                 setState(() {
//                   vocabGroups[entry.key] = checked!;
//                 });
//               },
//             );
//           }).toList(),
//         ),
//       ),
//       bottomNavigationBar: Container(
//         padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
//         child: ElevatedButton.icon(
//           style: ElevatedButton.styleFrom(padding: EdgeInsets.all(20)),
//           onPressed: selectedGroups.isEmpty
//               ? null
//               : () => Navigator.push(
//                   context,
//                   CupertinoPageRoute(
//                     builder: (context) => ChangeNotifierProvider(
//                       create: (context) {
//                         final vocabNotifier = context
//                             .read<VocabNotifier>();
//                         return VocabTrainerNotifier(
//                           vocabs: vocabNotifier.vocabs
//                               .where(
//                                 (char) => selectedGroups.contains(
//                                   char.vocabGroup,
//                                 ),
//                               )
//                               .toList(),
//                           vocabDao: context.read<VocabDao>(),
//                         );
//                       },
//                       child: VocabTrainerPage(),
//                     ),
//                   ),
//                 ),
//           label: Text(
//             selectedGroups.isEmpty ? "Select a group" : "Start Training",
//             style: TextStyle(fontSize: 16),
//           ),
//         ),
//       ),
//     );
//   }
// }
