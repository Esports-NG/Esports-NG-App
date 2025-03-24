import 'package:e_sport/ui/widget/custom_text.dart';
import 'package:e_sport/ui/widget/custom_textfield.dart';
import 'package:e_sport/util/colors.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class LeaderboardDropdown extends StatefulWidget {
  const LeaderboardDropdown(
      {super.key, required this.title, required this.left});

  final bool left;
  final String title;

  @override
  State<LeaderboardDropdown> createState() => _LeaderboardDropdownState();
}

class _LeaderboardDropdownState extends State<LeaderboardDropdown> {
  final OverlayPortalController _dropdownController = OverlayPortalController();
  final _link = LayerLink();
  final _scrollController = ScrollController();

  bool isShowing = false;

  void toggleDropdown() {
    _dropdownController.toggle();
    setState(() {
      isShowing = !isShowing;
    });
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _link,
      child: OverlayPortal(
        controller: _dropdownController,
        overlayChildBuilder: (context) => CompositedTransformFollower(
          link: _link,
          targetAnchor:
              widget.left ? Alignment.bottomLeft : Alignment.bottomRight,
          followerAnchor: widget.left ? Alignment.topLeft : Alignment.topRight,
          child: Align(
            alignment: widget.left
                ? AlignmentDirectional.topStart
                : AlignmentDirectional.topEnd,
            child: Container(
              margin: const EdgeInsets.only(top: 10),
              height: 280,
              width: 250,
              decoration: BoxDecoration(
                  color: AppColor().bgDark,
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(
                      color: AppColor().secondaryGreenColor, width: 1.5)),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 16, top: 16, bottom: 0, right: 16),
                    child: CustomTextField(
                      enabledBorder: BorderSide(
                        color: AppColor().lightItemsColor,
                        width: 1,
                      ),
                      hint: "Search",
                      prefixIcon: Icon(
                        Icons.search,
                        size: 20,
                        color: AppColor().primaryWhite,
                      ),
                    ),
                  ),
                  const Gap(20),
                  Expanded(
                    child: Scrollbar(
                      controller: _scrollController,
                      thumbVisibility: true,
                      child: ListView.separated(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          shrinkWrap: true,
                          itemBuilder: (context, index) => Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8),
                                child: CustomText(
                                  color: AppColor().greyOne,
                                  size: 18,
                                  title: "American dream",
                                ),
                              ),
                          separatorBuilder: (context, index) => Divider(
                                color: AppColor().greyEight,
                                thickness: 0.5,
                              ),
                          itemCount: 9),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(15),
          onTap: toggleDropdown,
          child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                  border: Border.all(
                      color: isShowing
                          ? AppColor().secondaryGreenColor
                          : AppColor().greyEight),
                  borderRadius: BorderRadius.circular(15)),
              child: Row(
                children: [
                  CustomText(
                    title: widget.title,
                    color: isShowing
                        ? AppColor().secondaryGreenColor
                        : AppColor().primaryWhite,
                    size: 16,
                  ),
                  const Spacer(),
                  Icon(
                    Icons.arrow_drop_down_rounded,
                    color: isShowing
                        ? AppColor().secondaryGreenColor
                        : AppColor().primaryWhite,
                  )
                ],
              )),
        ),
      ),
    );
  }
}
