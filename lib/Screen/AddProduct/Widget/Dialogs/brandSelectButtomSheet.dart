import 'package:flutter/material.dart';
import 'package:sellermultivendor/Widget/validation.dart';
import '../../../../Helper/Color.dart';
import '../../../../Helper/Constant.dart';
import '../../../../Model/BrandModel/brandModel.dart';
import '../../../../Provider/settingProvider.dart';
import '../../Add_Product.dart';

brandSelectButtomSheet(
  BuildContext context,
  Function setState,
) {
  showModalBottomSheet(
    isScrollControlled: true,
    context: context,
    backgroundColor: Colors.transparent,
    builder: (BuildContext context) {
      return Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(circularBorderRadius25),
            topRight: Radius.circular(circularBorderRadius25),
          ),
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(circularBorderRadius25),
            topRight: Radius.circular(circularBorderRadius25),
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 8.0, left: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Icon(Icons.arrow_back),
                      Text(
                        getTranslated(context, "Select Brand")!,
                        style: const TextStyle(
                          fontSize: textFontSize18,
                          color: primary,
                        ),
                      ),
                      Container(width: 2),
                    ],
                  ),
                ),
                Center(
                  child: ListView.builder(
                    shrinkWrap: true,
                    padding: const EdgeInsetsDirectional.only(
                        bottom: 5, start: 10, end: 10),
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: addProvider!.brandList.length,
                    itemBuilder: (context, index) {
                      BrandModel? item;

                      item = addProvider!.brandList.isEmpty
                          ? null
                          : addProvider!.brandList[index];

                      return item == null
                          ? Container()
                          : getbrands(
                              index,
                              context,
                              setState,
                            );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}

getbrands(int index, BuildContext context, Function setState) {
  return SingleChildScrollView(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: () {
            Navigator.pop(context);
            addProvider!.selectedBrandName = addProvider!.brandList[index].name;
            addProvider!.selectedBrandId = addProvider!.brandList[index].id;
            setState();
          },
          child: Column(
            children: [
              const Divider(),
              Row(
                children: [
                  addProvider!.selectedBrandId ==
                          addProvider!.brandList[index].id
                      ? Container(
                          height: 20,
                          width: 20,
                          decoration: const BoxDecoration(
                            color: grey2,
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Container(
                              height: 16,
                              width: 16,
                              decoration: const BoxDecoration(
                                color: primary,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                        )
                      : Container(
                          height: 20,
                          width: 20,
                          decoration: const BoxDecoration(
                            color: grey2,
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Container(
                              height: 16,
                              width: 16,
                              decoration: const BoxDecoration(
                                color: white,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                        ),
                  const SizedBox(
                    width: 10,
                  ),
                  SizedBox(
                    width: width * 0.6,
                    child: Text(
                      addProvider!.brandList[index].name!,
                      style: const TextStyle(
                        fontSize: textFontSize18,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
