import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:sportiwe_admin/configs/constants.dart';
import 'package:sportiwe_admin/configs/size_config.dart';
import 'package:sportiwe_admin/configs/style.dart';
import 'package:sportiwe_admin/models/venue_model.dart';

class VenueListWidget extends StatefulWidget {
  final VenueModel venueModel;
  const VenueListWidget({Key? key, required this.venueModel}) : super(key: key);

  @override
  _VenueListWidgetState createState() => _VenueListWidgetState();
}

class _VenueListWidgetState extends State<VenueListWidget> {
  VenueModel? venueModel;

  @override
  void initState() {
    this.venueModel = widget.venueModel;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // Navigator.pushNamed(
        //   NavigationCotroller.mainScreenNavigator.currentContext!,
        //   VenueDetailPage.routeName,
        //   arguments: widget.venueModel,
        // );
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: MySize.getScaledSizeHeight(5)),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(MySize.size6!),
        ),
        height: MySize.getScaledSizeHeight(170),
        child: Row(
          children: [
            getImageStack(venueModel!.imageList![0], venueModel!.name!),
            Expanded(
              child: getDescriptionColumn(
                address: venueModel!.address!,
                facilities: venueModel!.facilities!,
                timings: venueModel!.timings!,
              ),
            ),
          ],
        ),
      ),
    );
  }

  //Main UI Components
  Widget getImageStack(String image, String title) {
    print(image);
    return AspectRatio(
      aspectRatio: 1,
      child: Container(
        // color: Colors.amber,
        // height: MySize.getScaledSizeHeight(200),
        // width: MySize.getScaledSizeWidth(200),
        child: Stack(
          fit: StackFit.expand,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(MySize.size6!),
                  bottomLeft: Radius.circular(MySize.size6!)),
              child: Image.network(
                "$image",
                fit: BoxFit.cover,
              ),
            ),
            // Positioned(
            //     bottom: MySize.size40,
            //     left: MySize.getScaledSizeHeight(9),
            //     child: getRatings()),
            Positioned(
                bottom: MySize.size20,
                left: MySize.size10,
                child: getVenueTitle(title))
          ],
        ),
      ),
    );
  }

  Widget getDescriptionColumn({String? address, List<String>? facilities, String? timings}) {
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: MySize.size10!, vertical: MySize.size6!),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          getTitleText('Address:'),
          SizedBox(
            height: MySize.size2,
          ),
          getDetailText(address!),
          SizedBox(
            height: MySize.size6,
          ),
          getTitleText('Facilities'),
          SizedBox(
            height: MySize.size2,
          ),
          getVenuefacilitiesWidget(facilities!),
          SizedBox(
            height: MySize.size6,
          ),
          getTitleText('Timings:'),
          SizedBox(
            height: MySize.size2,
          ),
          getDetailText(timings!)
        ],
      ),
    );
  }

  Widget getVenueTitle(String title) {
    return Text(title,
        overflow: TextOverflow.ellipsis,
        maxLines: 2,
        style: TextStyle(
            fontSize: MySize.size14,
            fontFamily: 'Montserrat-Regular',
            color: Styles.white));
  }

  // Widget getRatings() {
  //   return Container(
  //     child: RatingBar.builder(
  //       unratedColor: Styles.background,
  //       itemSize: 15,
  //       initialRating: 3,
  //       minRating: 1,
  //       direction: Axis.horizontal,
  //       allowHalfRating: true,
  //       itemCount: 5,
  //       itemPadding: EdgeInsets.symmetric(horizontal: 2.0),
  //       itemBuilder: (context, _) => Icon(
  //         Icons.star,
  //         color: Colors.amber,
  //       ),
  //       onRatingUpdate: (rating) {
  //         print(rating);
  //       },
  //     ),
  //   );
  // }

  Widget getVenuefacilitiesWidget(List<String> facilities) {
    return Wrap(
      spacing: 5.0,
      runSpacing: 4.0,
      direction: Axis.horizontal,
      children: List.generate(
        facilities.length > 4 ? 4 : facilities.length,
        (index) {
          String facility = facilities[index];
          return getFacilitiesInfo(facility);
        },
      ),
      //clipBehavior: Clip.antiAlias,
    );
  }

  //Supporting UI Components
  Widget getTitleText(String title) {
    return Text(title,
        style: TextStyle(
            fontSize: MySize.size10,
            fontFamily: 'Montserrat-Regular',
            fontWeight: FontWeight.w600,
            color: Styles.white));
  }

  Widget getDetailText(String title) {
    return Text(
      title,
      overflow: TextOverflow.ellipsis,
      maxLines: 2,
      style: TextStyle(
          fontSize: MySize.size10,
          fontFamily: 'Montserrat-Regular',
          fontWeight: FontWeight.w400,
          color: Styles.white),
    );
  }

  Widget getFacilitiesInfo(String facilities) {
    //return Container();
     return Container(
        padding: EdgeInsets.all(MySize.size6!),
        decoration: BoxDecoration(
            color: Styles.white.withOpacity(.15),
            borderRadius: BorderRadius.circular(MySize.size3!)),
        child: Text(
          facilities,
          style: TextStyle(
              fontSize: MySize.size10,
              fontFamily: 'Montserrat-Regular',
              fontWeight: FontWeight.w400,
              color: Styles.white),
        )
      );
  }
}
