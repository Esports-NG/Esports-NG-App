import 'package:e_sport/data/model/category_model.dart';
import 'package:e_sport/data/repository/event_repository.dart';
import 'package:e_sport/ui/widget/custom_text.dart';
import 'package:e_sport/ui/widget/custom_textfield.dart';
import 'package:e_sport/util/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import '../components/account_event_widget.dart';

class EventsPage extends StatefulWidget {
  const EventsPage({super.key});

  @override
  State<EventsPage> createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> {
  bool? isSearch = false;
  final FocusNode _searchFocusNode = FocusNode();
  int? eventType = 0;
  final eventController = Get.put(EventRepository());
  @override
  void dispose() {
    _searchFocusNode.dispose();
    super.dispose();
  }

  void handleTap() {
    setState(() {
      isSearch = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: CustomText(
          title: 'Events',
          fontFamily: 'GilroySemiBold',
          size: 18,
          color: AppColor().primaryWhite,
        ),
      ),
      backgroundColor: AppColor().primaryBackGroundColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Divider(
              color: AppColor().primaryWhite.withOpacity(0.7),
              height: 1,
            ),
            Gap(Get.height * 0.025),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: Get.height * 0.02),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: Get.height * 0.06,
                    child: CustomTextField(
                      hint: "Search for gaming news, competitions...",
                      fontFamily: 'GilroyMedium',
                      prefixIcon: Icon(
                        CupertinoIcons.search,
                        color: AppColor().lightItemsColor,
                      ),
                      textEditingController: eventController.searchController,
                      hasText: isSearch!,
                      focusNode: _searchFocusNode,
                      onTap: handleTap,
                      onSubmited: (_) {
                        _searchFocusNode.unfocus();
                      },
                      onChanged: (value) {
                        setState(() {
                          isSearch = value.isNotEmpty;
                        });
                      },
                    ),
                  ),
                  Gap(Get.height * 0.025),
                  eventsCategory(),
                  Gap(Get.height * 0.01),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: Get.height * 0.01),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        eventFilterOption(title: 'Event Type'),
                        eventFilterOption(title: 'Status'),
                        eventFilterOption(title: 'Filter by Game'),
                      ],
                    ),
                  ),
                  Gap(Get.height * 0.03),
                  const AccountEventsWidget()
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  eventFilterOption({String? title}) {
    return InkWell(
      child: Container(
        padding: EdgeInsets.all(Get.height * 0.01),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColor().primaryWhite, width: 0.8)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CustomText(
              title: title,
              fontFamily: 'GilroyMedium',
              size: 12,
              color: AppColor().primaryWhite,
            ),
            Gap(Get.height * 0.01),
            Icon(
              Icons.keyboard_arrow_down,
              color: AppColor().primaryColor,
              size: 15,
            )
          ],
        ),
      ),
    );
  }

  eventsCategory() {
    return Container(
      height: Get.height * 0.045,
      padding: EdgeInsets.symmetric(horizontal: Get.height * 0.01),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const ScrollPhysics(),
        shrinkWrap: false,
        itemCount: eventsItem.length,
        separatorBuilder: (context, index) => Gap(Get.height * 0.05),
        itemBuilder: (context, index) {
          var item = eventsItem[index];
          return InkWell(
            onTap: () {
              setState(() {
                eventType = index;
              });
            },
            child: Center(
              child: Column(
                children: [
                  CustomText(
                    title: item.title,
                    size: 13,
                    fontFamily:
                        eventType == index ? 'GilroyBold' : 'GilroyMedium',
                    weight: FontWeight.w400,
                    textAlign: TextAlign.start,
                    color: eventType == index
                        ? AppColor().primaryColor
                        : AppColor().lightItemsColor,
                  ),
                  Gap(Get.height * 0.01),
                  Container(
                    width: Get.height * 0.1,
                    height: 1,
                    color: eventType == index
                        ? AppColor().primaryColor
                        : AppColor().primaryBackGroundColor,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
