import 'package:agora_flutter_quickstart/components/interpreterContainer.dart';
import 'package:agora_flutter_quickstart/components/interpreterModal.dart';
import 'package:flutter/material.dart';

Container interpretersListContainer(
    BuildContext context, List interpretersList,String accessToken,) {
  return Container(
    child: ListView.builder(
        itemCount: interpretersList == null ? 0 : interpretersList.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              showModalBottomSheet(
                  context: context,
                  builder: (BuildContext context) {
                    return InterpreterModalContainer(
                        interpretersList[index].name,
                        interpretersList[index].location,
                        interpretersList[index].account_type,
                        interpretersList[index].rate,
                        context, accessToken,
                        interpretersList[index].device, interpretersList[index].id);
                  });
            },
            child: Container(
              padding: EdgeInsets.all(5),
            ),
          );
        }),
  );
}
