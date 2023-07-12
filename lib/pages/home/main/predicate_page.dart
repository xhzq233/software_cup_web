// import 'package:get/get.dart';
// import 'package:software_cup_web/pages/home/main/main_index.dart';
// import 'package:flutter/material.dart';
// import 'package:software_cup_web/pages/home/main/table.dart';
//
// import '../../../http_api/model.dart';
// import '../../../http_api/storage.dart';
//
// const _kIndex = MainPageIndex.predicate;
//
// class PredicatePage extends StatefulWidget {
//   const PredicatePage({super.key});
//
//   @override
//   State<PredicatePage> createState() => _PredicatePageState();
// }
//
// class _PredicatePageState extends State<PredicatePage> {
//   final searchString = ''.obs;
//   final Set<DataSet> selected = {};
//
//   Widget _buildBody() {
//     final list = storageProvider.dataSetListResponse.value;
//     if (list == null) {
//       return const SizedBox();
//     }
//     final key = searchString.value;
//     final copied = list.datasetList.where((element) => element.name.contains(key)).toList();
//     return SCTable(data: copied, selectAble: false, selected: selected);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     final textTheme = theme.textTheme;
//
//     return Column(
//       children: [
//         Row(
//           mainAxisAlignment: MainAxisAlignment.start,
//           crossAxisAlignment: CrossAxisAlignment.end,
//           children: [
//             Text(_kIndex.pageTitle, style: textTheme.headlineLarge),
//             width16,
//             Text(_kIndex.description, style: textTheme.titleLarge)
//           ],
//         ),
//         width16,
//         Row(
//           children: [
//             const Spacer(),
//             ConstrainedBox(
//               constraints: const BoxConstraints(maxWidth: 168, minWidth: 0, maxHeight: 44, minHeight: 44),
//               child: TextField(
//                 decoration: InputDecoration(
//                   contentPadding: const EdgeInsets.symmetric(horizontal: 8),
//                   hintText: _kIndex.searchLabel,
//                   border: const OutlineInputBorder(),
//                 ),
//                 onChanged: searchString.call,
//               ),
//             ),
//           ],
//         ),
//         Expanded(
//           child: Container(
//             margin: const EdgeInsets.symmetric(vertical: 16),
//             decoration: BoxDecoration(border: Border.all(width: 1.5), borderRadius: BorderRadius.circular(8)),
//             width: double.infinity,
//             child: SingleChildScrollView(
//                 child: SingleChildScrollView(scrollDirection: Axis.horizontal, child: Obx(_buildBody))),
//           ),
//         )
//       ],
//     );
//   }
// }
