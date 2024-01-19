import 'package:flutter/material.dart';
import 'package:shopping_app/components/dismissible/MyDismissibleFunctions.dart';
import 'package:shopping_app/functions/providers/items/MyItemsProvider.dart';

import '../../objects/groups/MyGroup.dart';
import '../../objects/products/MyProduct.dart';
import '../group/MyGroupItem.dart';
import '../home/MyBasicStructItem.dart';
import '../product/MyProductItem.dart';

/**
 * Its the widget item, which can you swipe to the side.
 * Its for the MyGroup and MyProduct items
 * */

class MyDismissibleWidget extends StatelessWidget {
  final bool isGroup;
  final List<MyGroup> groupsFromUser;
  final List<MyProduct> productsFromSelectedGroup;
  final int itemIndex;
  final int selectedGroupIndex;
  final MyItemsProvider itemsValue;

  const MyDismissibleWidget({
    Key? key,
    required this.isGroup,
    required this.groupsFromUser,
    required this.itemIndex,
    required this.selectedGroupIndex,
    required this.itemsValue,
    required this.productsFromSelectedGroup,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: isGroup
          ? Key(groupsFromUser[itemIndex].groupUUID!)
          : Key(productsFromSelectedGroup[itemIndex].productID!),
      direction: DismissDirection.endToStart,
      background: buildDismissBackground(),
      onDismissed: (direction) => onDismissedFunction(context),
      child: buildMyBasicStructItem(context),
    );
  }

  Widget buildDismissBackground() {
    return Container(
      color: Colors.red[300],
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.only(right: 20.0),
      child: const Icon(
        Icons.delete,
        color: Colors.white,
      ),
    );
  }

