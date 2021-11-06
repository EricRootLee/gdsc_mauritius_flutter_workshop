import 'package:flutter/material.dart';
import 'package:gdscworkshop/src/helpers/common/color_palette.dart';
import '../../utils/app_extenstions_util.dart';

class LocationCards extends StatelessWidget {
  final Function()? onTap;
  final String? imageUrl;
  final String? coordinates;
  final Key? key;

  LocationCards({this.onTap, this.imageUrl, this.coordinates, this.key})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    Widget _storeName() {
      return Expanded(
          child: Text(
        coordinates!,
        overflow: TextOverflow.ellipsis,
        style: Theme.of(context)
            .textTheme
            .headline1!
            .copyWith(fontSize: 18, color: Palette.grey),
      ));
    }

    return Padding(
      padding: EdgeInsets.all(8),
      child: InkWell(
          onTap: onTap,
          child: Container(
              height: MediaQuery.of(context).size.height * .11,
              width: double.infinity,
              child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black54,
                          offset: Offset(0.0, 1.0),
                          blurRadius: 4.0,
                        ),
                      ],
                      color: Colors.white),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                            child: context.cacheImage(
                          imgeUrl: imageUrl!,
                          width: MediaQuery.of(context).size.height * .125,
                          height: MediaQuery.of(context).size.height * .125,
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(10.0),
                              topLeft: Radius.circular(10.0)),
                        )),
                        SizedBox(
                          width: MediaQuery.of(context).size.height * .01,
                        ),
                        _storeName()
                      ])))),
    );
  }
}