  void onDismissedFunction(BuildContext context) async {

    ///TODO: Hier gucken: Wenn man die Gruppe löschen möchte. Dann kommt der Dialog man dann wartet und jemand etwas bei Produkten oder Gruppen ändert dann kommt der fehler
    /*
    * ======== Exception caught by widgets library =======================================================
The following assertion was thrown building Dismissible-[<'jduwVgl99ZutE2lXqhfS'>](dependencies: [Directionality], state: _DismissibleState#3bd2d(tickers: tracking 2 tickers)):
A dismissed Dismissible widget is still part of the tree.


Make sure to implement the onDismissed handler and to immediately remove the Dismissible widget from the application once that handler has fired.

The relevant error-causing widget was:
  Dismissible-[<'jduwVgl99ZutE2lXqhfS'>] Dismissible:file:///home/moo/Documents/apps/shoppingapp/lib/components/dismissible/MyDismissibleWidget.dart:36:12
When the exception was thrown, this was the stack:
#0      _DismissibleState.build.<anonymous closure> (package:flutter/src/widgets/dismissible.dart:629:11)
#1      _DismissibleState.build (package:flutter/src/widgets/dismissible.dart:638:8)
#2      StatefulElement.build (package:flutter/src/widgets/framework.dart:5583:27)
#3      ComponentElement.performRebuild (package:flutter/src/widgets/framework.dart:5471:15)
#4      StatefulElement.performRebuild (package:flutter/src/widgets/framework.dart:5634:11)
#5      Element.rebuild (package:flutter/src/widgets/framework.dart:5187:7)
#6      StatefulElement.update (package:flutter/src/widgets/framework.dart:5657:5)
#7      Element.updateChild (package:flutter/src/widgets/framework.dart:3815:15)
#8      ComponentElement.performRebuild (package:flutter/src/widgets/framework.dart:5496:16)
#9      Element.rebuild (package:flutter/src/widgets/framework.dart:5187:7)
#10     StatelessElement.update (package:flutter/src/widgets/framework.dart:5547:5)
#11     Element.updateChild (package:flutter/src/widgets/framework.dart:3815:15)
#12     SingleChildRenderObjectElement.update (package:flutter/src/widgets/framework.dart:6743:14)
#13     Element.updateChild (package:flutter/src/widgets/framework.dart:3815:15)
#14     SingleChildRenderObjectElement.update (package:flutter/src/widgets/framework.dart:6743:14)
#15     Element.updateChild (package:flutter/src/widgets/framework.dart:3815:15)
#16     ComponentElement.performRebuild (package:flutter/src/widgets/framework.dart:5496:16)
#17     StatefulElement.performRebuild (package:flutter/src/widgets/framework.dart:5634:11)
#18     Element.rebuild (package:flutter/src/widgets/framework.dart:5187:7)
#19     StatefulElement.update (package:flutter/src/widgets/framework.dart:5657:5)
#20     Element.updateChild (package:flutter/src/widgets/framework.dart:3815:15)
#21     ComponentElement.performRebuild (package:flutter/src/widgets/framework.dart:5496:16)
#22     Element.rebuild (package:flutter/src/widgets/framework.dart:5187:7)
#23     ProxyElement.update (package:flutter/src/widgets/framework.dart:5800:5)
#24     Element.updateChild (package:flutter/src/widgets/framework.dart:3815:15)
#25     ComponentElement.performRebuild (package:flutter/src/widgets/framework.dart:5496:16)
#26     Element.rebuild (package:flutter/src/widgets/framework.dart:5187:7)
#27     ProxyElement.update (package:flutter/src/widgets/framework.dart:5800:5)
#28     Element.updateChild (package:flutter/src/widgets/framework.dart:3815:15)
#29     ComponentElement.performRebuild (package:flutter/src/widgets/framework.dart:5496:16)
#30     StatefulElement.performRebuild (package:flutter/src/widgets/framework.dart:5634:11)
#31     Element.rebuild (package:flutter/src/widgets/framework.dart:5187:7)
#32     StatefulElement.update (package:flutter/src/widgets/framework.dart:5657:5)
#33     Element.updateChild (package:flutter/src/widgets/framework.dart:3815:15)
#34     ComponentElement.performRebuild (package:flutter/src/widgets/framework.dart:5496:16)
#35     Element.rebuild (package:flutter/src/widgets/framework.dart:5187:7)
#36     StatelessElement.update (package:flutter/src/widgets/framework.dart:5547:5)
#37     Element.updateChild (package:flutter/src/widgets/framework.dart:3815:15)
#38     SliverMultiBoxAdaptorElement.updateChild (package:flutter/src/widgets/sliver.dart:858:37)
#39     SliverMultiBoxAdaptorElement.performRebuild.processElement (package:flutter/src/widgets/sliver.dart:759:35)
#40     Iterable.forEach (dart:core/iterable.dart:347:35)
#41     SliverMultiBoxAdaptorElement.performRebuild (package:flutter/src/widgets/sliver.dart:806:24)
#42     SliverMultiBoxAdaptorElement.update (package:flutter/src/widgets/sliver.dart:735:7)
#43     Element.updateChild (package:flutter/src/widgets/framework.dart:3815:15)
#44     ComponentElement.performRebuild (package:flutter/src/widgets/framework.dart:5496:16)
#45     Element.rebuild (package:flutter/src/widgets/framework.dart:5187:7)
#46     ProxyElement.update (package:flutter/src/widgets/framework.dart:5800:5)
#47     Element.updateChild (package:flutter/src/widgets/framework.dart:3815:15)
#48     SingleChildRenderObjectElement.update (package:flutter/src/widgets/framework.dart:6743:14)
#49     Element.updateChild (package:flutter/src/widgets/framework.dart:3815:15)
#50     Element.updateChildren (package:flutter/src/widgets/framework.dart:3964:32)
#51     MultiChildRenderObjectElement.update (package:flutter/src/widgets/framework.dart:6896:17)
#52     Element.updateChild (package:flutter/src/widgets/framework.dart:3815:15)
#53     SingleChildRenderObjectElement.update (package:flutter/src/widgets/framework.dart:6743:14)
#54     Element.updateChild (package:flutter/src/widgets/framework.dart:3815:15)
#55     SingleChildRenderObjectElement.update (package:flutter/src/widgets/framework.dart:6743:14)
#56     Element.updateChild (package:flutter/src/widgets/framework.dart:3815:15)
#57     SingleChildRenderObjectElement.update (package:flutter/src/widgets/framework.dart:6743:14)
#58     Element.updateChild (package:flutter/src/widgets/framework.dart:3815:15)
#59     SingleChildRenderObjectElement.update (package:flutter/src/widgets/framework.dart:6743:14)
#60     Element.updateChild (package:flutter/src/widgets/framework.dart:3815:15)
#61     ComponentElement.performRebuild (package:flutter/src/widgets/framework.dart:5496:16)
#62     StatefulElement.performRebuild (package:flutter/src/widgets/framework.dart:5634:11)
#63     Element.rebuild (package:flutter/src/widgets/framework.dart:5187:7)
#64     StatefulElement.update (package:flutter/src/widgets/framework.dart:5657:5)
#65     Element.updateChild (package:flutter/src/widgets/framework.dart:3815:15)
#66     SingleChildRenderObjectElement.update (package:flutter/src/widgets/framework.dart:6743:14)
#67     Element.updateChild (package:flutter/src/widgets/framework.dart:3815:15)
#68     ComponentElement.performRebuild (package:flutter/src/widgets/framework.dart:5496:16)
#69     Element.rebuild (package:flutter/src/widgets/framework.dart:5187:7)
#70     ProxyElement.update (package:flutter/src/widgets/framework.dart:5800:5)
#71     Element.updateChild (package:flutter/src/widgets/framework.dart:3815:15)
#72     SingleChildRenderObjectElement.update (package:flutter/src/widgets/framework.dart:6743:14)
#73     Element.updateChild (package:flutter/src/widgets/framework.dart:3815:15)
#74     ComponentElement.performRebuild (package:flutter/src/widgets/framework.dart:5496:16)
#75     Element.rebuild (package:flutter/src/widgets/framework.dart:5187:7)
#76     ProxyElement.update (package:flutter/src/widgets/framework.dart:5800:5)
#77     Element.updateChild (package:flutter/src/widgets/framework.dart:3815:15)
#78     SingleChildRenderObjectElement.update (package:flutter/src/widgets/framework.dart:6743:14)
#79     Element.updateChild (package:flutter/src/widgets/framework.dart:3815:15)
#80     SingleChildRenderObjectElement.update (package:flutter/src/widgets/framework.dart:6743:14)
#81     Element.updateChild (package:flutter/src/widgets/framework.dart:3815:15)
#82     ComponentElement.performRebuild (package:flutter/src/widgets/framework.dart:5496:16)
#83     StatefulElement.performRebuild (package:flutter/src/widgets/framework.dart:5634:11)
#84     Element.rebuild (package:flutter/src/widgets/framework.dart:5187:7)
#85     StatefulElement.update (package:flutter/src/widgets/framework.dart:5657:5)
#86     Element.updateChild (package:flutter/src/widgets/framework.dart:3815:15)
#87     ComponentElement.performRebuild (package:flutter/src/widgets/framework.dart:5496:16)
#88     Element.rebuild (package:flutter/src/widgets/framework.dart:5187:7)
#89     ProxyElement.update (package:flutter/src/widgets/framework.dart:5800:5)
#90     Element.updateChild (package:flutter/src/widgets/framework.dart:3815:15)
#91     ComponentElement.performRebuild (package:flutter/src/widgets/framework.dart:5496:16)
#92     StatefulElement.performRebuild (package:flutter/src/widgets/framework.dart:5634:11)
#93     Element.rebuild (package:flutter/src/widgets/framework.dart:5187:7)
#94     StatefulElement.update (package:flutter/src/widgets/framework.dart:5657:5)
#95     Element.updateChild (package:flutter/src/widgets/framework.dart:3815:15)
#96     ComponentElement.performRebuild (package:flutter/src/widgets/framework.dart:5496:16)
#97     StatefulElement.performRebuild (package:flutter/src/widgets/framework.dart:5634:11)
#98     Element.rebuild (package:flutter/src/widgets/framework.dart:5187:7)
#99     StatefulElement.update (package:flutter/src/widgets/framework.dart:5657:5)
#100    Element.updateChild (package:flutter/src/widgets/framework.dart:3815:15)
#101    ComponentElement.performRebuild (package:flutter/src/widgets/framework.dart:5496:16)
#102    Element.rebuild (package:flutter/src/widgets/framework.dart:5187:7)
#103    StatelessElement.update (package:flutter/src/widgets/framework.dart:5547:5)
#104    Element.updateChild (package:flutter/src/widgets/framework.dart:3815:15)
#105    ComponentElement.performRebuild (package:flutter/src/widgets/framework.dart:5496:16)
#106    Element.rebuild (package:flutter/src/widgets/framework.dart:5187:7)
#107    StatelessElement.update (package:flutter/src/widgets/framework.dart:5547:5)
#108    Element.updateChild (package:flutter/src/widgets/framework.dart:3815:15)
#109    ComponentElement.performRebuild (package:flutter/src/widgets/framework.dart:5496:16)
#110    StatefulElement.performRebuild (package:flutter/src/widgets/framework.dart:5634:11)
#111    Element.rebuild (package:flutter/src/widgets/framework.dart:5187:7)
#112    BuildOwner.buildScope (package:flutter/src/widgets/framework.dart:2895:19)
#113    WidgetsBinding.drawFrame (package:flutter/src/widgets/binding.dart:984:21)
#114    RendererBinding._handlePersistentFrameCallback (package:flutter/src/rendering/binding.dart:457:5)
#115    SchedulerBinding._invokeFrameCallback (package:flutter/src/scheduler/binding.dart:1325:15)
#116    SchedulerBinding.handleDrawFrame (package:flutter/src/scheduler/binding.dart:1255:9)
#117    SchedulerBinding._handleDrawFrame (package:flutter/src/scheduler/binding.dart:1113:5)
#118    _invoke (dart:ui/hooks.dart:312:13)
#119    PlatformDispatcher._drawFrame (dart:ui/platform_dispatcher.dart:383:5)
#120    _drawFrame (dart:ui/hooks.dart:283:31)
    * */

    MyDismissibleFuntions.onDismissedFunction(
        context, isGroup, groupsFromUser, itemIndex, itemsValue, productsFromSelectedGroup);
  }

  Widget buildMyBasicStructItem(BuildContext context) {
    return MyBasicStructItem(
      onTapFunction: () async {
        MyDismissibleFuntions.onTapFunction(
            context, isGroup, groupsFromUser, itemIndex, itemsValue, productsFromSelectedGroup, selectedGroupIndex);
      },
      content: buildItemContent(),
    );
  }

  Widget buildItemContent() {
    return isGroup
        ? MyGroupItem(myGroup: groupsFromUser.elementAt(itemIndex))
        : MyProductItem(
      myProduct: selectedGroupIndex != -1
          ? productsFromSelectedGroup[itemIndex]
          : MyProduct(
        barcode: "",
        productID: "",
        productName: "",
        selectedUserUUID: "",
        productCount: 0,
        productVolumen: "",
        productVolumenType: '',
        productImageUrl: "",
        productDescription: "",
      ),
      selectedGroupUUID: itemsValue.selectedGroupUUID,
    );
  }
}